//
//  WKWebView+BTJSBridge.m
//  BTJSBridge
//
//  Created by Brooks on 2019/4/30.
//

#import "WKWebView+BTJSBridge.h"

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
    
    if (webviewConfiguration.userContentController == nil) {
        webviewConfiguration.userContentController = [[WKUserContentController alloc] init];
    }
    [webviewConfiguration.userContentController addUserScript:userScript];
//    [webviewConfiguration.userContentController addScriptMessageHandler:nil name:@"Some Object"];

    
    
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
