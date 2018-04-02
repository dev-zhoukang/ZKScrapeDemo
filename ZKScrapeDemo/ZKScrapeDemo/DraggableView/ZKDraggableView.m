//
//  ZKDraggableView.m
//  ZKScrapeDemo
//
//  Created by Zhou Kang on 2018/4/2.
//  Copyright © 2018年 Zhou Kang Inc. All rights reserved.
//

#import "ZKDraggableView.h"
#import "ZKDraggableViewController.h"

#define ACTION_MARGIN_RIGHT  150
#define ACTION_MARGIN_LEFT   150
#define ACTION_VELOCITY 400
#define SCALE_STRENGTH 4
#define SCALE_MAX .93
#define ROTATION_MAX 1
#define ROTATION_STRENGTH   414

#define BUTTON_WIDTH   40

@interface ZKDraggableView ()

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic,strong) UIImageView *headerImageView;
@property (nonatomic,strong) UILabel *numLabel;

@end

@implementation ZKDraggableView {
    CGFloat _translationX;
    CGFloat _translationY;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupShadow];
        [self setupViews];
        [self addPanGesture];
    }
    return self;
}

- (void)addPanGesture {
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(beingDragged:)];
    [self addGestureRecognizer:self.panGestureRecognizer];
}

- (void)setupViews {
    UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    bgView.layer.cornerRadius = 4;
    bgView.clipsToBounds=YES;
    [self addSubview:bgView];
    
    self.leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(47, self.frame.size.height-13-BUTTON_WIDTH, BUTTON_WIDTH, BUTTON_WIDTH)];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"icon_unlike"] forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(leftClickAction) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-47-BUTTON_WIDTH, self.frame.size.height-13-BUTTON_WIDTH, BUTTON_WIDTH, BUTTON_WIDTH)];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(rightClickAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.leftBtn];
    [bgView addSubview:self.rightBtn];
    
    self.headerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.width)];
    self.headerImageView.backgroundColor=[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    self.headerImageView.userInteractionEnabled=YES;
    [bgView addSubview:self.headerImageView];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.headerImageView addGestureRecognizer:tap];
    
    
    self.numLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, self.headerImageView.frame.size.height-20-4, self.frame.size.width, 20)];
    self.numLabel.font=[UIFont systemFontOfSize:15];
    self.numLabel.textAlignment=NSTextAlignmentCenter;
    [bgView addSubview:self.numLabel];
    
    self.layer.allowsEdgeAntialiasing=YES;
    bgView.layer.allowsEdgeAntialiasing=YES;
    self.headerImageView.layer.allowsEdgeAntialiasing=YES;
}

- (void)setupShadow {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 4;
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

-(void)tap:(UITapGestureRecognizer*)sender{
    if (!self.enablePanGesture) {
        return;
    }
    NSLog(@"tap");
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.numLabel.text = self.userInfo[@"num"];
}

#pragma mark - 拖动
-(void)beingDragged:(UIPanGestureRecognizer *)gestureRecognizer {
    if (!self.enablePanGesture) {
        return;
    }
    _translationX = [gestureRecognizer translationInView:self].x;
    _translationY = [gestureRecognizer translationInView:self].y;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: { };
        case UIGestureRecognizerStateChanged: {
            CGFloat rotationStrength = MIN(_translationX / ROTATION_STRENGTH, ROTATION_MAX);
            CGFloat rotationAngel = (CGFloat) (ROTATION_ANGLE * rotationStrength);
            CGFloat scale = MAX(1 - fabs(rotationStrength) / SCALE_STRENGTH, SCALE_MAX);
            self.center = CGPointMake(self.originalCenter.x + _translationX, self.originalCenter.y + _translationY);
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            self.transform = scaleTransform;
            [self updateOverlay:_translationX];
        } break;
        case UIGestureRecognizerStateEnded: {
            [self handleGestureEndedWithDistance:_translationX velocity:[gestureRecognizer velocityInView:self.superview]];
        } break;
        default: {
            
        }
    }
}

- (void)updateOverlay:(CGFloat)translationX {
    if (translationX > 0) {
        self.rightBtn.transform = CGAffineTransformMakeScale(1+0.5*fabs(translationX/PAN_DISTANCE), 1+0.5*fabs(translationX/PAN_DISTANCE));
    }
    else {
        self.leftBtn.transform=CGAffineTransformMakeScale(1+0.5*fabs(translationX/PAN_DISTANCE), 1+0.5*fabs(translationX/PAN_DISTANCE));
    }
    if ([self.delegate respondsToSelector:@selector(draggableView:didMove:)]) {
        [self.delegate draggableView:self didMove:translationX];
    }
}

- (void)handleGestureEndedWithDistance:(CGFloat)distance velocity:(CGPoint)velocity {
    if (_translationX > 0 && (distance > ACTION_MARGIN_RIGHT||velocity.x > ACTION_VELOCITY)) {
        [self rightAction:velocity];
    }
    else if (_translationX <0 && (distance < -ACTION_MARGIN_LEFT||velocity.x < -ACTION_VELOCITY)) {
        [self leftAction:velocity];
    }
    else {
        [UIView animateWithDuration:RESET_ANIMATION_TIME
                         animations:^{
                             self.center = self.originalCenter;
                             self.transform = CGAffineTransformMakeRotation(0);
                             self.rightBtn.transform = CGAffineTransformMakeScale(1, 1);
                             self.leftBtn.transform = CGAffineTransformMakeScale(1, 1);
                         }];
        if ([self.delegate respondsToSelector:@selector(draggableViewDidMoveBack:)]) {
            [self.delegate draggableViewDidMoveBack:self];
        }
    }
}

-(void)rightAction:(CGPoint)velocity {
    if ([self.delegate respondsToSelector:@selector(draggableViewWillMoveOut:)]) {
        [self.delegate draggableViewWillMoveOut:self];
    }
    
    CGFloat distanceX = [[UIScreen mainScreen]bounds].size.width+CARD_WIDTH+self.originalCenter.x;//横向移动距离
    CGFloat distanceY = distanceX*_translationY/_translationX;//纵向移动距离
    CGPoint finishPoint = CGPointMake(self.originalCenter.x+distanceX, self.originalCenter.y+distanceY);//目标center点
    
    CGFloat vel = sqrtf(pow(velocity.x, 2)+pow(velocity.y, 2));//滑动手势横纵合速度
    CGFloat displace = sqrt(pow(distanceX-_translationX,2)+pow(distanceY-_translationY,2));//需要动画完成的剩下距离
    
    CGFloat duration = fabs(displace/vel);//动画时间
    
    if (duration>0.6) {
        duration=0.6;
    }
    else if (duration<0.3) {
        duration=0.3;
    }
    
    [UIView animateWithDuration:duration
                     animations:^{
                         self.rightBtn.transform=CGAffineTransformMakeScale(1.5, 1.5);
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(ROTATION_ANGLE);
                     } completion:^(BOOL complete){
                         self.rightBtn.transform=CGAffineTransformMakeScale(1, 1);
                         if ([self.delegate respondsToSelector:@selector(draggableView:didMoveToRight:)]) {
                             [self.delegate draggableView:self didMoveToRight:true];
                         }
                     }];
}

#pragma mark - 左滑后续事件
-(void)leftAction:(CGPoint)velocity {
    if ([self.delegate respondsToSelector:@selector(draggableViewWillMoveOut:)]) {
        [self.delegate draggableViewWillMoveOut:self];
    }
    
    CGFloat distanceX = -CARD_WIDTH - self.originalCenter.x;//横向移动距离
    CGFloat distanceY = distanceX*_translationY/_translationX;//纵向移动距离
    CGPoint finishPoint = CGPointMake(self.originalCenter.x+distanceX, self.originalCenter.y+distanceY);//目标center点
    
    CGFloat vel = sqrtf(pow(velocity.x, 2)+pow(velocity.y, 2));//滑动手势横纵合速度
    CGFloat displace = sqrt(pow(distanceX-_translationX,2)+pow(distanceY-_translationY,2));//需要动画完成的剩下距离
    
    CGFloat duration = fabs(displace/vel); //动画时间
    
    if (duration>0.6) {
        duration=0.6;
    }
    else if (duration<0.3) {
        duration=0.3;
    }
    
    [UIView animateWithDuration:duration
                     animations:^{
                         self.leftBtn.transform=CGAffineTransformMakeScale(1.5, 1.5);
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(-ROTATION_ANGLE);
                     } completion:^(BOOL complete){
                         self.leftBtn.transform=CGAffineTransformMakeScale(1, 1);
                         if ([self.delegate respondsToSelector:@selector(draggableView:didMoveToRight:)]) {
                             [self.delegate draggableView:self didMoveToRight:false];
                         }
                     }];
}

#pragma mark - 点击右滑事件
-(void)rightClickAction {
    if (self.enablePanGesture==NO) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(draggableViewWillMoveOut:)]) {
        [self.delegate draggableViewWillMoveOut:self];
    }
    
    CGPoint finishPoint = CGPointMake([[UIScreen mainScreen]bounds].size.width+CARD_WIDTH*2/3, 2*PAN_DISTANCE+self.frame.origin.y);
    [UIView animateWithDuration:CLICK_ANIMATION_TIME
                     animations:^{
                         self.rightBtn.transform=CGAffineTransformMakeScale(1.5, 1.5);
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(ROTATION_ANGLE);
                     } completion:^(BOOL complete) {
                         self.rightBtn.transform=CGAffineTransformMakeScale(1, 1);
                         if ([self.delegate respondsToSelector:@selector(draggableView:didMoveToRight:)]) {
                             [self.delegate draggableView:self didMoveToRight:true];
                         }
                     }];
}

- (void)leftClickAction {
    if (!self.enablePanGesture) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(draggableViewWillMoveOut:)]) {
        [self.delegate draggableViewWillMoveOut:self];
    }
    
    CGPoint finishPoint = CGPointMake(-CARD_WIDTH*2/3, 2*PAN_DISTANCE+self.frame.origin.y);
    [UIView animateWithDuration:CLICK_ANIMATION_TIME
                     animations:^{
                         self.leftBtn.transform = CGAffineTransformMakeScale(1.5, 1.5);
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(-ROTATION_ANGLE);
                     } completion:^(BOOL complete){
                         self.leftBtn.transform = CGAffineTransformMakeScale(1, 1);
                         if ([self.delegate respondsToSelector:@selector(draggableView:didMoveToRight:)]) {
                             [self.delegate draggableView:self didMoveToRight:false];
                         }
                     }];
}

@end
