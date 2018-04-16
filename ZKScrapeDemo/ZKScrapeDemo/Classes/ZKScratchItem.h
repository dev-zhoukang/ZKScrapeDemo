//
//  ZKScratchItem.h
//  ZKScrapeDemo
//
//  Created by Zhou Kang on 2018/4/13.
//  Copyright © 2018年 Zhou Kang Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKScratchItem : NSObject

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) CGRect blurRect;
@property (nonatomic, assign) CGSize imageSize;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
