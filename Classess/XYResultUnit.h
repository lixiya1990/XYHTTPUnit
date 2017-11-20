//
//  XYResultUnit.h
//  Test
//
//  Created by lxy on 2017/11/9.
//  Copyright © 2017年 lxy. All rights reserved.
//  具体的处理逻辑根据项目请求接口返回的结果来定，在实际项目中继承该类扩展。

#import <Foundation/Foundation.h>

@interface XYResultUnit : NSObject

/** 该值代表该结果集的业务数据是否能够存储到缓存中使用，大部分情况指的是业务数据返回成功即可，除非业务数据返回成功但是数据为空*/
@property (nonatomic, readonly) BOOL  ableCache;
/** 该结果错误实例，当一些请求错误时为真*/
@property (nonatomic, strong, readonly) NSError *error;
/** 原始数据，历史请求成功的数据*/
@property (nonatomic, assign, readonly) id responseObject;
/** 是否当前的数据从缓存获得*/
@property (nonatomic, readonly, assign, getter = isDataFromCache) BOOL dataFromCache;
/** 是否是错误的网络请求,用户无网络或者服务器崩溃的离线数据使用， 默认是NO,代表成功的请求*/
@property (nonatomic, readonly, assign, getter = isFailureRequest) BOOL failureRequest;

- (void)setError:(NSError *)error;
- (void)setResponseObject:(id)responseObject;
- (void)setDataFromCache:(BOOL)fromCache;
- (void)setFailureRequest:(BOOL)failureRequest;

+ (XYResultUnit *)resultWithError:(NSError *)error;
+ (XYResultUnit *)resultWithResponseObject:(NSDictionary *)responseObject;

@end
