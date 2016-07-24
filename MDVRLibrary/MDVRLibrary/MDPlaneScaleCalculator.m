//
//  MDPlaneScaleCalculator.m
//  MDVRLibrary
//
//  Created by ashqal on 16/7/24.
//  Copyright © 2016年 asha. All rights reserved.
//

#import "MDPlaneScaleCalculator.h"

static const float sPlaneScaleBaseValue = 1.0f;

@interface MDPlaneScaleCalculator(){
    MDModeProjection project;
    float mViewportRatio;
    float mViewportWidth;
    float mViewportHeight;
    float mTextureWidth;
    float mTextureHeight;
}
@property (nonatomic,weak) MDSizeContext* sizeContext;
@end

@implementation MDPlaneScaleCalculator

- (instancetype)initWithScale:(MDModeProjection) projection sizeContext:(MDSizeContext*)sizeContext {
    self = [super init];
    if (self) {
        self->project = projection;
        self->mViewportWidth = self->mViewportHeight = self->mTextureWidth = self->mTextureHeight = sPlaneScaleBaseValue;
        self.sizeContext = sizeContext;
    }
    return self;
}

- (float)getTextureRatio{
    return [self.sizeContext getTextureRatioValue];
}

- (void)setViewportRatio:(float)ratio{
    self->mViewportRatio = ratio;
}

- (float)getViewportWidth{
    return self->mViewportWidth;
}

- (float)getViewportHeight{
    return self->mViewportHeight;
}

- (float)getTextureWidth{
    return self->mTextureWidth;
}

- (float)getTextureHeight{
    return self->mTextureHeight;
}

- (void)calculate{
    float viewportRatio = mViewportRatio;
    float textureRatio = [self getTextureRatio];
    
    switch (self->project){
        case MDModeProjectionPlaneFull:
            // fullscreen
            self->mViewportWidth = self->mViewportHeight = self->mTextureWidth = self->mTextureHeight = sPlaneScaleBaseValue;
            break;
        case MDModeProjectionPlaneCrop:
            if (textureRatio  > viewportRatio){
                /**
                 * crop width of texture
                 *
                 * texture
                 * ----------------------
                 * |    |          |    |
                 * |    | viewport |    |
                 * |    |          |    |
                 * ----------------------
                 * */
                mViewportWidth = sPlaneScaleBaseValue * viewportRatio;
                mViewportHeight = sPlaneScaleBaseValue;
                
                mTextureWidth = sPlaneScaleBaseValue * textureRatio;
                mTextureHeight = sPlaneScaleBaseValue;
            } else {
                /**
                 * crop height of texture
                 *
                 * texture
                 * -----------------------
                 * |---------------------|
                 * |                     |
                 * |      viewport       |
                 * |                     |
                 * |---------------------|
                 * -----------------------
                 * */
                mViewportWidth = sPlaneScaleBaseValue;
                mViewportHeight = sPlaneScaleBaseValue / viewportRatio;
                
                mTextureWidth = sPlaneScaleBaseValue;
                mTextureHeight = sPlaneScaleBaseValue / textureRatio;
            }
            break;
        case MDModeProjectionPlaneFit:
        default:
            if (viewportRatio > textureRatio){
                /**
                 * fit height of viewport
                 *
                 * viewport
                 * ---------------------
                 * |    |         |    |
                 * |    | texture |    |
                 * |    |         |    |
                 * ---------------------
                 * */
                mViewportWidth = sPlaneScaleBaseValue * viewportRatio ;
                mViewportHeight = sPlaneScaleBaseValue;
                
                mTextureWidth = sPlaneScaleBaseValue * textureRatio;
                mTextureHeight = sPlaneScaleBaseValue;
            } else {
                /**
                 * fit width of viewport
                 *
                 * viewport
                 * -----------------------
                 * |---------------------|
                 * |                     |
                 * |       texture       |
                 * |                     |
                 * |---------------------|
                 * -----------------------
                 * */
                mViewportWidth = sPlaneScaleBaseValue;
                mViewportHeight = sPlaneScaleBaseValue / viewportRatio;
                
                mTextureWidth = sPlaneScaleBaseValue;
                mTextureHeight = sPlaneScaleBaseValue / textureRatio;
            }
            break;
    }
}


@end
