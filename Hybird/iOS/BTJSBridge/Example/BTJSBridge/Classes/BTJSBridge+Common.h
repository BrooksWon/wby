//
//  BTJSBridge+Common.h
//  BTJSBridge
//
//  Created by Brooks on 2019/4/26.
//

#import "BTJSBridge.h"

/**
 this.webviewAppearEvent = 'webviewAppear';
 this.webviewDisappearEvent = 'webviewDisappear';
 this.applicationEnterBackgroundEvent = 'applicationEnterBackground';
 this.applicationEnterForegroundEvent = 'applicationEnterForeground';
 
 */

FOUNDATION_EXTERN NSString * const BTJSBridgeAppEnterBackgroundEvent;
FOUNDATION_EXTERN NSString * const BTJSBridgeAppEnterForegroundEvent;


NS_ASSUME_NONNULL_BEGIN

@interface BTJSBridge (Common)

-(void)registCommonHandler;

-(void)applicationEnterForeground;

-(void)applicationEnterBackground;

-(void)addLifeCycleListenerCommon;

-(void)removeLifeCycleListenerCommon;

@end

NS_ASSUME_NONNULL_END
