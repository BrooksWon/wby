//
//  WKWebViewCookieManager.h
//  BTJSBridge_Example
//
//  Created by Brooks on 2019/5/28.
//  Copyright © 2019 BrooksWon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWebViewCookieManager : NSObject

+ (void)syncRequestCookie:(NSMutableURLRequest *)request;
+ (NSString *)clientCookieScripts;
+ (NSMutableURLRequest *)newRequest:(NSURLRequest *)request;
@end

NS_ASSUME_NONNULL_END
