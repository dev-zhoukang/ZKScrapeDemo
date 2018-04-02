//
//  ZKDraggableViewController.m
//  ZKScrapeDemo
//
//  Created by Zhou Kang on 2018/4/2.
//  Copyright © 2018年 Zhou Kang Inc. All rights reserved.
//

#import "ZKDraggableViewController.h"

#define CARD_NUM 5
#define MIN_INFO_NUM 10
#define CARD_SCALE 0.95

@interface ZKDraggableViewController () <ZKDraggableViewDelegate>

@property(nonatomic) NSInteger page;

@end

@implementation ZKDraggableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ZTDraggableView";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.allCards = [NSMutableArray array];
    self.sourceObject = [NSMutableArray array];
    self.page = 0;
    
    [self addControls];
    [self addCards];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestSourceData:YES];
    });
    
}

-(void)addControls{
    UIButton *reloadBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [reloadBtn setTitle:@"Reload" forState:UIControlStateNormal];
    reloadBtn.frame = CGRectMake(self.view.center.x-25, self.view.frame.size.height-60, 50, 30);
    [reloadBtn addTarget:self action:@selector(refreshAllCards) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reloadBtn];
}

- (void)refreshAllCards {
    
    self.sourceObject=[@[] mutableCopy];
    self.page = 0;
    
    for (int i=0; i<_allCards.count ;i++) {
        
        ZKDraggableView *card=self.allCards[i];
        
        CGPoint finishPoint = CGPointMake(-CARD_WIDTH, 2*PAN_DISTANCE+card.frame.origin.y);
        
        [UIView animateKeyframesWithDuration:0.5 delay:0.06*i options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            card.center = finishPoint;
            card.transform = CGAffineTransformMakeRotation(-ROTATION_ANGLE);
            
        } completion:^(BOOL finished) {
            
            card.rightBtn.transform=CGAffineTransformMakeScale(1, 1);
            card.transform = CGAffineTransformMakeRotation(ROTATION_ANGLE);
            card.hidden=YES;
            card.center=CGPointMake([[UIScreen mainScreen]bounds].size.width+CARD_WIDTH, self.view.center.y);
            
            if (i==self->_allCards.count-1) {
                [self requestSourceData:YES];
            }
        }];
    }
}

#pragma mark - 请求数据
-(void)requestSourceData:(BOOL)shouldReloadAllData{
    /*
     在此添加网络数据请求代码
     */
    
    NSMutableArray *objectArray = [@[] mutableCopy];
    for (int i = 1; i <= 10; i++) {
        [objectArray addObject:@{@"num":[NSString stringWithFormat:@"%ld",self.page*10+i]}];
    }
    [self.sourceObject addObjectsFromArray:objectArray];
    self.page++;
    
    if (shouldReloadAllData) {
        [self loadAllCards];
    }
}

#pragma mark - 重新加载卡片
- (void)loadAllCards {
    for (int i=0; i < self.allCards.count; i++) {
        ZKDraggableView *draggableView = self.allCards[i];
        if ([self.sourceObject firstObject]) {
            draggableView.userInfo=[self.sourceObject firstObject];
            [self.sourceObject removeObjectAtIndex:0];
            [draggableView layoutSubviews];
            draggableView.hidden=NO;
        }
        else {
            draggableView.hidden=YES;//如果没有数据则隐藏卡片
        }
    }
    
    for (int i=0; i<_allCards.count ;i++) {
        
        ZKDraggableView *draggableView=self.allCards[i];
        
        CGPoint finishPoint = CGPointMake(self.view.center.x, self.view.center.y);
        
        [UIView animateKeyframesWithDuration:0.5 delay:0.06*i options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            draggableView.center = finishPoint;
            draggableView.transform = CGAffineTransformMakeRotation(0);
            
            if (i>0&&i<CARD_NUM-1) {
                ZKDraggableView *preDraggableView=[self->_allCards objectAtIndex:i-1];
                draggableView.transform=CGAffineTransformScale(draggableView.transform, pow(CARD_SCALE, i), pow(CARD_SCALE, i));
                CGRect frame=draggableView.frame;
                frame.origin.y=preDraggableView.frame.origin.y+(preDraggableView.frame.size.height-frame.size.height)+10*pow(0.7,i);
                draggableView.frame=frame;
                
            }else if (i==CARD_NUM-1) {
                ZKDraggableView *preDraggableView=[self->_allCards objectAtIndex:i-1];
                draggableView.transform=preDraggableView.transform;
                draggableView.frame=preDraggableView.frame;
            }
        } completion:^(BOOL finished) {
            
        }];
        
        draggableView.originalCenter=draggableView.center;
        draggableView.originalTransform=draggableView.transform;
        
        if (i == CARD_NUM-1) {
            self.lastCardCenter=draggableView.center;
            self.lastCardTransform=draggableView.transform;
        }
    }
}

#pragma mark - 首次添加卡片
-(void)addCards{
    for (int i = 0; i<CARD_NUM; i++) {
        CGRect draggableViewFrame = CGRectMake([[UIScreen mainScreen]bounds].size.width+CARD_WIDTH,
                                               self.view.center.y-CARD_HEIGHT/2,
                                               CARD_WIDTH,
                                               CARD_HEIGHT);
        
        ZKDraggableView *draggableView = [[ZKDraggableView alloc] initWithFrame:draggableViewFrame];
        
        if (i>0 && i<CARD_NUM-1) {
            draggableView.transform = CGAffineTransformScale(draggableView.transform, pow(CARD_SCALE, i), pow(CARD_SCALE, i));
        }
        else if (i==CARD_NUM-1) {
            draggableView.transform=CGAffineTransformScale(draggableView.transform, pow(CARD_SCALE, i-1), pow(CARD_SCALE, i-1));
        }
        draggableView.transform = CGAffineTransformMakeRotation(ROTATION_ANGLE);
        draggableView.delegate = self;
        
        [_allCards addObject:draggableView];
        if (i==0) {
            draggableView.enablePanGesture=YES;
        }
        else{
            draggableView.enablePanGesture=NO;
        }
    }
    
    for (int i=(int)CARD_NUM-1; i>=0; i--) {
        [self.view addSubview:_allCards[i]];
    }
}

#pragma mark - <ZKDraggableViewDelegate>

- (void)draggableView:(ZKDraggableView *)draggableView didMoveToRight:(BOOL)isRight {
    if (isRight) {
        [self like:draggableView.userInfo];
    }
    else {
        [self unlike:draggableView.userInfo];
    }
    
    [_allCards removeObject:draggableView];
    draggableView.transform = self.lastCardTransform;
    draggableView.center = self.lastCardCenter;
    draggableView.enablePanGesture = false;
    [self.view insertSubview:draggableView belowSubview:[_allCards lastObject]];
    [_allCards addObject:draggableView];
    
    if ([self.sourceObject firstObject]) {
        draggableView.userInfo = [self.sourceObject firstObject];
        [self.sourceObject removeObjectAtIndex:0];
        [draggableView layoutSubviews];
        if (self.sourceObject.count < MIN_INFO_NUM) {
            [self requestSourceData:NO];
        }
    }
    else {
        draggableView.hidden = true;//如果没有数据则隐藏卡片
    }
    
    for (int i = 0; i<CARD_NUM; i++) {
        ZKDraggableView *draggableView = _allCards[i];
        draggableView.originalCenter = draggableView.center;
        draggableView.originalTransform = draggableView.transform;
        if (i==0) {
            draggableView.enablePanGesture=YES;
        }
    }
}

- (void)draggableViewWillMoveOut:(ZKDraggableView *)draggableView {
    [UIView animateWithDuration:0.2
                     animations:^{
                         for (int i = 1; i<CARD_NUM-1; i++) {
                             ZKDraggableView *nextDraggableView=self->_allCards[i];
                             ZKDraggableView *currentDraggableView=self->_allCards[i-1];
                             nextDraggableView.transform = currentDraggableView.originalTransform;
                             nextDraggableView.center = currentDraggableView.originalCenter;
                         }
                     } completion:nil];
}

- (void)draggableView:(ZKDraggableView *)draggableView didMove:(CGFloat)translationX {
    if (fabs(translationX) > PAN_DISTANCE) {
        return;
    }
    for (int i = 1; i<CARD_NUM-1; i++) {
        ZKDraggableView *draggableView = _allCards[i];
        ZKDraggableView *preDraggableView = _allCards[i-1];
        draggableView.transform = CGAffineTransformScale(draggableView.originalTransform, 1+(1/CARD_SCALE-1)*fabs(translationX/PAN_DISTANCE)*0.6, 1+(1/CARD_SCALE-1)*fabs(translationX/PAN_DISTANCE)*0.6);//0.6为缩减因数，使放大速度始终小于卡片移动速度
        CGPoint center = draggableView.center;
        center.y = draggableView.originalCenter.y-(draggableView.originalCenter.y-preDraggableView.originalCenter.y)*fabs(translationX/PAN_DISTANCE)*0.6;//此处的0.6同上
        draggableView.center = center;
    }
}

- (void)draggableViewDidMoveBack:(ZKDraggableView *)draggleView {
    for (int i = 1; i<CARD_NUM-1; i++) {
        ZKDraggableView *draggableView=_allCards[i];
        [UIView animateWithDuration:RESET_ANIMATION_TIME
                         animations:^{
                             draggableView.transform = draggableView.originalTransform;
                             draggableView.center = draggableView.originalCenter;
                         }];
    }
}

- (void)like:(NSDictionary*)userInfo {
    NSLog(@"like:%@",userInfo[@"num"]);
}

- (void)unlike:(NSDictionary*)userInfo {
    NSLog(@"unlike:%@",userInfo[@"num"]);
}

@end
