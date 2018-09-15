//
//  XYHTTPSessionUnit.m
//  Test
//
//  Created by lxy on 2017/11/2.
//  Copyright © 2017年 lxy. All rights reserved.
//

#import "XYHTTPSessionUnit.h"

// 默认超时时间
static NSTimeInterval kNormalTimeoutInterval = 30;
static NSTimeInterval KUploadTimeoutInterval = 60;

@implementation XYHTTPSessionUnit

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
        // 默认超时时间
        self.requestSerializer.timeoutInterval = kNormalTimeoutInterval;
        
        // 网络请求时开启风火轮
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        
        // 开启网络状态监控
        [[AFNetworkReachabilityManager manager] startMonitoring];
    }
    return self;
}

#pragma mark - Publics
- (void)cancelTasks {
    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks){
        if (!dataTasks || !dataTasks.count) {
            return;
        }
        for (NSURLSessionTask *task in dataTasks) {
            [task cancel];
        }
    }];
}

- (NSURLSessionDataTask *)request:(NSURLRequest *)request
                          success:(OperationSuccessCompleteBlock)success
                          failure:(OperationFailureCompleteBlock)failure {
    return [self request:request uploadProgress:nil downloadProgress:nil success:success failure:failure];
}


- (NSURLSessionDataTask *)request:(NSURLRequest *)request
                   uploadProgress:(void (^)(NSProgress *uploadProgress))uploadProgressBlock
                 downloadProgress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock
                          success:(OperationSuccessCompleteBlock)success
                          failure:(OperationFailureCompleteBlock)failure {
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request uploadProgress:uploadProgressBlock downloadProgress:downloadProgressBlock completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [self operationFailureWithNSURLSessionTask:dataTask
                                                 error:error
                                               failure:failure];
        } else {
            [self operationSuccessWithNSURLSessionTask:dataTask
                                        responseObject:responseObject
                                               success:success];
        }
    }];
    
    [dataTask resume];
    return dataTask;
}


- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                      jsonParameters:(NSDictionary *)parameters
                             success:(OperationSuccessCompleteBlock)success
                             failure:(OperationFailureCompleteBlock)failure {
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置请求头
    // 设置认证Authorization
    NSString *auth = [self.requestSerializer valueForHTTPHeaderField:@"Authorization"];
    if (auth && auth.length) {
        [requestSerializer setValue:auth forHTTPHeaderField:@"Authorization"];
    }
    // 根据需要设置更多属性
    // ....

    NSError *serializationError = nil;
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if (serializationError) {
        dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
            [self operationFailureWithNSURLSessionTask:nil error:serializationError failure:failure];
        });
        return nil;
    }
    
    NSURLSessionDataTask *dataTask = [self request:request success:success failure:failure];
    return dataTask;
}

- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                          HTTPMethod:(XYHTTPMethod)method
                          parameters:(id)parameters
                             success:(OperationSuccessCompleteBlock)success
                             failure:(OperationFailureCompleteBlock)failure {
    return [self requestURL:URLString HTTPMethod:method parameters:parameters uploadProgress:nil downloadProgress:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                          HTTPMethod:(XYHTTPMethod)method
                          parameters:(id)parameters
                      uploadProgress:(void (^)(NSProgress *))uploadProgress
                    downloadProgress:(void (^)(NSProgress *))downloadProgress
                             success:(OperationSuccessCompleteBlock)success
                             failure:(OperationFailureCompleteBlock)failure {
    
    NSURLSessionDataTask *dataTask = nil;
    if (method == XYHTTPMethodGet) {
        dataTask = [self GET:URLString parameters:parameters progress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self operationSuccessWithNSURLSessionTask:task
                                        responseObject:responseObject
                                               success:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self operationFailureWithNSURLSessionTask:task
                                                 error:error
                                               failure:failure];
        }];
    } else if (method == XYHTTPMethodPost) {
        dataTask = [self POST:URLString parameters:parameters progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self operationSuccessWithNSURLSessionTask:task
                                        responseObject:responseObject
                                               success:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self operationFailureWithNSURLSessionTask:task
                                                 error:error
                                               failure:failure];
        }];
    } else if (method == XYHTTPMethodHead) {
        dataTask = [self HEAD:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task) {
            [self operationSuccessWithNSURLSessionTask:task
                                        responseObject:nil
                                               success:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self operationFailureWithNSURLSessionTask:task
                                                 error:error
                                               failure:failure];
        }];
    }else if (method == XYHTTPMethodPut) {
        dataTask = [self PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self operationSuccessWithNSURLSessionTask:task
                                        responseObject:responseObject
                                               success:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self operationFailureWithNSURLSessionTask:task
                                                 error:error
                                               failure:failure];
        }];
    }else if (method == XYHTTPMethodPatch) {
        dataTask = [self PATCH:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self operationSuccessWithNSURLSessionTask:task
                                        responseObject:responseObject
                                               success:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self operationFailureWithNSURLSessionTask:task
                                                 error:error
                                               failure:failure];
        }];
    }else if (method == XYHTTPMethodDelete) {
        dataTask = [self DELETE:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self operationSuccessWithNSURLSessionTask:task
                                        responseObject:responseObject
                                               success:success];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self operationFailureWithNSURLSessionTask:task
                                                 error:error
                                               failure:failure];
        }];
    }
    return dataTask;
}

- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                          parameters:(id)parameters
              multipartFormArguments:(NSArray<XYMultipartFormArgument *> *)formArguments
                             success:(OperationSuccessCompleteBlock)success
                             failure:(OperationFailureCompleteBlock)failure {
    return [self requestURL:URLString parameters:parameters multipartFormArguments:formArguments progress:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                          parameters:(id)parameters
              multipartFormArguments:(NSArray<XYMultipartFormArgument *> *)formArguments
                            progress:(void (^)(NSProgress *))uploadProgress
                             success:(OperationSuccessCompleteBlock)success
                             failure:(OperationFailureCompleteBlock)failure {
    
    NSURLSessionDataTask *dataTask = nil;
    dataTask = [self POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formArguments enumerateObjectsUsingBlock:^(XYMultipartFormArgument * _Nonnull formArgument, NSUInteger idx, BOOL * _Nonnull stop) {
            switch (formArgument.contentType) {
                case XYMultipartFormContentTypeImage:
                {
                    [formArgument.dataValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSData *imageData = obj;
                        
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        formatter.dateFormat = @"yyyyMMddHHmmss";
                        NSString *str = [formatter stringFromDate:[NSDate date]];
                        NSString *fileName = [NSString stringWithFormat:@"%@%ld.%@",str,idx,@"jpg"];
                        
                        [formData appendPartWithFileData:imageData name:formArgument.keyword fileName:fileName mimeType:@"image/jpeg"];
                    }];
                }
                    break;
                case XYMultipartFormContentTypeZip:
                {
                    [formArgument.dataValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSURL *fileURL = obj;
                        
                        NSString *fileName = [[fileURL pathComponents] lastObject];;
                        NSError *error = nil;
                        [formData appendPartWithFileURL:fileURL name:formArgument.keyword fileName:fileName mimeType:@"application/zip" error:&error];
                    }];
                }
                    break;
                case XYMultipartFormContentTypeAudio:
                {
                    [formArgument.dataValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSURL *fileURL = obj;
                        
                        NSString *fileName = [[fileURL pathComponents] lastObject];;
                        NSError *error = nil;
                        [formData appendPartWithFileURL:fileURL name:formArgument.keyword fileName:fileName mimeType:@"audio/mpeg" error:&error];
                    }];
                }
                    break;
                default:
                    break;
            }
        }];
    } progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self operationSuccessWithNSURLSessionTask:task
                                    responseObject:responseObject
                                           success:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            [self operationFailureWithNSURLSessionTask:task
                                                 error:error
                                               failure:failure];
        }
    }];
    
    return dataTask;
}

- (NSURLSessionDownloadTask *)requestURL:(NSString *)URLString
                          parameters:(id)parameters
                         downFileDir:(NSString *)fileDir
                            progress:(void (^)(NSProgress *))downloadProgress
                             success:(OperationSuccessCompleteBlock)success
                             failure:(OperationFailureCompleteBlock)failure {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:URLString]];

    __block NSURLSessionDownloadTask *dataTask = nil;
    dataTask = [self downloadTaskWithRequest:request progress:downloadProgress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ?: @"Download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        NSLog(@"下载地址==%@",filePath);
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            [self operationFailureWithNSURLSessionTask:dataTask
                                                 error:error
                                               failure:failure];
        } else {
            [self operationSuccessWithNSURLSessionTask:dataTask
                                        responseObject:filePath.absoluteString
                                               success:success];
        }
    }];
    
    [dataTask resume];
    return dataTask;
}

#pragma mark - Privates
- (void)operationSuccessWithNSURLSessionTask:(NSURLSessionTask *)task
                              responseObject:(id)responseObject
                                     success:(OperationSuccessCompleteBlock)success {
    if (success) {
        success(task, responseObject);
    }
}

- (void)operationFailureWithNSURLSessionTask:(NSURLSessionTask *)task
                                       error:(NSError *)error
                                     failure:(OperationFailureCompleteBlock)failure {
    if (failure) {
        failure(task, error);
    }
}

@end
