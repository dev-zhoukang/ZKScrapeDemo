//
//  ZKMatrix.m
//  ZKScrapeDemo
//
//  Created by Zhou Kang on 2018/4/2.
//  Copyright © 2018年 Zhou Kang Inc. All rights reserved.
//

#import "ZKMatrix.h"

@interface ZKMatrix () {
    char *_data;
}

@end

@implementation ZKMatrix

- (id)initWithMaxX:(size_t)x maxY:(size_t)y {
    if (self = [super init]) {
        _data = (char *)malloc(x * y);
        _max = ZKSizeMake(x, y);
        [self fillWithValue:0];
    }
    return self;
}

- (id)initWithMax:(ZKSize)maxCoords {
    return [self initWithMaxX:maxCoords.x maxY:maxCoords.y];
}

#pragma mark -

- (char)valueForCoords:(size_t)x y:(size_t)y {
    long index = x + self.max.x * y;
    if (index >= self.max.x * self.max.y){
        return 1;
    }
    else {
        return _data[x + self.max.x * y];
    }
}

- (void)setValue:(char)value forCoords:(size_t)x y:(size_t)y {
    long index = x + self.max.x * y;
    if (index < self.max.x * self.max.y){
        _data[x + self.max.x * y] = value;
    }
}

- (void)fillWithValue:(char)value {
    char *temp = _data;
    for(size_t i = 0; i < self.max.x * self.max.y; ++i){
        *temp = value;
        ++temp;
    }
}

#pragma mark -

- (void)dealloc {
    if(_data){
        free(_data);
    }
}

@end

ZKSize ZKSizeMake(size_t x, size_t y) {
    ZKSize size = { x, y };
    return size;
}
