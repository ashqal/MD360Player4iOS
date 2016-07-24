//
//  MDPlaneScaleCalculator.h
//  MDVRLibrary
//
//  Created by ashqal on 16/7/24.
//  Copyright © 2016年 asha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDVRHeader.h"
#import "MDVRLibrary.h"

@interface MDPlaneScaleCalculator : NSObject

- (instancetype)initWithScale:(MDModeProjection) projection sizeContext:(MDSizeContext*)sizeContext;

- (float)getTextureRatio;
- (void)setViewportRatio:(float)ratio;
- (void)calculate;
- (float)getViewportWidth;
- (float)getViewportHeight;
- (float)getTextureWidth;
- (float)getTextureHeight;

@end
