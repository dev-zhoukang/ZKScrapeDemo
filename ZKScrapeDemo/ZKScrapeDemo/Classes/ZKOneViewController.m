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
    
    _scratchContainer = [ZKScratchContainerView new];
    [self.view addSubview:_scratchContainer];
    [_scratchContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self requestData];
}

- (void)requestData {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ScratchImageSource.json" ofType:nil];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *sourceDict = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableContainers error:nil];
    NSArray *sourceArray = sourceDict[@"list"];
    
    NSMutableArray <ZKScratchItem *> *items = [NSMutableArray array];
    for (NSDictionary *dict in sourceArray) {
        ZKScratchItem *model = [ZKScratchItem modelWithDict:dict];
        [items addObject:model];
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
