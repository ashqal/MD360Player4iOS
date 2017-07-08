//
//  VRUtil.h
//  MDVRLibrary
//
//  Created by Asha on 2017/7/8.
//  Copyright © 2017年 asha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VRUtil : NSObject
+(void) barrelDistortionA:(double) paramA b:(double) paramB c:(double) paramC src:(float*) src;
@end
