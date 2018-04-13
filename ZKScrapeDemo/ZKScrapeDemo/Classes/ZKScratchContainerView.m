//
//  ZKScratchContainerView.m
//  ZKScrapeDemo
//
//  Created by Zhou Kang on 2018/4/13.
//  Copyright © 2018年 Zhou Kang Inc. All rights reserved.
//

#import "ZKScratchContainerView.h"
#import "UIImage+Addition.h"
#import "ZKScratchImageView.h"
#import <Masonry.h>
#import "ConfigHeader.h"
#import <YYKit.h>

@interface ZKScratchContainerView () <ZKScratchImageViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) ZKScratchImageView *maskImageView;

@end

@implementation ZKScratchContainerView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _imageView = [[UIImageView alloc] init];
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.userInteractionEnabled = true;
    
    _maskImageView = [[ZKScratchImageView alloc] init];
    [_imageView addSubview:_maskImageView];
    _maskImageView.delegate = self;
    
    UIImage *image = [self getOriginalImage];
    image = [image imageClipedWithRect:CGRectMake(93, 312, 400, 220)];
    image = [image imageByBlurSoft];
    [_maskImageView setImage:image radius:5.f];
    
    CGFloat scale = [self calcScale];
    CGFloat delta = (SCREEN_HEIGHT - [self getOriginalImage].size.height * scale) * .5;
    _maskImageView.frame = CGRectMake(93 * scale, 312 * scale + delta, 400 * scale, 220 * scale);
}

- (CGFloat)calcScale {
    CGSize imageSize = [[self getOriginalImage] size];
    BOOL isWidder = imageSize.width / imageSize.height > SCREEN_WIDTH / SCREEN_HEIGHT;
    
    CGFloat scale = 0;
    if (isWidder) {
        scale = SCREEN_WIDTH / imageSize.width;
    }
    else {
        scale = SCREEN_HEIGHT / imageSize.height;
    }
    return scale;
}

- (UIImage *)getOriginalImage {
    UIImage *image = [UIImage imageNamed:@"fanshoumo"];
    return image;
}

#pragma mark - <ZKScratchImageViewDelegate>

- (void)scratchImageView:(ZKScratchImageView *)scratchImageView didChangeMaskingProgress:(CGFloat)maskingProgress {
    NSLog(@"%f", maskingProgress);
}

@end
