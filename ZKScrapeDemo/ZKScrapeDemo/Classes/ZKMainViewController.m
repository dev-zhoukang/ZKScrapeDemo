//
//  ZKMainViewController.m
//  ZKScrapeDemo
//
//  Created by Zhou Kang on 2018/3/31.
//  Copyright © 2018年 Zhou Kang Inc. All rights reserved.
//

#import "ZKMainViewController.h"
#import "ZKOneViewController.h"
#import "ZKTwoViewController.h"

@interface ZKMainViewController ()

@end

@implementation ZKMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)jumpAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0: {
            ZKOneViewController *vc = [ZKOneViewController new];
            [self.navigationController pushViewController:vc animated:true];
        } break;
        case 1: {
            ZKTwoViewController *vc = [ZKTwoViewController new];
            [self.navigationController pushViewController:vc animated:true];
        } break;
            
        default:
            break;
    }
}

@end
