//
//  ZKOneViewController.m
//  ZKScrapeDemo
//
//  Created by Zhou Kang on 2018/3/31.
//  Copyright © 2018年 Zhou Kang Inc. All rights reserved.
//

#import "ZKOneViewController.h"
#import "ZKScratchContainerView.h"
#import <Masonry.h>
#import "ZKScratchItem.h"

@interface ZKOneViewController ()

@property (nonatomic, strong) ZKScratchContainerView *scratchContainer;

@end

@implementation ZKOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = true;
    
    [self requestData];
    
    _scratchContainer = [ZKScratchContainerView new];
    [self.view addSubview:_scratchContainer];
    [_scratchContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)requestData {
    NSString *names[2] = { @"fanshoumo", @"yungong" };
    CGRect rects[2] = { {93,312,400,220}, {32,446,200,300} };
    
    NSMutableArray <ZKScratchItem *> *items = [NSMutableArray array];
    for (int i = 0; i < 2; i ++) {
        ZKScratchItem *item = [ZKScratchItem new];
        item.imageName = names[i];
        item.blurRect = rects[i];
        [items addObject:item];
    }
    [_scratchContainer updateWithDataSource: items];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationSlide];
}

@end
