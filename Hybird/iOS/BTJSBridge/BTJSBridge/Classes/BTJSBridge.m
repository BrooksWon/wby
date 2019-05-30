//
//  BTJSBridge.m
//  BTJSBridge
//
//  Created by Brooks on 2019/4/26.
//

#import "BTJSBridge.h"

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
}

#pragma mark - private method

-(void)injectMessageFuction:(NSString *)msg withActionId:(NSString *)actionId withParams:(NSDictionary *)params withCallback:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))handler{
    if (!params) {
        params = @{};
    }
//    NSString *paramsString = [self _serializeMessageData:params];
//    NSString *paramsJSString = [self _transcodingJavascriptMessage:paramsString];
//    NSString* javascriptCommand = [NSString stringWithFormat:@"%@('%@', '%@');", msg,actionId,paramsJSString];
    if ([[NSThread currentThread] isMainThread]) {
        NSString *paramsString = [self _serializeMessageData:params];
        NSString *paramsJSString = [self _transcodingJavascriptMessage:paramsString];
        NSString* javascriptCommand = [NSString stringWithFormat:@"%@('%@', '%@');", msg,actionId,paramsJSString];
//        [self.webView evaluateJavaScript:javascriptCommand completionHandler:handler];
        [self.webView evaluateJavaScript:javascriptCommand completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"%@----%@",result, error);
        }];
    } else {
        __strong typeof(self)strongSelf = self;
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSString *paramsString = [self _serializeMessageData:params];
            NSString *paramsJSString = [self _transcodingJavascriptMessage:paramsString];
            NSString* javascriptCommand = [NSString stringWithFormat:@"%@('%@', '%@');", msg,actionId,paramsJSString];
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
    //NSLog(@"dispatchMessage = %@",message);
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
        
        /**
         苹果WKWebView scriptMessageHandler注入 - JS调用
         
         addScriptMessageHandler方法注入的对象被放到了，全局对象下一个Webkit对象下面，想要拿到这个对象需要这样拿： 'window.webkit.messageHandlers.nativeObject'。
         
         而addScriptMessageHandler注入其实只给注入对象起了一个名字nativeObject，但这个对象的能力是不能任意指定的，只有一个函数postMessage，因此JS的调用方式也只能是：
         
             'js侧代码: window.webkit.messageHandlers.nativeObject.postMessage(data)'。
         
         */
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
    // addScriptMessageHandler 很容易导致循环引用
    // 业务控制器 强引用了WKWebView,WKWebView copy(强引用了）configuration， configuration copy （强引用了）userContentController
    // userContentController 强引用了 self （控制器）
    // 因此这里要记得移除handlers
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"BTJSBridge"];
    
//    for (NSString *action in [(NSDictionary*)self.handlerMap.allValues allKeys]) {
//        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:action];
//    }
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

// 显示一个按钮。点击后调用completionHandler回调
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler();
    }]];
//    [self presentViewController:alertController animated:YES completion:nil];
}

// 显示两个按钮，通过completionHandler回调判断用户点击的确定还是取消按钮
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(YES);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(NO);
    }]];
//    [self presentViewController:alertController animated:YES completion:nil];
    
}

@end

@implementation BTJSBridge (OC_CALL_JS)

-(void)sendEventName:(NSString *)event withParams:(NSDictionary *)params withCallback:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))handler{
//    NSString *jsFunction = @'window.eventDispatcher';
    NSString *jsFunction = @"testCallback";
    NSString *paramsString = [self _serializeMessageData:params];
    NSString *paramsJSString = [self _transcodingJavascriptMessage:paramsString];
    NSString* javascriptCommand = [NSString stringWithFormat:@"%@('%@');", jsFunction,paramsJSString];
    if ([[NSThread currentThread] isMainThread]) {
        [self.webView evaluateJavaScript:javascriptCommand completionHandler:handler];
    } else {
        __strong typeof(self)strongSelf = self;
        dispatch_sync(dispatch_get_main_queue(), ^{
            [strongSelf.webView evaluateJavaScript:javascriptCommand completionHandler:handler];
        });
    }
    
//    [self injectMessageFuction:jsFunction withActionId:event withParams:params withCallback:handler];
}

@end
