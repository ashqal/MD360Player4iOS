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
#import "MDVRHeader.h"

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


@interface MDProjectionStrategyManager()
@property (nonatomic,strong) NSMutableArray* directors;

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

- (void) on{
    [super on];
    
    [self.directors removeAllObjects];
    id<MD360DirectorFactory> factory = self.directorFactory;
    id<MD360DirectorFactory> hijack = [self.mStrategy hijackDirectorFactory];
    factory = hijack != nil ? hijack : factory;

    for (int i = 0; i < MULTI_SCREEN_SIZE; i++) {
        if ([factory respondsToSelector:@selector(createDirector:)]) {
            MD360Director* director = [factory createDirector:i];
            [self.directors addObject:director];
        }
    }
}

- (MDAbsObject3D*) getObject3D{
    return [self.mStrategy getObject3D];
}

- (NSArray*) getDirectors{
    return self.directors;
}

@end
