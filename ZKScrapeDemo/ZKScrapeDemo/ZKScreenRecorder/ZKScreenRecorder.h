//
//  ZKScreenRecorder.h
//  ZKScrapeDemo
//
//  Created by Zhou Kang on 2018/3/31.
//  Copyright © 2018年 Zhou Kang Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReplayKit/ReplayKit.h>

@protocol ZKScreenRecorderDelegate <NSObject>

@end

@interface ZKScreenRecorder : NSObject

@property(nonatomic, weak) id <ZKScreenRecorderDelegate> delegate;

+ (instancetype)shareInstance;

- (BOOL)startRecord:(BOOL)microphoneEnabled;

- (void)stopRecord;

@end
