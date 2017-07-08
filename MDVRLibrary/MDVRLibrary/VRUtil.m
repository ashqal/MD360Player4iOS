//
//  VRUtil.m
//  MDVRLibrary
//
//  Created by Asha on 2017/7/8.
//  Copyright © 2017年 asha. All rights reserved.
//

#import "VRUtil.h"
#import <math.h>

@implementation VRUtil
+(void) barrelDistortionA:(double) paramA b:(double) paramB c:(double) paramC src:(float*) src {
    double paramD = 1.0 - paramA - paramB - paramC; // describes the linear scaling of the image

    float d = 1.0f;
    
    // center of dst image
    double centerX = 0.0f;
    double centerY = 0.0f;
    
    float x = src[0];
    float y = src[1];
    
    if (x == centerX && y == centerY){
        return;
    }
    
    // cartesian coordinates of the destination point (relative to the centre of the image)
    double deltaX = (x - centerX) / d;
    double deltaY = (y - centerY) / d;
    
    // distance or radius of dst image
    double dstR = sqrt(deltaX * deltaX + deltaY * deltaY);
    
    // distance or radius of src image (with formula)
    double srcR = (paramA * dstR * dstR * dstR + paramB * dstR * dstR + paramC * dstR + paramD) * dstR;
    
    // comparing old and new distance to get factor
    double factor = fabs(dstR / srcR);
    
    // coordinates in source image
    float xResult = (float) (centerX + (deltaX * factor * d));
    float yResult = (float) (centerY + (deltaY * factor * d));
    
    src[0] = xResult;
    src[1] = yResult;
}
@end
