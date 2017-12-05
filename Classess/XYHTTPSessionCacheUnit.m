//
//  XYHTTPSessionCacheUnit.m
//  Test
//
//  Created by lxy on 2017/11/9.
//  Copyright © 2017年 lxy. All rights reserved.
//

#import "XYHTTPSessionCacheUnit.h"
#import "XYCacheUnit.h"
#import "NSString+XYCache.h"

@implementation XYHTTPSessionCacheUnit

- (NSURLSessionDataTask *)request:(NSURLRequest *)request
                    completeBlock:(OperationCompleteBlock)completeBlock {
    return [self request:request uploadProgress:nil downloadProgress:nil completeBlock:completeBlock];
}

- (NSURLSessionDataTask *)request:(NSURLRequest *)request
                   uploadProgress:(void (^)(NSProgress * _Nonnull))uploadProgressBlock
                 downloadProgress:(void (^)(NSProgress * _Nonnull))downloadProgressBlock
                    completeBlock:(OperationCompleteBlock)completeBlock {
    
    NSURLSessionDataTask *dataTask = nil;
    dataTask = [self request:request uploadProgress:uploadProgressBlock downloadProgress:downloadProgressBlock success:^(NSURLSessionTask * _Nonnull task, id  _Nullable responseObject) {
        [self operationSuccessWithNSURLSessionTask:task
                                    responseObject:responseObject
                                     cacheArgument:nil
                                     completeBlock:completeBlock];
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        [self operationFailureWithNSURLSessionTask:task
                                             error:error
                                     cacheArgument:nil
                                     completeBlock:completeBlock];
    }];
    return dataTask;
}

- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                      jsonParameters:(NSDictionary *)parameters
                       completeBlock:(OperationCompleteBlock)completeBlock {
    NSURLSessionDataTask *dataTask = nil;
    dataTask = [self requestURL:URLString jsonParameters:parameters success:^(NSURLSessionTask * _Nonnull task, id  _Nullable responseObject) {
        [self operationSuccessWithNSURLSessionTask:task
                                    responseObject:responseObject
                                     cacheArgument:nil
                                     completeBlock:completeBlock];
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        [self operationFailureWithNSURLSessionTask:task
                                             error:error
                                     cacheArgument:nil
                                     completeBlock:completeBlock];
    }];
    return dataTask;
}


- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                          parameters:(id)parameters
              multipartFormArguments:(NSArray<XYMultipartFormArgument *> *)formArguments
                            progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                       completeBlock:(OperationCompleteBlock)completeBlock {
    return [self requestURL:URLString parameters:parameters multipartFormArguments:formArguments progress:uploadProgress success:^(NSURLSessionTask * _Nonnull task, id  _Nullable responseObject) {
        [self operationSuccessWithNSURLSessionTask:task
                                    responseObject:responseObject
                                     cacheArgument:nil
                                     completeBlock:completeBlock];
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        [self operationFailureWithNSURLSessionTask:task
                                             error:error
                                     cacheArgument:nil
                                     completeBlock:completeBlock];
    }];
    
}


- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                          HTTPMethod:(XYHTTPMethod)method
                          parameters:(id)parameters
                       completeBlock:(OperationCompleteBlock)completeBlock {
    return [self requestURL:URLString HTTPMethod:method parameters:parameters cacheArgumentBlock:nil uploadProgress:nil downloadProgress:nil completeBlock:completeBlock];
}


- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                          HTTPMethod:(XYHTTPMethod)method
                          parameters:(id)parameters
                  cacheArgumentBlock:(void (^)(XYCacheArgument * _Nonnull))cacheArgumentBlock
                      uploadProgress:(void (^)(NSProgress * _Nonnull))uploadProgress
                    downloadProgress:(void (^)(NSProgress * _Nonnull))downloadProgress
                       completeBlock:(OperationCompleteBlock)completeBlock {
    
    NSString *key = [self cacheKeyWithBaseURL:[[self baseURL] absoluteString] requestUR:URLString HTTPMethod:method parameters:parameters];
    
    XYCacheArgument *cacheArgument = [[XYCacheArgument alloc] initWithKey:key];
    if (cacheArgumentBlock) {
        cacheArgumentBlock(cacheArgument);
    }
    
    // 判断是否是需要在一定时间内忽略请求，有缓存读取缓存,缓存过期或者没有缓存时则重新请求
    if (cacheArgument.cacheArgumentOption == XYCacheArgumentRestrictedFrequentRequests) {
        // 判断是否过期
        BOOL isExpired = [[XYCacheUnit sharedInstance] isCacheVersionExpiredForKey:cacheArgument.key toCacheTimeInSeconds:cacheArgument.cacheTimeInSeconds];
        if (!isExpired) {
            // 取缓存
            id cacheResponseObject = [self getCacheResponseObjectWithKey:cacheArgument.key];
            if (cacheResponseObject) {
                XYResultUnit *result = [self resultUnitWithNSURLSessionTask:nil responseObject:cacheResponseObject];
                [result setDataFromCache:YES];
                completeBlock(nil, result);
                return nil;
            }
        }
    }
    
    NSURLSessionDataTask *dataTask = nil;
    dataTask = [self requestURL:URLString HTTPMethod:method parameters:parameters uploadProgress:uploadProgress downloadProgress:downloadProgress success:^(NSURLSessionTask * _Nonnull task, id  _Nullable responseObject) {
        [self operationSuccessWithNSURLSessionTask:task
                                    responseObject:responseObject
                                     cacheArgument:cacheArgument
                                     completeBlock:completeBlock];
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        [self operationFailureWithNSURLSessionTask:task
                                             error:error
                                     cacheArgument:cacheArgument
                                     completeBlock:completeBlock];
    }];
    
    return dataTask;
}


#pragma mark - Privates
/** 拼接缓存key */
- (NSString *)cacheKeyWithBaseURL:(NSString *)baseURL requestUR:(NSString *)URLString HTTPMethod:(XYHTTPMethod)method parameters:(NSDictionary *)parameters {
    NSString *requestInfoString = [NSString stringWithFormat:@"Method:%ld Host:%@ Url:%@ Parameters:%@ AppVersion:%@",method,baseURL,URLString,[parameters description],[NSString xyc_bundleShortVersionString]];
    NSLog(@"缓存key == %@",requestInfoString);
    return [requestInfoString xyc_MD5Hash];
}

/** 获取缓存 */
- (id)getCacheResponseObjectWithKey:(NSString *)key {
    NSData *data = [[XYCacheUnit sharedInstance] readDataForKey:key];
    if (data) {
        id responseObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return responseObject;
    }
    return nil;
}

#pragma mark - Publics
/** 该方法需子类重写，实现不同项目的请求的结果处理 */
- (XYResultUnit *)resultUnitWithNSURLSessionTask:(NSURLSessionTask *)dataTask
                                  responseObject:(id)responseObject {
    XYResultUnit *result = [[XYResultUnit alloc] init];
    // 请求失败信息
    if ([responseObject isKindOfClass:[NSError class]]) {
        NSError *error = (NSError *)responseObject;
        [result setError:error];
    }
    
    // 请求成功信息
    else if ([responseObject isKindOfClass:[NSDictionary class]]) {
        [result setResponseObject:responseObject];
    }
    
    return result;
}

- (void)operationSuccessWithNSURLSessionTask:(NSURLSessionTask *)task
                              responseObject:(id)responseObject
                               cacheArgument:(XYCacheArgument *)cacheArgument
                               completeBlock:(OperationCompleteBlock)completeBlock {
    XYResultUnit *result = [self resultUnitWithNSURLSessionTask:task responseObject:responseObject];
    if (completeBlock) {
        completeBlock(task, result);
    }
    //缓存设置,满足这三个条件才可以缓存
    if (result.ableCache && cacheArgument && responseObject) {
        if (cacheArgument.cacheArgumentOption == XYCacheArgumentResponseAtErrorRequest || (cacheArgument.cacheArgumentOption == XYCacheArgumentRestrictedFrequentRequests && cacheArgument.cacheTimeInSeconds > 0)) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:responseObject];
            [[XYCacheUnit sharedInstance] writeData:data forKey:cacheArgument.key];
        }
    }
    
}

- (void)operationFailureWithNSURLSessionTask:(NSURLSessionTask *)task
                                       error:(NSError *)error
                               cacheArgument:(XYCacheArgument *)cacheArgument
                               completeBlock:(OperationCompleteBlock)completeBlock {
    XYResultUnit *result = nil;
    // 判断是否需要取缓存
    if (cacheArgument && cacheArgument.cacheArgumentOption == XYCacheArgumentResponseAtErrorRequest) {
        // 判断是否过期
        BOOL isExpired = [[XYCacheUnit sharedInstance] isCacheVersionExpiredForKey:cacheArgument.key toCacheTimeInSeconds:cacheArgument.cacheTimeInSeconds];
        if (!isExpired) {
            // 取缓存
            id cacheResponseObject = [self getCacheResponseObjectWithKey:cacheArgument.key];
            if (cacheResponseObject) {
                result = [self resultUnitWithNSURLSessionTask:task responseObject:cacheResponseObject];
                [result setDataFromCache:YES];
            }
        }
    }else{
        result = [self resultUnitWithNSURLSessionTask:task responseObject:error];
        [result setFailureRequest:YES];
    }
    
    if (completeBlock) {
        completeBlock(task, result);
    }
    
}


@end
