//
//  XYHttpManager.m
//  XYHttpUnitDemo
//
//  Created by lxy on 2017/12/4.
//  Copyright © 2017年 lxy. All rights reserved.
//

#import "XYHttpManager.h"
/**
 *  是否开启https SSL 验证
 */
#define openHttpsSSL 0
/**
 *  SSL 证书名称，仅支持cer格式.
 */
#define certificate @"https"

@implementation XYHttpManager

+ (instancetype)sharedInstance {
    static XYHttpManager *httpManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpManager = [[XYHttpManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        
        AFHTTPRequestSerializer *requestSerializer = [[AFHTTPRequestSerializer alloc] init];
        [requestSerializer setCachePolicy:NSURLRequestReloadIgnoringCacheData];
        [requestSerializer setTimeoutInterval:30];
        
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        NSSet *acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                         @"text/html",
                                         @"text/json",
                                         @"text/javascript",
                                         @"text/plain",
                                         @"text/xml",
                                         @"image/*",nil];
        responseSerializer.acceptableContentTypes = acceptableContentTypes;

        httpManager.requestSerializer = requestSerializer;
        httpManager.responseSerializer = responseSerializer;
        
        // ssl 验证
        if (openHttpsSSL) {
            [self customSecurityPolicy];
        }
    });
    return httpManager;
}


#pragma mark- Override
- (XYResultUnit *)resultUnitOperationNSURLSessionTask:(NSURLSessionTask *)dataTask callbackWithResponseObject:(id)responseObject{
    if ([responseObject isKindOfClass:[NSError class]]) {
        NSError *error = (NSError*)responseObject;
        return [XYResult resultWithNSError:error];
    }else if ([responseObject isKindOfClass:[NSDictionary class]]){
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        if (jsonDict != nil && [jsonDict isKindOfClass:[NSDictionary class]] && jsonDict.count > 0 ) {
            return [XYResult resultWithAttributes:jsonDict];
        }
    }
    return [XYResult resultWithCode:HttpResponseCodeUnkonwError message:@"请求错误"];
}

#pragma mark - 证书设置
+ (AFSecurityPolicy*)customSecurityPolicy {
    AFSecurityPolicy *securityPolicy = nil;
    //线上环境使用HTTPS证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:certificate ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    // AFSSLPinningModeCertificate 使用证书验证模式
    securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    NSSet *certSet = [[NSSet alloc] initWithObjects:certData, nil];
    securityPolicy.pinnedCertificates = certSet;
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    securityPolicy.validatesDomainName = NO;
    return securityPolicy;
}

@end
