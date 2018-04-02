//
//  ZKScratchImageView.m
//  ZKScrapeDemo
//
//  Created by Zhou Kang on 2018/4/2.
//  Copyright © 2018年 Zhou Kang Inc. All rights reserved.
//

#import "ZKScratchImageView.h"
#import "ZKMatrix.h"
#import "UIView+Addition.h"
#import <YYKit.h>

const size_t ZKScratchImageViewDefaultRadius            = 30;

inline CGPoint fromUItoQuartz(CGPoint point, CGSize frameSize){
    point.y = frameSize.height - point.y;
    return point;
}

inline CGPoint scalePoint(CGPoint point, CGSize previousSize, CGSize currentSize){
    return CGPointMake(currentSize.width * point.x / previousSize.width, currentSize.height * point.y / previousSize.height);
}

@interface ZKScratchImageView () {
    size_t              _tilesX;
    size_t              _tilesY;
    int                 _tilesFilled;
    CGColorSpaceRef     _colorSpace;
    CGContextRef        _imageContext;
    
    size_t              _radius;
}

@property (nonatomic, strong) ZKMatrix          *maskedMatrix;
@property (nonatomic, strong) NSMutableArray    *touchPoints;
@property (nonatomic, strong) YYAnimatedImageView   *fireworksImageView;
@property (nonatomic, strong) UIImage               *prevImg;
@property (nonatomic, assign) size_t                prevRadius;
@property (nonatomic, strong) UIImageView           *maskImgView;

@end

@implementation ZKScratchImageView

#pragma mark - inner initalization

- (void)initialize {
    self.userInteractionEnabled = YES;
    _tilesFilled = 0;
    
    if (nil == self.image) {
        _tilesX = _tilesY = 0;
        self.maskedMatrix = nil;
        if (NULL != _imageContext) {
            CGContextRelease(_imageContext);
            _imageContext = NULL;
        }
        if (NULL != _colorSpace) {
            CGColorSpaceRelease(_colorSpace);
            _colorSpace = NULL;
        }
    }
    else {
        self.touchPoints = [NSMutableArray array];
        // CGSize size = self.image.size;
        CGSize size = CGSizeMake(self.image.size.width * self.image.scale, self.image.size.height * self.image.scale);
        
        // initalize bitmap context
        if (NULL == _colorSpace) {
            _colorSpace = CGColorSpaceCreateDeviceRGB();
        }
        if (NULL != _imageContext) {
            CGContextRelease(_imageContext);
        }
        _imageContext = CGBitmapContextCreate(0, size.width, size.height, 8, size.width * 4, _colorSpace, kCGImageAlphaPremultipliedLast);
        CGContextDrawImage(_imageContext, CGRectMake(0, 0, size.width, size.height), self.image.CGImage);
        
        int blendMode = kCGBlendModeClear;
        CGContextSetBlendMode(_imageContext, (CGBlendMode) blendMode);
        
        _tilesX = size.width  / (2 * _radius);
        _tilesY = size.height / (2 * _radius);
        
        self.maskedMatrix = [[ZKMatrix alloc] initWithMax:ZKSizeMake(_tilesX, _tilesY)];
    }
}

- (void)reset {
    [self clearMemory];
    [self addSubview:self.maskImgView];
    [UIView animateWithDuration:.25 animations:^{
        self.maskImgView.alpha = 1.f;
    } completion:^(BOOL finished) {
        [self setImage:self.prevImg radius:self.prevRadius];
        
        [self.maskImgView removeFromSuperview];
        self.maskImgView = nil;
    }];
}

- (void)clearMemory {
    self.maskedMatrix = nil;
    if (NULL != _imageContext) {
        CGContextRelease(_imageContext);
        _imageContext = NULL;
    }
    if (NULL != _colorSpace) {
        CGColorSpaceRelease(_colorSpace);
        _colorSpace = NULL;
    }
    self.touchPoints = nil;
}

#pragma mark -

- (void)setImage:(UIImage *)image radius:(size_t)radius {
    self.prevImg = [image copy];
    _prevRadius = radius;
    
    [super setImage:image];
    _radius = radius;
    [self initialize];
}

- (void)setImage:(UIImage *)image {
    if (image != self.image) {
        [self setImage:image radius:ZKScratchImageViewDefaultRadius];
    }
}

#pragma mark -

- (CGFloat)maskingProgress {
    return ( ((CGFloat)_tilesFilled) / ((CGFloat)(self.maskedMatrix.max.x * self.maskedMatrix.max.y)) );
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!self.image){
        return ;
    }
    [super setImage:[self genHollowedImgWithTouches:touches]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!self.image){
        return ;
    }
    [super setImage:[self genHollowedImgWithTouches:touches]];
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGPoint prevLocation = [touch previousLocationInView:self];
    if (location.x - prevLocation.x > 10) {
        CGFloat distance = distanceBetweenPoints(location, prevLocation);
    } else {
        //finger touch went left
    }
    if (location.y - prevLocation.y > 0) {
        //finger touch went upwards
    } else {
        //finger touch went downwards
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideFirework];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reset];
    });
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideFirework];
}

#pragma mark -

-(CGPoint)normalizeVector:(CGPoint)p{
    float len = sqrt(p.x*p.x + p.y*p.y);
    if(0 == len){return CGPointMake(0, 0);}
    p.x /= len;
    p.y /= len;
    return p;
}

- (UIImage *)genHollowedImgWithTouches:(NSSet *)touches {
    CGSize size = CGSizeMake(self.image.size.width * self.image.scale, self.image.size.height * self.image.scale);
    CGContextRef ctx = _imageContext;
    
    CGContextSetFillColorWithColor(ctx,[UIColor clearColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx,[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor);
    int tempFilled = _tilesFilled;
    
    // process touches
    for (UITouch *touch in touches) {
        CGContextBeginPath(ctx);
        CGPoint touchPoint = [touch locationInView:self];
        touchPoint = fromUItoQuartz(touchPoint, self.bounds.size);
        touchPoint = scalePoint(touchPoint, self.bounds.size, size);
        
        if(UITouchPhaseBegan == touch.phase){
            [self.touchPoints removeAllObjects];
            [self.touchPoints addObject:[NSValue valueWithCGPoint:touchPoint]];
            [self.touchPoints addObject:[NSValue valueWithCGPoint:touchPoint]];
            // 先画椭圆Ellipse
            CGRect rect = CGRectMake(touchPoint.x - _radius, touchPoint.y - _radius, _radius*2, _radius*2);
            CGContextAddEllipseInRect(ctx, rect);
            CGContextFillPath(ctx);
            [self fillTileWithPoint:rect.origin];
        }
        else if (UITouchPhaseMoved == touch.phase) {
            [self.touchPoints addObject:[NSValue valueWithCGPoint:touchPoint]];
            // then touch moved, we draw superior-width line
            CGContextSetStrokeColor(ctx, CGColorGetComponents([UIColor yellowColor].CGColor));
            CGContextSetLineCap(ctx, kCGLineCapRound);
            CGContextSetLineWidth(ctx, 2 * _radius);
//            CGContextMoveToPoint(ctx, prevPoint.x, prevPoint.y);
//            CGContextAddLineToPoint(ctx, rect.origin.x, rect.origin.y);
            
            while(self.touchPoints.count > 3){
                CGPoint bezier[4];
                bezier[0] = ((NSValue*)self.touchPoints[1]).CGPointValue;
                bezier[3] = ((NSValue*)self.touchPoints[2]).CGPointValue;
                
                CGFloat k = 0.3;
                CGFloat len = sqrt(pow(bezier[3].x - bezier[0].x, 2) + pow(bezier[3].y - bezier[0].y, 2));
                bezier[1] = ((NSValue*)self.touchPoints[0]).CGPointValue;
                bezier[1] = [self normalizeVector:CGPointMake(bezier[0].x - bezier[1].x - (bezier[0].x - bezier[3].x), bezier[0].y - bezier[1].y - (bezier[0].y - bezier[3].y) )];
                bezier[1].x *= len * k;
                bezier[1].y *= len * k;
                bezier[1].x += bezier[0].x;
                bezier[1].y += bezier[0].y;
                
                bezier[2] = ((NSValue*)self.touchPoints[3]).CGPointValue;
                bezier[2] = [self normalizeVector:CGPointMake( (bezier[3].x - bezier[2].x)  - (bezier[3].x - bezier[0].x), (bezier[3].y - bezier[2].y)  - (bezier[3].y - bezier[0].y) )];
                bezier[2].x *= len * k;
                bezier[2].y *= len * k;
                bezier[2].x += bezier[3].x;
                bezier[2].y += bezier[3].y;
                
                CGContextMoveToPoint(ctx, bezier[0].x, bezier[0].y);
                CGContextAddCurveToPoint(ctx, bezier[1].x, bezier[1].y, bezier[2].x, bezier[2].y, bezier[3].x, bezier[3].y);
                
                [self.touchPoints removeObjectAtIndex:0];
            }
            
            CGContextStrokePath(ctx);
            
            CGPoint prevPoint = [touch previousLocationInView:self];
            prevPoint = fromUItoQuartz(prevPoint, self.bounds.size);
            prevPoint = scalePoint(prevPoint, self.bounds.size, size);
            
            [self showFireworkAtPoint:CGPointMake(prevPoint.x * .5f, CGRectGetHeight(self.frame)-prevPoint.y*0.5f)];
            
            [self fillTileWithTwoPoints:touchPoint end:prevPoint];
        }
    }
    
    // was _tilesFilled changed?
    if(tempFilled != _tilesFilled) {
        if ([self.delegate respondsToSelector:@selector(scratchImageView:didChangeMaskingProgress:)]) {
            [_delegate scratchImageView:self didChangeMaskingProgress:self.maskingProgress];
        }
    }
    
    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return image;
}

/*
 * filling tile with one ellipse
 */
-(void)fillTileWithPoint:(CGPoint) point{
    size_t x,y;
    point.x = MAX( MIN(point.x, self.image.size.width - 1) , 0);
    point.y = MAX( MIN(point.y, self.image.size.height - 1), 0);
    x = point.x * self.maskedMatrix.max.x / self.image.size.width;
    y = point.y * self.maskedMatrix.max.y / self.image.size.height;
    char value = [self.maskedMatrix valueForCoords:x y:y];
    if (!value){
        [self.maskedMatrix setValue:1 forCoords:x y:y];
        _tilesFilled++;
    }
}

/*
 * filling tile with line
 */
-(void)fillTileWithTwoPoints:(CGPoint)begin end:(CGPoint)end{
    CGFloat incrementerForx,incrementerFory;
    /* incrementers - about size of a tile */
    incrementerForx = (begin.x < end.x ? 1 : -1) * self.image.size.width / _tilesX;
    incrementerFory = (begin.y < end.y ? 1 : -1) * self.image.size.height / _tilesY;
    
    // iterate on points between begin and end
    CGPoint i = begin;
    while(i.x <= MAX(begin.x, end.x) && i.y <= MAX(begin.y, end.y) && i.x >= MIN(begin.x, end.x) && i.y >= MIN(begin.y, end.y)){
        [self fillTileWithPoint:i];
        i.x += incrementerForx;
        i.y += incrementerFory;
    }
    [self fillTileWithPoint:end];
}

- (void)dealloc {
    [self clearMemory];
}

- (YYAnimatedImageView *)fireworksImageView {
    if (!_fireworksImageView) {
        YYImage *img = [YYImage imageNamed:@"fireworks_0"];
        _fireworksImageView = [[YYAnimatedImageView alloc] initWithImage:img];
        _fireworksImageView.us_size = CGSizeMake(120, 120);
        [self addSubview:_fireworksImageView];
    }
    return _fireworksImageView;
}

- (UIImageView *)maskImgView {
    if (!_maskImgView) {
        _maskImgView = [UIImageView new];
        _maskImgView.frame = self.bounds;
        _maskImgView.image = self.prevImg;
        _maskImgView.alpha = 0;
    }
    return _maskImgView;
}

- (void)showFireworkAtPoint:(CGPoint)point {
    self.fireworksImageView.center = point;
    [UIView animateWithDuration:.1 animations:^{
        self.fireworksImageView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
}

- (void)hideFirework {
    [UIView animateWithDuration:.1 animations:^{
        self.fireworksImageView.transform = CGAffineTransformMakeScale(.001, .001);
    } completion:^(BOOL finished) {
        [self.fireworksImageView removeFromSuperview];
        self.fireworksImageView = nil;
    }];
}

CGFloat distanceBetweenPoints(CGPoint first, CGPoint second) {
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(deltaX*deltaX + deltaY*deltaY );
};

@end
