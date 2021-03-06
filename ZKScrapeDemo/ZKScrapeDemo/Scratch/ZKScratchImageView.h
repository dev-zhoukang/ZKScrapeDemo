//
//  ZKScratchImageView.h
//  ZKScrapeDemo
//
//  Created by Zhou Kang on 2018/4/2.
//  Copyright © 2018年 Zhou Kang Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKScratchImageView;

@protocol ZKScratchImageViewDelegate <NSObject>
@optional
- (void)scratchImageView:(ZKScratchImageView *)scratchImageView didChangeMaskingProgress:(CGFloat)maskingProgress;
- (void)scratchImageViewTouchesEnded:(ZKScratchImageView *)scratchImageView;
- (void)scratchImageViewTouchesBegan:(ZKScratchImageView *)scratchImageView;
- (void)scratchImageView:(ZKScratchImageView *)scratchImageView touchesMovedWithVelocity:(CGFloat)velocity;
@end

@interface ZKScratchImageView : UIImageView

@property (nonatomic, readonly) CGFloat                         maskingProgress;
@property (nonatomic, weak) id <ZKScratchImageViewDelegate>     delegate;

- (void)setImage:(UIImage *)image radius:(size_t)radius;

- (void)resume;

@end
