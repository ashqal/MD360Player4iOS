//
//  MDProjectionStrategy.m
//  MDVRLibrary
//
//  Created by ashqal on 16/6/28.
//  Copyright © 2016年 asha. All rights reserved.
//

#import "MDProjectionStrategy.h"

@implementation MDProjectionStrategyManager

- (id) createStrategy:(int)mode{
    switch (mode) {
            /*
        case MDModeInteractiveMotion:
            return [[MDMotionStrategy alloc] initWithDirectorList:self.dirctors];
        case MDModeInteractiveMotionWithTouch:
            return [[MDMotionWithTouchStrategy alloc] initWithDirectorList:self.dirctors];
        case MDModeInteractiveTouch:
        default:
            return [[MDTouchStrategy alloc] initWithDirectorList:self.dirctors];
             */
    }
    return nil;
}

- (MDAbsObject3D*) getObject3D{
    return [self.mStrategy getObject3D];
}

@end
