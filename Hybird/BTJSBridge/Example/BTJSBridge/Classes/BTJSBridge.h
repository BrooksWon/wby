//
//  BTJSBridge.h
//  BTJSBridge
//
//  Created by Brooks on 2019/4/26.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "BTJSBridgeMessage.h"
#import "BTJSBridgeDelegate.h"

typedef void(^HandlerBlock)(BTJSBridgeMessage * _Nullable msgObject);

NS_ASSUME_NONNULL_BEGIN

@interface BTJSBridge : NSObject
@property (nonatomic, weak) id<BTJSBridgeDelegate> delegate;

- (void)bindBridgeWithWebView:(WKWebView *)webView;
@end

@interface BTJSBridge (JC_CALL_OC) <WKUIDelegate,WKScriptMessageHandler,WKNavigationDelegate>
-(void)registerHandler:(NSString *)handlerName Action:(NSString *)actionName handler:(HandlerBlock)handler;
-(void)removeHandler:(NSString *)handlerName;
@end

@interface BTJSBridge (OC_CALL_JS)
-(void)sendEventName:(NSString *)event withParams:(NSDictionary * _Nullable )params withCallback:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))handler;
@end

NS_ASSUME_NONNULL_END
