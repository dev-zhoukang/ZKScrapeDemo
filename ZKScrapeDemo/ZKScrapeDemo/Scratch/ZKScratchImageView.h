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
@required
- (void)scratchImageView:(ZKScratchImageView *)scratchImageView didChangeMaskingProgress:(CGFloat)maskingProgress;
@end

@interface ZKScratchImageView : UIImageView

@property (nonatomic, readonly) CGFloat                         maskingProgress;
@property (nonatomic, weak) id <ZKScratchImageViewDelegate>     delegate;

- (void)setImage:(UIImage *)image radius:(size_t)radius;

- (void)reset;

@end
