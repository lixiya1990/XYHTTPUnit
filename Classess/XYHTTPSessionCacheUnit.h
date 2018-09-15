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

/* 请求结果回调 */
typedef void(^OperationCompleteBlock)(NSURLSessionTask *task, XYResultUnit *resultUnit);

@interface XYHTTPSessionCacheUnit : XYHTTPSessionUnit

/** 指定NSURLRequest的请求 */
- (NSURLSessionDataTask *)request:(NSURLRequest *)request
                    completeBlock:(OperationCompleteBlock)completeBlock;

/** 指定NSURLRequest的请求 有进度回调 */
- (NSURLSessionDataTask *)request:(NSURLRequest *)request
                   uploadProgress:(void (^)(NSProgress *uploadProgress))uploadProgressBlock
                 downloadProgress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock
                    completeBlock:(OperationCompleteBlock)completeBlock;

/** Post请求 提交Json格式的数据 */
- (NSURLSessionDataTask *)requestURL: (NSString *)URLString
                      jsonParameters:(NSDictionary *)parameters
                       completeBlock:(OperationCompleteBlock)completeBlock;

/**
 上传文件，有上传进度回调,只适用于Post请求
 */
- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                          parameters:(id)parameters
              multipartFormArguments:(NSArray<XYMultipartFormArgument *> *)formArguments
                            progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                       completeBlock:(OperationCompleteBlock)completeBlock;

/**
 下载单个文件
 */
- (NSURLSessionDownloadTask *)requestURL:(NSString *)URLString
                              parameters:(id)parameters
                             downFileDir:(NSString *)fileDir
                                progress:(void (^)(NSProgress *downloadProgress))downloadProgress
                           completeBlock:(OperationCompleteBlock)completeBlock;



/** 指定url地址的请求 */
- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                          HTTPMethod:(XYHTTPMethod)method
                          parameters:(id)parameters
                       completeBlock:(OperationCompleteBlock)completeBlock;

/** 指定url地址的请求 设置缓存*/
- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                          HTTPMethod:(XYHTTPMethod)method
                          parameters:(id)parameters
                  cacheArgumentBlock:(void (^)(XYCacheArgument *cacheArgument))cacheArgumentBlock
                       completeBlock:(OperationCompleteBlock)completeBlock;

/** 指定url地址的请求 设置缓存/进度回调 */
- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                          HTTPMethod:(XYHTTPMethod)method
                          parameters:(id)parameters
                  cacheArgumentBlock:(void (^)(XYCacheArgument *cacheArgument))cacheArgumentBlock
                      uploadProgress:(void (^)(NSProgress *uploadProgress))uploadProgress
                    downloadProgress:(void (^)(NSProgress *downloadProgress))downloadProgress
                       completeBlock:(OperationCompleteBlock)completeBlock;


/** 子类重写该方法需，实现不同项目的请求的结果处理 */
- (XYResultUnit *)resultUnitWithNSURLSessionTask:(NSURLSessionTask *)dataTask responseObject:(id)responseObject;

@end
