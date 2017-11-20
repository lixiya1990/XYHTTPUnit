//
//  XYCacheUnit.h
//  Test
//
//  Created by lxy on 2017/11/10.
//  Copyright © 2017年 lxy. All rights reserved.
//  缓存工具

#import <Foundation/Foundation.h>

@interface XYCacheUnit : NSObject
+ (instancetype)sharedInstance;

/** 获取缓存时间 */
- (int)cacheFileDurationForPath:(NSString *)path;

/**
 缓存是否过期

 @param key 缓存文件名字
 @param cacheTimeInSeconds 缓存时长，得到的结果大于该数值则过期，反之。
 @return 是否过期
 */
- (BOOL)isCacheVersionExpiredForKey:(NSString *)key toCacheTimeInSeconds:(NSInteger)cacheTimeInSeconds;

/** 写入缓存文件 */
- (void)writeData:(NSData *)data forKey:(NSString *)key;

/** 读取缓存 先读内存，没有在读沙盒*/
- (NSData*)readDataForKey:(NSString*)key;

- (void)removeObjectForKey:(NSString *)key;

- (void)removeAllObjects;

@end
