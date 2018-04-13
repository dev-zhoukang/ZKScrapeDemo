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

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSMutableArray <ZKScratchItem *> *dataSource;

@end

@implementation ZKScratchContainerView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initData];
        [self setup];
    }
    return self;
}

- (void)updateWithDataSource:(NSArray<ZKScratchItem *> *)items {
    [_dataSource addObjectsFromArray:items];
    [self startRender];
}

- (void)startRender {
    if (_currentIndex >= _dataSource.count) {
        return;
    }
    
    ZKScratchItem *item = _dataSource[_currentIndex];
    
    UIImage *image = [self getOriginalImage];
    // 93, 312, 400, 220
    CGRect blurRect = CGRectMake(32, 446, 200, 300);
    image = [image imageClipedWithRect:blurRect];
    image = [image imageByBlurSoft];
    [_maskImageView setImage:image radius:2.f];
    
    CGFloat scale = [self calcScale];
    
    if ([self isImageWidderThanScreenWidth:[self getOriginalImage]]) {
        CGFloat deltaY = (SCREEN_HEIGHT - [self getOriginalImage].size.height * scale) * .5;
        _maskImageView.frame = (CGRect){
            blurRect.origin.x * scale,
            blurRect.origin.y * scale + deltaY,
            blurRect.size.width * scale,
            blurRect.size.height * scale };
    }
    else {
        CGFloat deltaX = (SCREEN_WIDTH - [self getOriginalImage].size.width * scale) * .5;
        _maskImageView.frame = (CGRect){
            blurRect.origin.x * scale + deltaX,
            blurRect.origin.y * scale,
            blurRect.size.width * scale,
            blurRect.size.height * scale };
    }
}

- (void)initData {
    _dataSource = [NSMutableArray array];
}

- (void)setup {
    _imageView = [[UIImageView alloc] init];
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.userInteractionEnabled = true;
    _imageView.image = [self getOriginalImage];
    
    _maskImageView = [[ZKScratchImageView alloc] init];
    [_imageView addSubview:_maskImageView];
    _maskImageView.delegate = self;
    _maskImageView.layer.cornerRadius = 10.f;
    _maskImageView.layer.masksToBounds = true;
    _maskImageView.alpha = .98;
}

- (CGFloat)calcScale {
    UIImage *taegetImage = [self getOriginalImage];
    CGSize imageSize = [taegetImage size];
    BOOL isWidder = [self isImageWidderThanScreenWidth:taegetImage];
    
    CGFloat scale = 0;
    if (isWidder) {
        scale = SCREEN_WIDTH / imageSize.width;
    }
    else {
        scale = SCREEN_HEIGHT / imageSize.height;
    }
    return scale;
}

- (BOOL)isImageWidderThanScreenWidth:(UIImage *)image {
    CGSize imageSize = image.size;
    BOOL isWidder = imageSize.width / imageSize.height > SCREEN_WIDTH / SCREEN_HEIGHT;
    return isWidder;
}

- (UIImage *)getOriginalImage {
    if (_currentIndex >= _dataSource.count) {
        return nil;
    }
    ZKScratchItem *item = _dataSource[_currentIndex];
    UIImage *image = [UIImage imageNamed:item.imageName];
    return image;
}

#pragma mark - <ZKScratchImageViewDelegate>

- (void)scratchImageView:(ZKScratchImageView *)scratchImageView didChangeMaskingProgress:(CGFloat)maskingProgress {
    NSLog(@"%f", maskingProgress);
}

@end
