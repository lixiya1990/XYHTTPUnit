//
//  XYMultipartFormArgument.m
//  Test
//
//  Created by lxy on 2017/11/7.
//  Copyright © 2017年 lxy. All rights reserved.
//

#import "XYMultipartFormArgument.h"

@implementation XYMultipartFormArgument

+ (instancetype)instancetWithMultipartFormContentType:(XYMultipartFormContentType)contentType keyword:(NSString *)keyword dataValues:(NSArray *)dataValues {
    XYMultipartFormArgument *formArgument = [[XYMultipartFormArgument alloc] init];
    formArgument.contentType = contentType;
    formArgument.keyword = keyword;
    
    NSMutableArray *compressedArray = [NSMutableArray arrayWithCapacity:dataValues.count];
    switch (contentType) {
        case XYMultipartFormContentTypeImage:
        {
            [dataValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[UIImage class]]) {
                    // 添加上传的图片并压缩
                    CGFloat compression = 0.5f;
                    CGFloat maxCompression = 0.1f;
                    int maxFileSize = 1024*1024;
                    
                    NSData *imgData = UIImageJPEGRepresentation(obj, compression);
                    while (imgData.length > maxFileSize && compression > maxCompression){
                        compression -= 0.1;
                        imgData = UIImageJPEGRepresentation(obj, compression);
                    }
                    
                    [compressedArray addObject:imgData];
                }
            }];
        }
            break;
           
        case XYMultipartFormContentTypeZip:
        {
            [dataValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSURL class]]) {
                    [compressedArray addObject:obj];
                }
            }];
        }
            break;
            
        case XYMultipartFormContentTypeAudio:
        {
            [dataValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSURL class]]) {
                    [compressedArray addObject:obj];
                }
            }];
        }
            break;

        default:
            break;
    }
    
    formArgument.dataValues = compressedArray;
    return formArgument;
   
}

@end
