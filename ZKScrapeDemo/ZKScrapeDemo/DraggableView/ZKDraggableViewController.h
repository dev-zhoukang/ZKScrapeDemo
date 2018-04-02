//
//  ZKDraggableViewController.h
//  ZKScrapeDemo
//
//  Created by Zhou Kang on 2018/4/2.
//  Copyright © 2018年 Zhou Kang Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKDraggableView.h"

#define PAN_DISTANCE 120
#define CARD_WIDTH   333
#define CARD_HEIGHT  400

@interface ZKDraggableViewController : UIViewController

@property (retain,nonatomic) NSMutableArray <ZKDraggableView *> *allCards;
@property (nonatomic) CGPoint lastCardCenter;
@property (nonatomic) CGAffineTransform lastCardTransform;

@property (nonatomic,strong) NSMutableArray <NSDictionary *> *sourceObject;

@end
