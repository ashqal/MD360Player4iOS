//
//  MDInteractiveStrategy.m
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/11.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "MDInteractiveStrategy.h"
#include "MDVRLibrary.h"
#import <CoreMotion/CoreMotion.h>
#import <math.h>
#import <GLKit/GLKit.h>
#import "GLUtil.h"
#import "MD360Director.h"
#import "MDTouchHelper.h"

#pragma mark MDInteractiveStrategy
@interface MDInteractiveStrategy: NSObject<IMDModeStrategy>
@property(nonatomic,strong) NSArray* dirctors;
- (instancetype)initWithDirectorList:(NSArray*) dirctors;
@end

@implementation MDInteractiveStrategy
- (instancetype)initWithDirectorList:(NSArray*) dirctors{
    self = [super init];
    if (self) {
        self.dirctors = dirctors;
    }
    return self;
}

- (void)dealloc{
    self.dirctors = nil;
}
@end

#pragma mark MDTouchStrategy
@interface MDTouchStrategy:MDInteractiveStrategy
@end

@implementation MDTouchStrategy
- (instancetype)initWithDirectorList:(NSArray*) dirctors{
    self = [super initWithDirectorList:dirctors];
    if (self) {
        // nop
    }
    return self;
}

-(void) on{
    
}

-(void) off{
    
}

-(void) handleDragDistX:(float)distX distY:(float)distY{
    for (MD360Director* director in self.dirctors) {
        [director updateTouch:distX distY:distY];
    }
}

@end


#pragma mark MDMotionStrategy
@interface MDMotionStrategy:MDInteractiveStrategy
@property (nonatomic,strong) CMMotionManager* motionManager;
@end

@implementation MDMotionStrategy

-(void) on{
    [self startDeviceMotion];
}

-(void) off{
    [self stopDeviceMotion];
}

#pragma mark motion

- (void)startDeviceMotion {
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.deviceMotionUpdateInterval = 1.0 / 30.0;
    self.motionManager.gyroUpdateInterval = 1.0f / 30;
    self.motionManager.showsDeviceMovementDisplay = YES;
    NSOperationQueue* motionQueue = [[NSOperationQueue alloc] init];
    [self.motionManager setDeviceMotionUpdateInterval:1.0f / 30];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self.motionManager startDeviceMotionUpdatesToQueue:motionQueue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
        
        CMAttitude* attitude = motion.attitude;
        if (attitude == nil) return;
        
        GLKMatrix4 sensor = GLKMatrix4Identity;
        CMQuaternion quaternion = attitude.quaternion;
        sensor = [GLUtil calculateMatrixFromQuaternion:&quaternion orientation:orientation];
        
        sensor = GLKMatrix4RotateX(sensor, M_PI_2);
        for (MD360Director* director in self.dirctors) {
            [director updateSensorMatrix:sensor];
        }
    }];
}

- (void)stopDeviceMotion {
    [self.motionManager stopDeviceMotionUpdates];
    self.motionManager = nil;
}

@end

#pragma mark MDInteractiveStrategyManager
@interface MDInteractiveStrategyManager()

@end
@implementation MDInteractiveStrategyManager

- (void) switchMode{
    int newMode = self.mMode == MDModeInteractiveMotion ? MDModeInteractiveTouch : MDModeInteractiveMotion;
    [self switchMode:newMode];
}

- (void) switchMode:(int)mode{
    int prev = self.mMode;
    [super switchMode:mode];
    if (prev != mode) {
        for (MD360Director* dirctor in self.dirctors) {
            [dirctor reset];
        }
    }
}

-(void) handleDragDistX:(float)distX distY:(float)distY{
    if ([self.mStrategy respondsToSelector:@selector(handleDragDistX:distY:)]) {
        [self.mStrategy handleDragDistX:distX distY:distY];
    }
}

- (id<IMDModeStrategy>) createStrategy:(int)mode{
    switch (mode) {
        case MDModeInteractiveMotion:
            return [[MDMotionStrategy alloc] initWithDirectorList:self.dirctors];
        case MDModeInteractiveTouch:
        default:
            return [[MDTouchStrategy alloc] initWithDirectorList:self.dirctors];
    }
    return nil;
}

@end
