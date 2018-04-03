//
//  ZKDraggableView.h
//  ZKScrapeDemo
//
//  Created by Zhou Kang on 2018/4/2.
//  Copyright © 2018年 Zhou Kang Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKDraggableView;

#define ROTATION_ANGLE         M_PI/8
#define CLICK_ANIMATION_TIME   0.5
#define RESET_ANIMATION_TIME   0.3

@protocol ZKDraggableViewDelegate <NSObject>
- (void)draggableView:(ZKDraggableView *)draggableView didMove:(CGFloat)translationX;
- (void)draggableViewDidMoveBack:(ZKDraggableView *)draggableView;
- (void)draggableViewWillMoveOut:(ZKDraggableView *)draggableView;
- (void)draggableView:(ZKDraggableView *)draggableView didMoveToRight:(BOOL)right;
@end

@interface ZKDraggableView : UIView

@property (nonatomic)CGAffineTransform originalTransform;
@property (nonatomic)CGPoint originalPoint;
@property (nonatomic)CGPoint originalCenter;
@property (nonatomic)NSDictionary *userInfo;
@property (nonatomic,strong)UIButton* rightBtn;
@property (nonatomic,strong)UIButton* leftBtn;
@property (nonatomic)BOOL enablePanGesture;
@property (nonatomic, weak) id <ZKDraggableViewDelegate> delegate;

-(void)leftClickAction;
-(void)rightClickAction;

@end
