//
//  ZKTwoViewController.m
//  ZKScrapeDemo
//
//  Created by Zhou Kang on 2018/4/2.
//  Copyright © 2018年 Zhou Kang Inc. All rights reserved.
//

#import "ZKTwoViewController.h"
#import <YYKit.h>
#import <Masonry.h>
#import "ZKScratchImageView.h"

@interface ZKTwoViewController () <ZKScratchImageViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) ZKScratchImageView *maskImageView;

@end

@implementation ZKTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageView.userInteractionEnabled = true;
    _maskImageView = [[ZKScratchImageView alloc] init];
    [_imageView addSubview:_maskImageView];
    _maskImageView.frame = _imageView.bounds;

    UIImage *maskImg = [[_imageView snapshotImage] imageByBlurLight];
    [_maskImageView setImage:maskImg radius:10];
    _maskImageView.delegate = self;
    _maskImageView.clipsToBounds = true;
}

- (void)scratchImageView:(ZKScratchImageView *)scratchImageView didChangeMaskingProgress:(CGFloat)maskingProgress {
    NSLog(@"%f", maskingProgress);
}

@end
