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
        
        // 设置请求头信息
        [httpManager.requestSerializer setValue:[NSString stringWithFormat:@"%@",[[NSLocale preferredLanguages] componentsJoinedByString:@", "]] forHTTPHeaderField:@"Accept-Language"];
        //[httpManager.requestSerializer setValue:[NSString stringWithFormat:@"application/x.rest.v2+json"] forHTTPHeaderField:@"Accept"];

        
    });
    return httpManager;
}


@end
