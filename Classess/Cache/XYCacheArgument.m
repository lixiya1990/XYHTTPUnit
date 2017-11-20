//
//  XYCacheArgument.m
//  Test
//
//  Created by lxy on 2017/11/10.
//  Copyright © 2017年 lxy. All rights reserved.
//

#import "XYCacheArgument.h"

@implementation XYCacheArgument

- (instancetype)initWithKey:(NSString *)key {
    self = [super init];
    if (self) {
        self.key = key;
        self.cacheArgumentOption = XYCacheArgumentIgnoreCache;
        self.cacheTimeInSeconds = 0;
        self.offlineTimeInSeconds = 2 * 60 * 60;
    }
    return self;
}

- (void)cacheResponseWithCacheOptions:(XYCacheArgumentOptions)cacheOptions
                   cacheTimeInSeconds:(NSInteger)cacheTimeInSeconds
                 offlineTimeInSeconds:(NSInteger)offlineTimeInSeconds {
 
    self.cacheArgumentOption = cacheOptions;
    self.cacheTimeInSeconds = cacheTimeInSeconds;
    self.offlineTimeInSeconds = offlineTimeInSeconds;
}

@end
