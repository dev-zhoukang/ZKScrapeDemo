//
//  NSTimer+USAutoRelease.m
//  HappyIn
//
//  Created by ZK on 16/5/9.
//  Copyright © 2018年 Zhou Kang Inc. All rights reserved.
//

#import "NSTimer+ZKAutoRelease.h"

@implementation NSTimer (ZKAutoRelease)

+ (NSTimer *)zk_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)(void))block repeates:(BOOL)repeates {
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(_blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeates];
}

+ (void)_blockInvoke:(NSTimer *)timer {
    void (^block) (void) = timer.userInfo;
    !block ?: block();
}

@end
