//
//  BTJSBridge.m
//  BTJSBridge
//
//  Created by Brooks on 2019/4/26.
//

#import "BTJSBridge.h"
#import <UIKit/UIKit.h>
#import "WKWebViewCookieManager.h"

@interface BTJSBridge()

//bridge对象的内部字典属性，保存着所有外部注册的各种通信的处理block代码
@property (nonnull, nonatomic, strong) NSMutableDictionary * handlerMap;

@property (nonatomic, weak) WKWebView * webView;

@end
 
@implementation BTJSBridge

#pragma mark - public method
- (void)bindBridgeWithWebView:(WKWebView *)webView {
    self.webView = webView;
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
}

#pragma mark - private method

-(void)injectMessageFuction:(NSString *)msg withActionId:(NSString *)actionId withParams:(NSDictionary *)params withCallback:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))handler{
    if (!params) {
        params = @{};
    }
    NSString *paramsString = [self _serializeMessageData:params];
    NSString *paramsJSString = [self _transcodingJavascriptMessage:paramsString];
    NSString* javascriptCommand = [NSString stringWithFormat:@"%@('%@', '%@');", msg,actionId,paramsJSString];
    
    if ([[NSThread currentThread] isMainThread]) {
        [self.webView evaluateJavaScript:javascriptCommand completionHandler:handler];
    } else {
        __strong typeof(self)strongSelf = self;
        dispatch_sync(dispatch_get_main_queue(), ^{
            [strongSelf.webView evaluateJavaScript:javascriptCommand completionHandler:handler];
        });
    }
}

// 字典JSON化
- (NSString *)_serializeMessageData:(id)message{
    if (message) {
        return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    }
    return nil;
}
// JSON Javascript编码处理
- (NSString *)_transcodingJavascriptMessage:(NSString *)message
{
    message = [message stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    message = [message stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    message = [message stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    message = [message stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    message = [message stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    message = [message stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    message = [message stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
    message = [message stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];
    
    return message;
}

#pragma mark - property
- (NSMutableDictionary *)handlerMap {
    if (!_handlerMap) {
        _handlerMap = [[NSMutableDictionary alloc]init];
    }
    return _handlerMap;
}

@end

@implementation BTJSBridge (JC_CALL_OC)

static BOOL hadAddScriptMessageHandler = NO;

#pragma mark - public method

-(void)registerHandler:(NSString *)handlerName Action:(NSString *)actionName handler:(HandlerBlock)handler{
    if (handlerName && actionName && handler) {
        NSMutableDictionary *handlerDic = [self.handlerMap objectForKey:handlerName];
        if (!handlerDic) {
            handlerDic = [[NSMutableDictionary alloc]init];
        }
        [self.handlerMap setObject:handlerDic forKey:handlerName];
        [handlerDic setObject:handler forKey:actionName];

        if (!hadAddScriptMessageHandler) {
            [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"BTJSBridge"];
            hadAddScriptMessageHandler = YES;
        }
    }
}

-(void)removeHandler:(NSString *)handlerName{
    if (handlerName) {
        [self.handlerMap removeObjectForKey:handlerName];
    }
}

- (void)dealloc {
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"BTJSBridge"];
}

#pragma mark - delegate
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSDictionary *msgBody = message.body;
    if (msgBody) {
        BTJSBridgeMessage *msg = [[BTJSBridgeMessage alloc]initWithDictionary:msgBody];
        NSDictionary *handlerDic = [self.handlerMap objectForKey:msg.handler];
        HandlerBlock handler = [handlerDic objectForKey:msg.action];
        //处理回调
        if (msg.callbackID && msg.callbackID.length > 0) {
            __weak typeof(self)weakSelf = self;
            //生成OC的回调block，输入参数是，任意字典对象的执行结果
            JSResponseCallback callback = ^(id responseData){
                //执行OC 主动 Call JS 的编码与通信
                [weakSelf injectMessageFuction:msg.callbackFunction withActionId:msg.callbackID withParams:responseData withCallback:^(id _Nullable obj, NSError * _Nullable error) {
                    NSLog(@"obj = %@\n error = %@", obj,error);
                }];
            };
            [msg setCallback:callback];
        }
        if (handler){
            handler(msg);
        }
    }
    
    //通过代理转发到业务中去
    if ([self.delegate respondsToSelector:@selector(bt_userContentController:didReceiveScriptMessage:)]) {
        [self.delegate bt_userContentController:userContentController didReceiveScriptMessage:message];
    }
}


/** Prompt
 
    作为js中prompt接口的实现，默认需要有一个输入框一个按钮，点击确认按钮回传输入值
    当然可以添加多个按钮以及多个输入框，不过completionHandler只有一个参数，如果有多个输入框，需要将多个输入框中的值通过某种方式拼接成一个字符串回传，js接收到之后再做处理
 
    参数 prompt 为 prompt(<message>, <defaultValue>);中的<message>
    参数defaultText 为 prompt(<message>, <defaultValue>);中的 <defaultValue>
 */
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler{
    if (webView != self.webView) {
        completionHandler(@"");
        return;
    }
    
    NSData *jsonData = [prompt dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    //可以看出来，消息体结构不变，所有逻辑保持和异步一致
    BTJSBridgeMessage *msg = [[BTJSBridgeMessage alloc] initWithDictionary:dic];
    NSDictionary *handlerDic = [self.handlerMap objectForKey:msg.handler];
    HandlerBlock handler = [handlerDic objectForKey:msg.action];
    handler(msg);
    //修改 msg的callback方法，当发现是同步消息的时候，callback在block执行完毕后将数据保存到msg的syncReturn中
    NSString *resultjson = [self _serializeMessageData:msg.syncReturn];
    completionHandler(resultjson);
    
     //通过代理转发到业务中去
    if ([self.delegate respondsToSelector:@selector(bt_webView:runJavaScriptTextInputPanelWithPrompt:defaultText:initiatedByFrame:completionHandler:)]) {
        [self.delegate bt_webView:webView runJavaScriptTextInputPanelWithPrompt:prompt defaultText:defaultText initiatedByFrame:frame completionHandler:completionHandler];
    }
}

/**  Alert
    此方法作为js的alert方法接口的实现，默认弹出窗口应该只有提示信息及一个确认按钮，当然可以添加更多按钮以及其他内容，但是并不会起到什么作用
    点击确认按钮的相应事件需要执行completionHandler，这样js才能继续执行
 
    参数 message为  js 方法 alert(<message>) 中的<message>
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler{

    
    NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
     UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:@""
                                                           message:message
                                                          delegate:nil
                                                 cancelButtonTitle:@"done"
                                                 otherButtonTitles:nil];
     [customAlert show];
    
    completionHandler(@" hahahahahahaha ");
}


/** Confirm
 
    作为js中confirm接口的实现，需要有提示信息以及两个相应事件， 确认及取消，并且在completionHandler中回传相应结果，确认返回YES， 取消返回NO
 
    参数 message为  js 方法 confirm(<message>) 中的<message>
 */
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler{
    
    completionHandler(@" hahahahahahaha ");
    

//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        completionHandler(YES);
//    }]];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//        completionHandler(NO);
//    }]];
//    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - WKNavigationDelegate

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    /*
     解决内存过大引起的白屏问题
     */
    [webView reload];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    /*
     //如果是302重定向请求，此处拦截带上cookie重新request
     WKWebViewCookieManager *newRequest = [WKWebViewCookieManager newRequest:navigationAction.request];
     [webView loadRequest:newRequest];
     */
    decisionHandler(WKNavigationActionPolicyAllow);
}


@end

@implementation BTJSBridge (OC_CALL_JS)

-(void)sendEventName:(NSString *)event withParams:(NSDictionary *)params withCallback:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))handler{
    NSString *jsFunction = @"window.eventDispatcher";

    [self injectMessageFuction:jsFunction withActionId:event withParams:params withCallback:handler];
}

@end
