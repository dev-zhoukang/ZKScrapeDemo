//
//  UIImage+Addition.m
//  ZKScrapeDemo
//
//  Created by Zhou Kang on 2018/4/13.
//  Copyright © 2018年 Zhou Kang Inc. All rights reserved.
//

#import "UIImage+Addition.h"

@implementation UIImage (Addition)

- (UIImage *)imageClipedWithRect:(CGRect)clipRect {
    CGImageRef imageRef = self.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, clipRect);
    
    UIGraphicsBeginImageContext(clipRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, clipRect, subImageRef);
    UIImage* clipImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    
    return clipImage;
}

@end
