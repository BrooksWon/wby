//
//  WKWebViewPoolHandler.h
//  BTJSBridge_Example
//
//  Created by Brooks on 2019/5/28.
//  Copyright © 2019 BrooksWon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWebViewPoolHandler : NSObject

+ (instancetype)sharedInstance;
- (WKProcessPool *)defaultPool;

@end

NS_ASSUME_NONNULL_END
