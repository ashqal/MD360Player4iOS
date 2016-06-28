//
//  MDProjectionStrategy.m
//  MDVRLibrary
//
//  Created by ashqal on 16/6/28.
//  Copyright © 2016年 asha. All rights reserved.
//

#import "MDProjectionStrategy.h"
#import "MD360Director.h"
#import "MDVRLibrary.h"

#pragma mark AbsProjectionMode
@interface AbsProjectionMode : NSObject<IMDModeStrategy,IMDProjectionMode>

@end

@implementation AbsProjectionMode

- (MDAbsObject3D*) getObject3D{
    return nil;
}

- (id<MD360DirectorFactory>) hijackDirectorFactory{
    return nil;
}

@end

#pragma mark SphereProjection
@interface SphereProjection : AbsProjectionMode
@property (nonatomic,strong) MDAbsObject3D* object3D;
@end

@implementation SphereProjection



@end



#pragma mark MDProjectionStrategyManager
@implementation MDProjectionStrategyManager

- (id) createStrategy:(int)mode{
    switch (mode) {
        case MDModeProjectionDome180:
        case MDModeProjectionDome230:
        case MDModeProjectionDome180Upper:
        case MDModeProjectionDome230Upper:
        case MDModeProjectionStereoSphere:
        case MDModeProjectionPlantFit:
        case MDModeProjectionPlantCrop:
        case MDModeProjectionPlantFull:
        case MDModeProjectionSphere: default:
            return [[SphereProjection alloc] init];
    }
    return nil;
}

- (MDAbsObject3D*) getObject3D{
    return [self.mStrategy getObject3D];
}

@end
