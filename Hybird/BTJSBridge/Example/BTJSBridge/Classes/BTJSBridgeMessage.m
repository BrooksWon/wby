//
//  BTJSBridgeMessage.m
//  BTJSBridge
//
//  Created by Brooks on 2019/4/26.
//

#import "BTJSBridgeMessage.h"

@interface BTJSBridgeMessage()
@property (nonatomic, copy) JSResponseCallback rspCallback;

@property (nonatomic, copy, readwrite) NSString * handler;
@property (nonatomic, copy, readwrite) NSString * action;
@property (nonatomic, copy, readwrite) NSDictionary * parameters;
@property (nonatomic, copy, readwrite) NSString * callbackID;
@property (nonatomic, copy, readwrite) NSString  *callbackFunction;

@end

@implementation BTJSBridgeMessage

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.handler = [dict objectForKey:NSStringFromSelector(@selector(handler))];
        self.action = [dict objectForKey:NSStringFromSelector(@selector(action))];
        self.parameters = [dict objectForKey:NSStringFromSelector(@selector(parameters))];
        self.callbackID = [dict objectForKey:NSStringFromSelector(@selector(callbackID))];
        self.callbackFunction = [dict objectForKey:NSStringFromSelector(@selector(callbackFunction))];
    }
    
    return self;
}

- (void)setCallback:(JSResponseCallback)callback {
    self.rspCallback = callback;
}

- (void)callback:(NSDictionary *)result {
    self.rspCallback(result);
}

@end
