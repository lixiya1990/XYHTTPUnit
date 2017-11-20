//
//  XYMultipartFormArgument.h
//  Test
//
//  Created by lxy on 2017/11/7.
//  Copyright © 2017年 lxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

/** 文件类型 */
typedef NS_ENUM(NSInteger ,XYMultipartFormContentType) {
    XYMultipartFormContentTypeNone,
    /// 图片
    XYMultipartFormContentTypeImage,
    /// ZIP类型压缩文件
    XYMultipartFormContentTypeZip,
    /// 音频文件
    XYMultipartFormContentTypeAudio,
};

@interface XYMultipartFormArgument : NSObject
@property (nonatomic ,assign) XYMultipartFormContentType contentType;
@property (nonatomic ,strong) NSString *keyword;
/** 上传数据数组 */
@property (nonatomic ,strong) NSArray *dataValues;

+ (instancetype)instancetWithMultipartFormContentType:(XYMultipartFormContentType)contentType
                                              keyword:(NSString *)keyword
                                           dataValues:(NSArray *)dataValues;

@end
NS_ASSUME_NONNULL_END
