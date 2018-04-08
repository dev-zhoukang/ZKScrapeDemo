//
//  ZKScreenRecorder.m
//  ZKScrapeDemo
//
//  Created by Zhou Kang on 2018/3/31.
//  Copyright © 2018年 Zhou Kang Inc. All rights reserved.
//

#import "ZKScreenRecorder.h"

#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif

@interface ZKScreenRecorder() <RPScreenRecorderDelegate, RPPreviewViewControllerDelegate>

@end

@implementation ZKScreenRecorder

+ (instancetype)shareInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [RPScreenRecorder sharedRecorder].delegate = self;
    }
    return self;
}

- (BOOL)startRecord:(BOOL)microphoneEnabled {
    if (![[RPScreenRecorder sharedRecorder] isAvailable]) {
        NSLog(@"不支持ReplayKit录制");
        return false;
    }
    NSLog(@"%d",[[RPScreenRecorder sharedRecorder] isRecording]);
    if ([[RPScreenRecorder sharedRecorder] isRecording]) {
        return false;
    }
    [[RPScreenRecorder sharedRecorder] startRecordingWithMicrophoneEnabled:microphoneEnabled handler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"录制失败 %@",error);
        }
        else {
            NSLog(@"录制成功");
        }
    }];
    return YES;
}

- (void)stopRecord {
    NSLog(@"结束录制");
    [[RPScreenRecorder sharedRecorder] stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        UIViewController *vc = [self rootViewController];
        previewViewController.previewControllerDelegate = self;
        NSLog(@"%@",[NSThread currentThread]);
        [vc presentViewController:previewViewController animated:YES completion:nil];
    }];
}

- (UIViewController *)rootViewController {
    return [[[UIApplication sharedApplication] keyWindow] rootViewController];
}

#pragma mark - <RPScreenRecordDelegate>

- (void)screenRecorder:(RPScreenRecorder *)screenRecorder didStopRecordingWithError:(NSError *)error previewViewController:(nullable RPPreviewViewController *)previewViewController {
    NSLog(@"%s  error = %@", __FUNCTION__, error);
}

- (void)screenRecorderDidChangeAvailability:(RPScreenRecorder *)screenRecorder {
    NSLog(@"screenRecorderDidChangeAvailability %d %d",screenRecorder.isRecording, screenRecorder.isAvailable);
}

#pragma mark - <RPPreviewViewControllerDelegate>

- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController {
    NSLog(@"previewControllerDidFinish");
    [[self rootViewController] dismissViewControllerAnimated:true completion:nil];
}

@end
