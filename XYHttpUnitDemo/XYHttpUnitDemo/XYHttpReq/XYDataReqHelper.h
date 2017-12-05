//
//  XYDataReqHelper.h
//  XYHttpUnitDemo
//
//  Created by lxy on 2017/12/4.
//  Copyright © 2017年 lxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYHttpManager.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^RequestCompleteBlock)(XYResult *result);
typedef void(^CompleteBlock)(id response ,XYResult *result);

@interface XYDataReqHelper : NSObject


/**
 添加请求头信息

 @param value 添加头信息值
 @param key 添加头信息键
 */
- (void)setHeaderFieldValue:(NSString *)value forKey:(NSString *)key;

- (void)setAuthorizationHeaderFieldWithUsername:(NSString *)username
                                       password:(NSString *)password;
- (void)clearAuthorizationHeader;

/**
 *  组合公共参数
 *
 *  @param parameters 业务自定义参数
 *
 *  @return 包含公共参数的请求参数
 */
- (NSMutableDictionary *)commonArgumentWithUserParameters:(NSDictionary *)parameters;
- (NSMutableDictionary *)commonH5ArgumentWithUserParameters:(NSDictionary *)parameters;


/**
 上传图片、文件、音视频

 @param parameters 参数
 @param formArguments 上传文件数组
 @param requestCompleteBlock 上传请求结果
 */
- (void)postMultipartFormWithURL:(NSString *)URLString
                      parameters:(nullable NSDictionary *)parameters
          multipartFormArguments:(NSArray<XYMultipartFormArgument *> *)formArguments
                        progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
            requestCompleteBlock:(nullable RequestCompleteBlock)requestCompleteBlock;

/** Post请求 提交Json格式的数据 */
- (void)postJsonParametersWithURL:(NSString *)URLString
                       parameters:(NSDictionary *)jsonParameters
                    completeBlock:(nullable CompleteBlock)CompleteBlock;


/** 指定url地址的请求 */
- (void)requestUrl:(NSString *)URLString
        HTTPMethod:(XYHTTPMethod)method
        parameters:(nullable NSDictionary *)parameters
     completeBlock:(nullable CompleteBlock)completeBlock;

/** 指定url地址的请求 有进度回调*/
- (void)requestUrl:(NSString *)URLString
        HTTPMethod:(XYHTTPMethod)method
        parameters:(nullable NSDictionary *)parameters
    uploadProgress:(nullable void (^)(NSProgress *uploadProgress))uploadProgressBlock
  downloadProgress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
     completeBlock:(nullable CompleteBlock)completeBlock;


/** 指定url地址的请求 可指定缓存*/
- (void)requestUrl:(NSString *)URLString
        HTTPMethod:(XYHTTPMethod)method
        parameters:(nullable NSDictionary *)parameters
          useCache:(BOOL)useCache
       expiredTime:(NSInteger)expiredTime
requestCompleteBlock:(nullable RequestCompleteBlock)requestCompleteBlock;


/**
 指定url地址的请求 可指定缓存 离线时间
 
 @param expiredTime          数据的缓存时间
 @param supportOffLine       该接口返回的数据是否支持离线缓存
 */
- (void)requestUrl:(NSString *)URLString
        HTTPMethod:(XYHTTPMethod)method
        parameters:(nullable NSDictionary *)parameters
          useCache:(BOOL)useCache
    supportOffLine:(BOOL)supportOffLine
       expiredTime:(NSInteger)expiredTime
    uploadProgress:(nullable void (^)(NSProgress *uploadProgress))uploadProgressBlock
  downloadProgress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
requestCompleteBlock:(nullable RequestCompleteBlock)requestCompleteBlock;


@end
NS_ASSUME_NONNULL_END
