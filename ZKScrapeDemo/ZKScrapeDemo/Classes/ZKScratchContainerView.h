//
//  ZKScratchContainerView.h
//  ZKScrapeDemo
//
//  Created by Zhou Kang on 2018/4/13.
//  Copyright © 2018年 Zhou Kang Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKScratchItem.h"

@interface ZKScratchContainerView : UIView

- (void)updateWithDataSource:(NSArray <ZKScratchItem *> *)items;

@end
