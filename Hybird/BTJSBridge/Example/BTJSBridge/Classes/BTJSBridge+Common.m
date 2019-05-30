//
//  BTJSBridge+Common.m
//  BTJSBridge
//
//  Created by Brooks on 2019/4/26.
//

#import "BTJSBridge+Common.h"

/**
 this.webviewAppearEvent = 'webviewAppear';
 this.webviewDisappearEvent = 'webviewDisappear';
 this.applicationEnterBackgroundEvent = 'applicationEnterBackground';
 this.applicationEnterForegroundEvent = 'applicationEnterForeground';
 
 */

NSString * const BTJSBridgeAppEnterBackgroundEvent = @"applicationEnterBackground";
NSString * const BTJSBridgeAppEnterForegroundEvent = @"applicationEnterForeground";

@implementation BTJSBridge (Common)

#pragma mark - public method

-(void)registCommonHandler{
    [self addLifeCycleListenerCommon];
    __weak typeof(self) weakSelf = self;
    
    [self registerHandler:@"Common" Action:@"commonParams" handler:^(BTJSBridgeMessage *msg) {
        NSDictionary *result = [weakSelf getCommonParams];
        [msg callback:result];
    }];
    
    [self registerHandler:@"Common" Action:@"copyContent" handler:^(BTJSBridgeMessage *msg) {
        NSDictionary *params = msg.parameters;
        NSString *content = [params objectForKey:@"str"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = content;
    }];
    
    [self registerHandler:@"Common" Action:@"nativeLog" handler:^(BTJSBridgeMessage *msg) {
        [weakSelf nativeLog:msg.parameters];
    }];
    [self registerHandler:@"Common" Action:@"crashTrace" handler:^(BTJSBridgeMessage *msg) {
        [weakSelf crashTrace:msg.parameters];
    }];
}

-(void)applicationEnterForeground{
    [self sendEventName:BTJSBridgeAppEnterForegroundEvent withParams:nil withCallback:nil];
}

-(void)applicationEnterBackground{
    [self sendEventName:BTJSBridgeAppEnterBackgroundEvent withParams:nil withCallback:nil];
}

-(void)addLifeCycleListenerCommon{
    // app从后台进入前台都会调用这个方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    // 添加检测app进入后台的观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
}

-(void)removeLifeCycleListenerCommon{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - private method
- (NSDictionary *)getCommonParams {
    // to do something
    
    return nil;
}

- (void)nativeLog:(NSDictionary *)dic {
    NSLog(@"%s,%@", __func__ , dic);
    
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"%@ = %@", key, obj);
    }];
}

- (void)crashTrace:(NSDictionary *)dic {
    NSLog(@"%s,%@", __func__ , dic);
    
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"%@ = %@", key, obj);
    }];
}


@end
