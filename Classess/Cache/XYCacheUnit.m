//
//  XYCacheUnit.m
//  Test
//
//  Created by lxy on 2017/11/10.
//  Copyright © 2017年 lxy. All rights reserved.
//

#import "XYCacheUnit.h"

/** 缓存在/Library/Caches目录下，用户退出时删除
    1.NSCache,NSCache的正确名字应该叫做NSMemoryCache，只是将数据保存在内存中.APP重启后,并不会保存下来。
    这里我们设置同时缓存到磁盘
    2.NSCache并不会复制对象，而只是对要缓存的对象做了强引用
 */
static NSString * const XYCacheUnit_ResponseCaches = @"XYCacheUnit_ResponseCaches";
@interface XYCacheUnit()

@property (nonatomic ,strong) NSCache *cache;
@property (nonatomic, strong) dispatch_queue_t file_queue_t;

@end

@implementation XYCacheUnit

+ (instancetype)sharedInstance {
    static XYCacheUnit *cacheUnit = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheUnit = [[XYCacheUnit alloc] init];
        
    });
    return cacheUnit;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _cache = [[NSCache alloc] init];
        [self checkResponseCachesDirectoryAtPath:[self responseCachesDirectoryPath]];
    }
    return self;
}

/** 检测请求缓存目录是否存在，如不存在则创建 */
- (void)checkResponseCachesDirectoryAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //isDirectory 判断是否为文件夹
    BOOL isDirectory;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDirectory]) {
        [self createResponseCachesDirectoryAtPath:path];
    }else{
        if (!isDirectory) {
            [fileManager removeItemAtPath:path error:nil];
            [self createResponseCachesDirectoryAtPath:path];
        }
    }
}

/** 创建请求缓存目录 */
- (void)createResponseCachesDirectoryAtPath:(NSString *)path {
    BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    if (result) {
        NSLog(@"创建请求Response缓存目录成功！== %@",path);
    }else{
        NSLog(@"创建请求Response缓存目录失败！");
    }
}

/** 请求缓存目录Path */
- (NSString *)responseCachesDirectoryPath {
    return [[self appCachesDirectoryPath] stringByAppendingPathComponent:XYCacheUnit_ResponseCaches];
}


/**  应用缓存目录路径 */
- (NSString *)appCachesDirectoryPath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

/** 请求Response缓存地址 */
- (NSString *)responseFilePathForKey:(NSString *)key{
    return [[self responseCachesDirectoryPath] stringByAppendingPathComponent:key];
}

#pragma mark - Publics
/** 获取缓存时间 */
- (int)cacheFileDurationForPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *attributesRetrievalError = nil;
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:path
                                                             error:&attributesRetrievalError];
    if (!attributes) {
        return -1;
    }
    int seconds = -[[attributes fileModificationDate] timeIntervalSinceNow];
    return seconds;
}

- (BOOL)isCacheVersionExpiredForKey:(NSString *)key toCacheTimeInSeconds:(NSInteger)cacheTimeInSeconds {
    NSString *path = [self responseFilePathForKey:key];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path isDirectory:nil]) {
        return YES;
    }

    int seconds = [self cacheFileDurationForPath:path];
    if (seconds < 0 || seconds > cacheTimeInSeconds) {
        return YES;
    }
    return NO;
}


/** 写入缓存文件 */
- (void)writeData:(NSData *)data forKey:(NSString *)key {
    if (!key) return;
    if (!data) {
        [self removeObjectForKey:key];
        return;
    }
    NSLog(@"缓存所处当前线程___%@",[NSThread currentThread]);
    
    //NSCache存入内存
    [_cache setObject:data forKey:key];
    
    NSString *filePth  = [self responseFilePathForKey:key];
    dispatch_async(self.file_queue_t, ^{
        NSLog(@"写入沙河所处当前线程___%@",[NSThread currentThread]);
        //写入沙盒
        [[NSFileManager defaultManager] createFileAtPath:filePth contents:data attributes:nil];
    });
}

/** 读取缓存 先读内存，没有在读沙盒*/
- (NSData*)readDataForKey:(NSString*)key {
    if(!key) return nil;
    NSData *cacheData = [_cache objectForKey:key];
    if(cacheData){
        return cacheData;
    }else{
        NSString *filepath =[self responseFilePathForKey:key];
        NSData *fileData =  [[NSFileManager defaultManager] contentsAtPath:filepath];
        if(fileData){
            [_cache setObject:fileData forKey:key];
        }
        return fileData;
    }
}

- (void)removeObjectForKey:(NSString *)key {
    if (!key) return;
    //NSCache内存移除
    [_cache removeObjectForKey:key];
    //沙盒移除
    dispatch_async(self.file_queue_t, ^{
        [self removeFileAtPath:[self responseFilePathForKey:key]];
    });
}

- (void)removeAllObjects {
    [_cache removeAllObjects];
    dispatch_async(self.file_queue_t, ^{
        [self removeFileAtPath:[self responseCachesDirectoryPath]];
    });
}

#pragma mark - Privates
- (void)removeFileAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path isDirectory:nil]) {
        [fileManager removeItemAtPath:path error:nil];
    }
}

#pragma mark - Getters
- (dispatch_queue_t)file_queue_t {
    if (!_file_queue_t) {
        _file_queue_t = dispatch_queue_create("com.XYCacheUnit.fileCache", DISPATCH_QUEUE_SERIAL);
    }
    return _file_queue_t;
}

@end


