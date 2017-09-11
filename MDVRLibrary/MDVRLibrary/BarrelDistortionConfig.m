//
//  BarrelDistortionConfig.m
//  MDVRLibrary
//
//  Created by Asha on 2017/5/11.
//  Copyright © 2017年 asha. All rights reserved.
//

#import "BarrelDistortionConfig.h"

@implementation BarrelDistortionConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.paramA = -0.068; // affects only the outermost pixels of the image
        self.paramB = 0.320000; // most cases only require b optimization
        self.paramC = -0.2; // most uniform correction
        self.scale = 0.95f;
        self.defaultEnabled = NO;
    }
    return self;
}

@end


