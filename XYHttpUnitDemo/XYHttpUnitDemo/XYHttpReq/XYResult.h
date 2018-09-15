//
//  XYResult.h
//  XYHttpUnitDemo
//
//  Created by lxy on 2017/12/4.
//  Copyright © 2017年 lxy. All rights reserved.
//

#import "XYResultUnit.h"

typedef NS_ENUM(NSInteger, HttpResponseCode) {
    /* 操作成功 */
    HttpResponseCodeSuccess                   = 1,  /* 响应成功 */
    HttpResponseCodeError                     = 0,  /* 响应失败 */
    
    /* 业务错误码 :自定义*/
    HttpResponseCodeInvalidToken              = 1061, //token无效
    HttpResponseCodeSessionTimeOut            = 12, //账号闲置过久
    HttpResponseCodeRemotelogin               = 13, //异地登录
    HttpResponseCodeInvalidUser               = 14, //用户不存在
    HttpResponseCodeNoData                    = 1001,
    HttpResponseCodeUnkonwError               = 9001,  /* 定义未知错误*/
    
    HttpResponseCodeNotConnectedToInternet    = NSURLErrorNotConnectedToInternet,//-1009
    HttpResponseCodeTimedOut    = NSURLErrorTimedOut//-1001
};

@interface XYResult : XYResultUnit

@property (nonatomic, assign) HttpResponseCode httpResponseCode;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, readonly) BOOL success;
@property (nonatomic, readonly) BOOL noConnected;
@property (nonatomic, readonly, strong) NSDictionary *response;

+ (instancetype)resultWithAttributes:(NSDictionary *)attributes;
+ (instancetype)resultWithCode:(HttpResponseCode)code message:(NSString *)message;
+ (instancetype)resultWithNSError:(NSError *)error;

/** 判断该result是否token过期 */
- (BOOL)authTokenInvalid;

@end
