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

- (void) on{
    self.object3D = [[MDSphere3D alloc]init];
    [self.object3D loadObj];
}

- (MDAbsObject3D*) getObject3D{
    return self.object3D;
}

@end

#pragma mark MDProjectionStrategyConfiguration
@implementation MDProjectionStrategyConfiguration

@end

@interface MDProjectionStrategyManager()
@property (nonatomic,strong) NSMutableArray* directors;
@property (nonatomic,strong) MDProjectionStrategyConfiguration* configuration;
@end

#pragma mark MDProjectionStrategyManager
@implementation MDProjectionStrategyManager

- (instancetype)initWithDefault:(int)mode config:(MDProjectionStrategyConfiguration*)config{
    self = [super init];
    if (self) {
        self.directors = [[NSMutableArray alloc] init];
        self.configuration = config;
    }
    return self;
}

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
    id<MD360DirectorFactory> factory = self.configuration.directorFactory;
    id<MD360DirectorFactory> hijack = [self.mStrategy hijackDirectorFactory];
    factory = hijack != nil ? hijack : factory;

    for (int i = 0; i < MULTI_SCREEN_SIZE; i++) {
        if ([factory respondsToSelector:@selector(createDirector:)]) {
            MD360Director* director = [factory createDirector:i];
            [self.directors addObject:director];
        }
    }
}

- (NSArray*) createModes{
    return [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:MDModeProjectionSphere], [NSNumber numberWithInt:MDModeProjectionDome180],[NSNumber numberWithInt:MDModeProjectionDome230], [NSNumber numberWithInt:MDModeProjectionDome180Upper],[NSNumber numberWithInt:MDModeProjectionDome230Upper],[NSNumber numberWithInt:MDModeProjectionStereoSphere],[NSNumber numberWithInt:MDModeProjectionPlantFit],[NSNumber numberWithInt:MDModeProjectionPlantCrop],[NSNumber numberWithInt:MDModeProjectionPlantFull],nil];
}

- (MDAbsObject3D*) getObject3D{
    return [self.mStrategy getObject3D];
}

- (NSArray*) getDirectors{
    return self.directors;
}



@end
