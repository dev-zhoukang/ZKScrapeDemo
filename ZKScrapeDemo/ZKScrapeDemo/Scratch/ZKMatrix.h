//
//  ZKMatrix.h
//  ZKScrapeDemo
//
//  Created by Zhou Kang on 2018/4/2.
//  Copyright © 2018年 Zhou Kang Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    size_t x;
    size_t y;
} ZKSize;

@interface ZKMatrix : NSObject

- (id)initWithMaxX:(size_t)x maxY:(size_t)y;
- (id)initWithMax:(ZKSize)maxCoords;

- (char)valueForCoords:(size_t)x y:(size_t)y;
- (void)setValue:(char)value forCoords:(size_t)x y:(size_t)y;

- (void)fillWithValue:(char)value;

@property (nonatomic, assign, readonly) ZKSize max;

@end

FOUNDATION_EXPORT ZKSize ZKSizeMake(size_t x, size_t y);
