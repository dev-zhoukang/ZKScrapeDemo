//
//  ZKTwoViewController.m
//  ZKScrapeDemo
//
//  Created by Zhou Kang on 2018/4/2.
//  Copyright © 2018年 Zhou Kang Inc. All rights reserved.
//

#import "ZKTwoViewController.h"
#import <YYKit.h>
#import <Masonry.h>
#import "ZKScratchImageView.h"
#import "ZKScreenRecorder.h"

@interface ZKTwoViewController () <ZKScratchImageViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *velocityLabel;
@property (nonatomic, strong) ZKScratchImageView *maskImageView;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation ZKTwoViewController {
    NSInteger _i;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageView.userInteractionEnabled = true;
    _maskImageView = [[ZKScratchImageView alloc] init];
    [_imageView addSubview:_maskImageView];
    _maskImageView.frame = _imageView.bounds;

    UIImage *maskImg = [[_imageView snapshotImage] imageByBlurLight];
    [_maskImageView setImage:maskImg radius:10];
    _maskImageView.delegate = self;
    _maskImageView.clipsToBounds = true;
    
    [self.audioPlayer play];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[ZKScreenRecorder shareInstance] startRecord:true];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[ZKScreenRecorder shareInstance] stopRecord];
    });
}

#pragma mark - <ZKScratchImageViewDelegate>

- (void)scratchImageView:(ZKScratchImageView *)scratchImageView didChangeMaskingProgress:(CGFloat)maskingProgress {
    //NSLog(@"%f", maskingProgress);
}

- (void)scratchImageView:(ZKScratchImageView *)scratchImageView touchesMovedWithVelocity:(CGFloat)velocity {
    if (++ _i % 10 == 0) {
        NSLog(@"%f", velocity);
        NSInteger intReslt = ceilf(velocity);
        _velocityLabel.text = [NSString stringWithFormat:@"Velocity: %.0ld dt/frame", (long)intReslt];
    }
}

- (AVAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"nilin.m4a" ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:audioPath];
        NSError *error = nil;
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if (error) {
            NSLog(@"audio player error: %@", error.localizedDescription);
            return nil;
        }
        [_audioPlayer prepareToPlay];
    }
    return _audioPlayer;
}

@end
