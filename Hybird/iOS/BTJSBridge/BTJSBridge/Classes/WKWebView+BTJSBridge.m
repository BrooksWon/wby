//
//  WKWebView+BTJSBridge.m
//  BTJSBridge
//
//  Created by Brooks on 2019/4/30.
//

#import "WKWebView+BTJSBridge.h"
#import "WKWebViewCookieManager.h"
#import "WKWebViewPoolHandler.h"

@implementation WKWebView (BTJSBridge)

+ (WKWebView *)bt_WKWebViewWithConfiguration:(WKWebViewConfiguration *)configuration prefixUserAgent:(NSString *)prefixUserAgent
{
    NSString *bridgeJSString = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BTJSBridge" ofType:@"js"] encoding:NSUTF8StringEncoding error:NULL];
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:bridgeJSString injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    
    WKWebViewConfiguration *webviewConfiguration = configuration;
    if (webviewConfiguration == nil) {
        webviewConfiguration = [[WKWebViewConfiguration alloc] init];
    }
    configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.preferences.javaScriptEnabled = YES;
    configuration.processPool = [[WKWebViewPoolHandler sharedInstance] defaultPool];
    
    if (webviewConfiguration.userContentController == nil) {
        webviewConfiguration.userContentController = [[WKUserContentController alloc] init];
    }
    [webviewConfiguration.userContentController addUserScript:userScript];
    
    //添加cookie
    WKUserScript *cookieUserScript = [[WKUserScript alloc] initWithSource:[WKWebViewCookieManager clientCookieScripts] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [webviewConfiguration.userContentController addUserScript:cookieUserScript];
    
    
    WKWebView *webview = [[WKWebView alloc] initWithFrame:CGRectZero configuration:webviewConfiguration];
    
    if (prefixUserAgent != nil) {
        [webview evaluateJavaScript:@"navigator.userAgent" completionHandler:^(NSString * _Nullable originUserAgent, NSError * _Nullable error) {
            if ([originUserAgent hasPrefix:prefixUserAgent] == NO) {
                NSString *newUserAgent = [NSString stringWithFormat:@"%@%@", prefixUserAgent, originUserAgent];
                [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":newUserAgent}];
                if (@available(iOS 9.0, *)) {
                    webview.customUserAgent = newUserAgent;
                } 
            }
        }];
    }
    
    return webview;
}

@end
