//
//  ZKOneViewController.m
//  ZKScrapeDemo
//
//  Created by Zhou Kang on 2018/3/31.
//  Copyright © 2018年 Zhou Kang Inc. All rights reserved.
//

#import "ZKOneViewController.h"
#import "ZKScratchContainerView.h"

@interface ZKOneViewController () 

@end

@implementation ZKOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = true;
    
    ZKScratchContainerView *containerView = [ZKScratchContainerView new];
    [self.view addSubview:containerView];
    containerView.frame = self.view.bounds;
}

@end
