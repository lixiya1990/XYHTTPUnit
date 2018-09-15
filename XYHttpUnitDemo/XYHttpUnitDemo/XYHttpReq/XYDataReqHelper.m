//
//  XYDataReqHelper.m
//  XYHttpUnitDemo
//
//  Created by lxy on 2017/12/4.
//  Copyright © 2017年 lxy. All rights reserved.
//

#import "XYDataReqHelper.h"
#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>

/** 接口版本 */
#define kApiVersion @"v1"

@implementation XYDataReqHelper

- (instancetype)init {
    self = [super init];
    if (self) {
    
    }
    return self;
}


#pragma mark - Publics
- (void)clearHeaders {
   
}

- (void)setHeaderFieldValue:(NSString *)value forKey:(NSString *)key {
    [[XYHttpManager sharedInstance].requestSerializer setValue:value forHTTPHeaderField:key];
}

- (NSMutableDictionary *)commonArgumentWithUserParameters:(NSDictionary *)parameters {
    NSMutableDictionary *argument = nil;
    if (parameters) {
        argument = [NSMutableDictionary dictionaryWithDictionary:parameters];
    } else {
        argument = @{}.mutableCopy;
    }
    
    return argument;
}

#pragma mark - Base Function
- (void)reponseURL:(NSString *)URLString
     completeBlock:(CompleteBlock)completeBlock
            result:(XYResult *)result {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (completeBlock) {
            completeBlock(nil, result);
        }
    });
    
    //处理登陆失效
}

#pragma mark - 请求方法
- (void)postJsonWithURL:(NSString *)URLString
                       parameters:(NSDictionary *)parameters
                    completeBlock:(CompleteBlock)completeBlock {
    NSMutableDictionary *param = [self commonArgumentWithUserParameters:parameters];
    [[XYHttpManager sharedInstance] requestURL:URLString
                                jsonParameters:param
                                 completeBlock:^(NSURLSessionTask *task, XYResultUnit *resultUnit) {
                                     
                                     XYResult *result = (XYResult *)resultUnit;
                                     [self reponseURL:URLString completeBlock:completeBlock result:result];
                                     NSLog(@"网络请求结果:url=%@:\n param=%@ \n result.response=%@",[NSString stringWithFormat:@"%@/%@",@"",URLString],parameters,result.response);
                                     
                                 }];
}


- (void)requestURL:(NSString *)URLString
        HTTPMethod:(XYHTTPMethod)method
        parameters:(NSDictionary *)parameters
     completeBlock:(CompleteBlock)completeBlock {
  
    [[XYHttpManager sharedInstance] requestURL:URLString
                                    HTTPMethod:method
                                    parameters:parameters
                            cacheArgumentBlock:nil
                                uploadProgress:nil
                              downloadProgress:nil
                                 completeBlock:^(NSURLSessionTask *task, XYResultUnit *resultUnit) {
                                     
                                     XYResult *result = (XYResult *)resultUnit;
                                     [self reponseURL:URLString completeBlock:completeBlock result:result];
                                     NSLog(@"网络请求结果:url=%@:\n param=%@ \n result.response=%@",[NSString stringWithFormat:@"%@/%@",nil,URLString],parameters,result.response);
                                     
                                 }];

}
              
@end
