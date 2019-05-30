//
//  WKWebView+BTJSBridge.h
//  BTJSBridge
//
//  Created by Brooks on 2019/4/30.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (BTJSBridge)
+ (WKWebView *)bt_WKWebViewWithConfiguration:(WKWebViewConfiguration *)configuration prefixUserAgent:(NSString *)prefixUserAgent;
@end

NS_ASSUME_NONNULL_END
