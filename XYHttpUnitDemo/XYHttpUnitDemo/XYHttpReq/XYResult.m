//
//  XYResult.m
//  XYHttpUnitDemo
//
//  Created by lxy on 2017/12/4.
//  Copyright © 2017年 lxy. All rights reserved.
//

#import "XYResult.h"

@interface XYResult()
@property (nonatomic, strong, readwrite) NSDictionary *response;
@end

@implementation XYResult

+ (instancetype)resultWithAttributes:(NSDictionary *)attributes {
    return [[XYResult alloc] initWithDict:attributes];
}

+ (instancetype)resultWithCode:(HttpResponseCode)code message:(NSString *)message {
    message = message ?: @"";
    NSDictionary *attributes = @{@"errorCode":@(code),@"msg":message};
    return [[XYResult alloc] initWithDict:attributes];
}

+ (instancetype)resultWithNSError:(NSError *)error {
    return [XYResult resultWithCode:error.code message:error.localizedDescription];
}

- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.response = dict;
        if ([[dict allKeys] containsObject:@"errorCode"]) {
            self.httpResponseCode = (HttpResponseCode )[dict[@"errorCode"] integerValue];
        }else{
            self.httpResponseCode = HttpResponseCodeUnkonwError;
        }
        
        if ([[dict allKeys] containsObject:@"msg"]) {
            if (dict[@"msg"]) {
                self.message = dict[@"msg"];
            }
        }
    }
    return self;
}

#pragma mark getter
- (BOOL)ableCache {
    return [self success];
}

- (BOOL)success {
    if (self.httpResponseCode == HttpResponseCodeSuccess) {
        return YES;
    }
    return NO;
}

- (BOOL)noConnected {
    if (self.httpResponseCode == HttpResponseCodeNotConnectedToInternet || self.httpResponseCode == HttpResponseCodeTimedOut) {
        return YES;
    }
    return NO;
}

- (BOOL)authTokenInvalid {
    if (self.httpResponseCode == HttpResponseCodeInvalidToken) {
        return YES;
    }
    return NO;
}

- (NSString *)message{
    if (self.httpResponseCode == HttpResponseCodeNotConnectedToInternet || self.httpResponseCode == HttpResponseCodeTimedOut) {
        return @"当前网络无法连接，请稍后再试!";
    }
    return _message;
}

@end
