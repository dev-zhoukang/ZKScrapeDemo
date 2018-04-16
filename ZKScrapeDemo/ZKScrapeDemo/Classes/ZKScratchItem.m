//
//  ZKScratchItem.m
//  ZKScrapeDemo
//
//  Created by Zhou Kang on 2018/4/13.
//  Copyright © 2018年 Zhou Kang Inc. All rights reserved.
//

#import "ZKScratchItem.h"

@implementation ZKScratchItem

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    ZKScratchItem *model = [ZKScratchItem new];
    model.imageName = dict[@"name"];
    model.imageSize = CGSizeFromString(dict[@"image_size"]);
    model.blurRect = CGRectFromString(dict[@"blur_frame"]);
    
    return model;
}

@end
