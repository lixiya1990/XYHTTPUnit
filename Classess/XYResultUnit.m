//
//  XYResultUnit.m
//  Test
//
//  Created by lxy on 2017/11/9.
//  Copyright © 2017年 lxy. All rights reserved.
//

#import "XYResultUnit.h"

@implementation XYResultUnit

- (void)setError:(NSError *)error {
    if (_error != error) {
        _error = error;
    }
}

- (void)setResponseObject:(id)responseObject {
    if (_responseObject != responseObject) {
        _responseObject = responseObject;
    }
}

- (void)setDataFromCache:(BOOL)fromCache {
    _dataFromCache = fromCache;
}

- (void)setFailureRequest:(BOOL)failureRequest {
    _failureRequest = failureRequest;
}

@end
