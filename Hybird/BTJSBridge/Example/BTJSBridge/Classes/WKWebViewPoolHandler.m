//
//  WKWebViewPoolHandler.m
//  BTJSBridge_Example
//
//  Created by Brooks on 2019/5/28.
//  Copyright © 2019 BrooksWon. All rights reserved.
//

#import "WKWebViewPoolHandler.h"
#import <WebKit/WebKit.h>

@interface WKWebViewPoolHandler()
@property (nonatomic, strong) WKProcessPool *pool;
@end

@implementation WKWebViewPoolHandler

+ (instancetype)sharedInstance{
    static id sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance= [[self alloc] initPrivate];
    });
    return sharedInstance;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        self.pool = [WKProcessPool new];
    }
    return self;
}

- (WKProcessPool *)defaultPool{
    return self.pool;
}

@end
