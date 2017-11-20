//
//  XYHTTPSessionUnit.h
//  Test
//
//  Created by lxy on 2017/11/2.
//  Copyright © 2017年 lxy. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIKit+AFNetworking.h>
#import "XYMultipartFormArgument.h"
NS_ASSUME_NONNULL_BEGIN

/** 请求方式 */
typedef NS_ENUM(NSInteger ,XYHTTPMethod) {
    XYHTTPMethodGet,
    XYHTTPMethodPost,
    XYHTTPMethodHead,
    XYHTTPMethodPut,
    XYHTTPMethodPatch,
    XYHTTPMethodDelete
};

/** 请求成功回调 */
typedef void (^OperationSuccessCompleteBlock)(NSURLSessionTask *task, id _Nullable responseObject);
/** 请求失败回调 */
typedef void (^OperationFailureCompleteBlock)(NSURLSessionTask * _Nullable task, NSError *error);


@interface XYHTTPSessionUnit : AFHTTPSessionManager

/** 取消所有请求 */
- (void)cancelTasks;



/** 指定NSURLRequest的请求 - XYHTTPSessionUnit */
- (NSURLSessionDataTask *)request:(NSURLRequest *)request
                          success:(nullable OperationSuccessCompleteBlock)success
                          failure:(nullable OperationFailureCompleteBlock)failure;

/** 指定NSURLRequest的请求 有进度回调 - XYHTTPSessionUnit */
- (NSURLSessionDataTask *)request:(NSURLRequest *)request
                   uploadProgress:(nullable void (^)(NSProgress *uploadProgress))uploadProgressBlock
                 downloadProgress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
                          success:(nullable OperationSuccessCompleteBlock)success
                          failure:(nullable OperationFailureCompleteBlock)failure;

/** Post请求 提交Json格式的数据 - XYHTTPSessionUnit
    AFJSONRequestSerializer提交的是json数据，AFHTTPRequestSerializer默认提交的是二进制数据(NSData)
 */
- (NSURLSessionDataTask *)requestURL: (NSString *)URLString
                      jsonParameters:(NSDictionary *)parameters
                             success:(nullable OperationSuccessCompleteBlock)success
                             failure:(nullable OperationFailureCompleteBlock)failure;



/** 指定url地址的请求 有成功、失败回调 - XYHTTPSessionUnit */
- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                          HTTPMethod:(XYHTTPMethod)method
                          parameters:(nullable id)parameters
                             success:(nullable OperationSuccessCompleteBlock)success
                             failure:(nullable OperationFailureCompleteBlock)failure;

/** 指定url地址的请求 有进度、成功、失败回调 - XYHTTPSessionUnit */
- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                          HTTPMethod:(XYHTTPMethod)method
                          parameters:(nullable id)parameters
                      uploadProgress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                    downloadProgress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                             success:(nullable OperationSuccessCompleteBlock)success
                             failure:(nullable OperationFailureCompleteBlock)failure;




/**
 上传文件，只适用于Post请求 - XYHTTPSessionUnit

 @param URLString 请求地址
 @param parameters 请求参数
 @param formArguments 需要上传的文件模型
 @param success 成功回调
 @param failure 失败回调
 @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                          parameters:(nullable id)parameters
              multipartFormArguments:(NSArray<XYMultipartFormArgument *> *)formArguments
                             success:(nullable OperationSuccessCompleteBlock)success
                             failure:(nullable OperationFailureCompleteBlock)failure;


/**
 上传文件，有上传进度回调,只适用于Post请求 - XYHTTPSessionUnit

 @param URLString 请求地址
 @param parameters 请求参数
 @param formArguments 需要上传的文件模型
 @param uploadProgress 上传进度
 @param success 成功回调
 @param failure 失败回调
 @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                          parameters:(nullable id)parameters
              multipartFormArguments:(NSArray<XYMultipartFormArgument *> *)formArguments
                            progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                             success:(nullable OperationSuccessCompleteBlock)success
                             failure:(nullable OperationFailureCompleteBlock)failure;




/**
 下载单个文件 - XYHTTPSessionUnit 

 @param URLString 地址
 @param parameters 参数
 @param fileDir 下载到指定地址
 @param downloadProgress 下载进度
 @param success 成功回调
 @param failure 失败回调
 @return NSURLSessionDataTask
 */
- (NSURLSessionDownloadTask *)requestURL:(NSString *)URLString
                          parameters:(nullable id)parameters
                             downFileDir:(NSString *)fileDir
                            progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                             success:(nullable OperationSuccessCompleteBlock)success
                             failure:(nullable OperationFailureCompleteBlock)failure;

@end
NS_ASSUME_NONNULL_END
