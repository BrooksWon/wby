//
//  BTJSBridgeMessage.h
//  BTJSBridge
//
//  Created by Brooks on 2019/4/26.
//

#import <Foundation/Foundation.h>

typedef void (^JSResponseCallback)(NSDictionary* responseData);

NS_ASSUME_NONNULL_BEGIN

@interface BTJSBridgeMessage : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dict NS_DESIGNATED_INITIALIZER;
-(instancetype)init UNAVAILABLE_ATTRIBUTE;
+(instancetype)new UNAVAILABLE_ATTRIBUTE;

@property (nonatomic, copy, readonly) NSString * handler;
@property (nonatomic, copy, readonly) NSString * action;
@property (nonatomic, copy, readonly) NSDictionary * parameters;
@property (nonatomic, copy, readonly) NSString * callbackID;
@property (nonatomic, copy, readonly) NSString  *callbackFunction;
@property (nonatomic, copy, readonly) NSString  *syncReturn; 

-(void)setCallback:(JSResponseCallback)callback;

-(void)callback:(NSDictionary *)result;

@end

NS_ASSUME_NONNULL_END
