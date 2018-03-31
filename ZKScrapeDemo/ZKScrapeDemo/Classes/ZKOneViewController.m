//
//  ZKOneViewController.m
//  ZKScrapeDemo
//
//  Created by Zhou Kang on 2018/3/31.
//  Copyright © 2018年 Zhou Kang Inc. All rights reserved.
//

#import "ZKOneViewController.h"

@interface ZKOneViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ZKOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = touches.anyObject;
    CGPoint cententPoint = [touch locationInView:self.imageView];
    CGRect  rect = CGRectMake(cententPoint.x, cententPoint.y, 30, 30);
    UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.imageView.layer renderInContext:context];
    CGContextClearRect(context, rect);
    // 获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束图片的画板, (意味着图片在上下文中消失)
    UIGraphicsEndImageContext();
    self.imageView.image = image;
    
}

@end
