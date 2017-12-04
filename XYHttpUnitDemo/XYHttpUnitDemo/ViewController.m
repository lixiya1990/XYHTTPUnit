//
//  ViewController.m
//  XYHttpUnitDemo
//
//  Created by lxy on 2017/11/20.
//  Copyright © 2017年 lxy. All rights reserved.
//

#import "ViewController.h"
#import "XYHTTPSessionCacheUnit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [[XYHTTPSessionCacheUnit manager] requestURL:@"" HTTPMethod:XYHTTPMethodGet parameters:nil cacheArgumentBlock:^(XYCacheArgument * _Nonnull cacheArgument) {
        
    } uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completeBlock:^(NSURLSessionTask * _Nullable task, XYResultUnit * _Nonnull result) {
        
    }];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
