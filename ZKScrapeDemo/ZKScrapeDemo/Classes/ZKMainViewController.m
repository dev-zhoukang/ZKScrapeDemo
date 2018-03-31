//
//  ZKMainViewController.m
//  ZKScrapeDemo
//
//  Created by Zhou Kang on 2018/3/31.
//  Copyright © 2018年 Zhou Kang Inc. All rights reserved.
//

#import "ZKMainViewController.h"
#import "ZKOneViewController.h"

@interface ZKMainViewController ()

@end

@implementation ZKMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)jumpAction:(UIButton *)sender {
    ZKOneViewController *oneVC = [ZKOneViewController new];
    [self.navigationController pushViewController:oneVC animated:true];
}

@end
