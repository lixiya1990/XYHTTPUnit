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
        // 根据项目接口需求添加请求头信息
        /*
        [self setHeaderFieldValue:[NSString stringWithFormat:@"application/x.rest.%@+json",[self apiVersion]] forKey:@"Accept"];
        [self setHeaderFieldValue:[NSString stringWithFormat:@"4000"] forKey:@"dimension"];
         */
    }
    return self;
}

#pragma mark - Getters - 常用标识符
- (NSString *)apiVersion {
    return kApiVersion;
}

- (NSString *)idfaString {
    ASIdentifierManager *asIM = [[ASIdentifierManager alloc] init];
    if(asIM.advertisingTrackingEnabled){
        return [asIM.advertisingIdentifier UUIDString];
    }
    return nil;
}

- (NSString *)idfvString {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}


#pragma mark - Publics
- (void)setHeaderFieldValue:(NSString *)value forKey:(NSString *)key {
    [[XYHttpManager sharedInstance].requestSerializer setValue:value forHTTPHeaderField:key];
}

- (void)setAuthorizationHeaderFieldWithUsername:(NSString *)username
                                       password:(NSString *)password {
    [[XYHttpManager sharedInstance].requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
}

- (void)clearAuthorizationHeader {
    [[XYHttpManager sharedInstance].requestSerializer clearAuthorizationHeader];
}


- (NSMutableDictionary *)commonArgumentWithUserParameters:(NSDictionary *)parameters {
    NSMutableDictionary *argument = nil;
    if (parameters) {
        argument = [NSMutableDictionary dictionaryWithDictionary:parameters];
    }else{
        argument = @{}.mutableCopy;
    }
    
    argument[@"appver"] = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];//项目版本标识
    NSString *buildVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    argument[@"buildver"] = buildVersion;//开发版本标识
    argument[@"apiver"] = [self apiVersion];//接口版本标识
    NSString *os = [NSString stringWithFormat:@"iOS%.1f",[[[UIDevice currentDevice] systemVersion] floatValue]];
    argument[@"os"] = os;
    
    NSString *idfa = [self idfaString];
    NSString *idfv = [self idfvString];
    argument[@"idfa"] = idfa;
    argument[@"idfv"] = idfv;
    
    BOOL isDebug = NO;
#if DEBUG
    isDebug = YES;
#endif
    argument[@"debug"] = @(isDebug);
    
    return argument;
}

- (NSMutableDictionary *)commonH5ArgumentWithUserParameters:(NSDictionary *)parameters {
    NSMutableDictionary *argument = nil;
    if (parameters) {
        argument = [NSMutableDictionary dictionaryWithDictionary:parameters];
    }else{
        argument = @{}.mutableCopy;
    }
    argument[@"app_appver"] = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    
    argument[@"app_buildver"] = appVersion;
    
    return argument;
}

#pragma mark - Base Function
- (void )reponseURI:(NSString *)uri completeBlock:(RequestCompleteBlock)requestCompleteBlock
             result:(XYResult *)result{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (requestCompleteBlock) {
            requestCompleteBlock(result);
        }
    });
}

#pragma mark - 请求方法
- (void)postMultipartFormWithURL:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
          multipartFormArguments:(NSArray<XYMultipartFormArgument *> *)formArguments
                        progress:(void (^)(NSProgress * _Nonnull))uploadProgress
            requestCompleteBlock:(RequestCompleteBlock)requestCompleteBlock
{
    
    NSMutableDictionary *params = [self commonArgumentWithUserParameters:parameters];
    NSURLSessionDataTask *dataTask = nil;
    dataTask = [[XYHttpManager sharedInstance] requestURL:URLString parameters:params multipartFormArguments:formArguments progress:uploadProgress completeBlock:^(NSURLSessionTask * _Nullable task, XYResultUnit * _Nonnull resultUnit) {
        
    }];


}

@end
