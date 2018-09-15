//
//  XYDataReqHelper.h
//  XYHttpUnitDemo
//
//  Created by lxy on 2017/12/4.
//  Copyright © 2017年 lxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYHttpManager.h"

typedef void(^CompleteBlock)(id response ,XYResult *result);

@interface XYDataReqHelper : NSObject


- (void)clearHeaders;
/** 添加请求头信息 */
- (void)setHeaderFieldValue:(NSString *)value forKey:(NSString *)key;


/** 组合公共参数  */
- (NSMutableDictionary *)commonArgumentWithUserParameters:(NSDictionary *)parameters;

- (void)reponseURL:(NSString *)URLString
     completeBlock:(CompleteBlock)completeBlock
            result:(XYResult *)result;

/** Post请求 提交Json格式的数据 */
- (void)postJsonWithURL:(NSString *)URLString
             parameters:(NSDictionary *)parameters
          completeBlock:(CompleteBlock)completeBlock;

/** 指定url地址的请求 */
- (void)requestURL:(NSString *)URLString
        HTTPMethod:(XYHTTPMethod)method
        parameters:(NSDictionary *)parameters
     completeBlock:(CompleteBlock)completeBlock;

@end

