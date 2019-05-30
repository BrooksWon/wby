//
//  BTJSBridge+ModuleA.m
//  BTJSBridge_Example
//
//  Created by Brooks on 2019/4/26.
//  Copyright © 2019 BrooksWon. All rights reserved.
//

#import "BTJSBridge+ModuleA.h"
#import "BTJSBridge+Common.h"


@implementation BTJSBridge (ModuleA)

//js调用oc，无回调
- (void)registerHandlerA1 {

    [self registerHandler:@"ModuleA" Action:@"testA1" handler:^(BTJSBridgeMessage *msg){
        NSLog(@"%s", __func__);
        [self test:msg];
        
    }];
}

//js调用oc，回调
- (void)registerHandlerA2 {
    
    [self registerHandler:@"ModuleA" Action:@"testA2" handler:^(BTJSBridgeMessage *msg){
        NSLog(@"%s", __func__);
        [self test:msg];
        
        [msg callback:@{@"你是?":@"保密"}];
    }];
}

//js调用oc，同步回调
- (void)registerHandlerA3 {
    
    [self registerHandler:@"ModuleA" Action:@"testA3" handler:^(BTJSBridgeMessage *msg){
        NSLog(@"%s", __func__);
        [self test:msg];
        
        [msg callback:@{@"你是?":@"保密"}];
    }];
}

- (void)test:(BTJSBridgeMessage *) msg{
    NSLog(@"%s, %@, %@", __func__, msg.action, msg.parameters);
}


@end
