//
//  BTViewController.m
//  BTJSBridge
//
//  Created by BrooksWon on 04/26/2019.
//  Copyright (c) 2019 BrooksWon. All rights reserved.
//

#import "BTViewController.h"

#import <WebKit/WebKit.h>

#import "BTJSBridge+Common.h"
#import "BTJSBridge+ModuleA.h"
#import "WKWebView+BTJSBridge.h"



@interface BTViewController () <BTJSBridgeDelegate>
@property (nonatomic, strong) BTJSBridge *jsBridge;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation BTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //绑定Bridge
    [self.jsBridge bindBridgeWithWebView:self.webView];
    
    [self.jsBridge registerHandlerA1];
    [self.jsBridge registerHandlerA2];
    [self.jsBridge registerHandlerA3];    
    
    
    self.webView.frame = self.view.bounds;
    [self.view addSubview:self.webView];
    
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]]];
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSString *htmlPath = [htmlFile.mutableCopy stringByReplacingOccurrencesOfString:@"test.html" withString:@""];
    //获取本地html目录 baseUrl
    NSURL *baseUrl = [NSURL fileURLWithPath: htmlPath isDirectory: YES];
    NSString *htmlContent = [NSString stringWithContentsOfFile: htmlFile encoding: NSUTF8StringEncoding error:nil];

    [self.webView loadHTMLString:htmlContent baseURL:baseUrl];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.jsBridge sendEventName:@"nativetojs" withParams:@{@"你是?":@"保密"} withCallback:^(id _Nullable obj, NSError * _Nullable error) {
            NSLog(@"%@ - %@", obj, error);
        }];
    });
    
    
}

- (void)dealloc {
    [self.jsBridge removeLifeCycleListenerCommon];
}

#pragma mark - BTJSBridgeDelegate method

- (void)bt_userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    
    
    NSLog(@"msg = %@", message);
    
    
    
}


- (void)bt_webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    
    
    NSLog(@"prompt = %@", prompt);
}

- (void)bt_webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
}

- (void)bt_webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(nonnull NSString *)message initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(BOOL))completionHandler {
    
}


#pragma mark - getters and setters
- (WKWebView *)webView
{
    if (_webView == nil) {
        
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        config.preferences = [WKPreferences new];
        config.preferences.minimumFontSize = 10;
        config.preferences.javaScriptEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        
        _webView = [WKWebView bt_WKWebViewWithConfiguration:config prefixUserAgent:@"wby-测试-"];
    }
    return _webView;
}

- (BTJSBridge *)jsBridge {
    if (_jsBridge == nil) {
        _jsBridge = [[BTJSBridge alloc]init];
    }
    _jsBridge.delegate = self;
    
    return _jsBridge;
}

@end
