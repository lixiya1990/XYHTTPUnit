//
//  XYHTTPSessionCacheUnit.h
//  Test
//
//  Created by lxy on 2017/11/9.
//  Copyright © 2017年 lxy. All rights reserved.
//

#import "XYHTTPSessionUnit.h"
#import "XYResultUnit.h"
#import "XYCacheArgument.h"
NS_ASSUME_NONNULL_BEGIN

/* 请求结果回调 */
typedef void(^OperationCompleteBlock)(NSURLSessionTask * __nullable task, XYResultUnit * result);

@interface XYHTTPSessionCacheUnit : XYHTTPSessionUnit

/** 指定NSURLRequest的请求 */
- (NSURLSessionDataTask *)request:(NSURLRequest *)request
                    completeBlock:(nullable OperationCompleteBlock)completeBlock;

/** 指定NSURLRequest的请求 有进度回调 */
- (NSURLSessionDataTask *)request:(NSURLRequest *)request
                   uploadProgress:(nullable void (^)(NSProgress *uploadProgress))uploadProgressBlock
                 downloadProgress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
                    completeBlock:(nullable OperationCompleteBlock)completeBlock;

/** Post请求 提交Json格式的数据 */
- (NSURLSessionDataTask *)requestURL: (NSString *)URLString
                      jsonParameters:(NSDictionary *)parameters
                       completeBlock:(nullable OperationCompleteBlock)completeBlock;



/** 指定url地址的请求 */
- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                          HTTPMethod:(XYHTTPMethod)method
                          parameters:(nullable id)parameters
                       completeBlock:(nullable OperationCompleteBlock)completeBlock;



/** 指定url地址的请求 有进度回调 */
- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                          HTTPMethod:(XYHTTPMethod)method
                          parameters:(nullable id)parameters
                  cacheArgumentBlock:(nullable void (^)(XYCacheArgument *cacheArgument))cacheArgumentBlock
                      uploadProgress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                    downloadProgress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                       completeBlock:(nullable OperationCompleteBlock)completeBlock;



/** 子类重写该方法需，实现不同项目的请求的结果处理 */
- (XYResultUnit *)resultUnitWithNSURLSessionTask:(nullable NSURLSessionTask *)dataTask responseObject:(nullable id)responseObject;

@end
NS_ASSUME_NONNULL_END
