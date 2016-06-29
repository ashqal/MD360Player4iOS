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
@interface AbsInteractiveStrategy: NSObject<IMDModeStrategy,IMDInteractiveMode>
@property(nonatomic,weak) MDProjectionStrategyManager* projectionStrategyManager;
- (instancetype)initWithProjectionManager:(MDProjectionStrategyManager*) projectionStrategyManager;
@end

@implementation AbsInteractiveStrategy
- (instancetype)initWithProjectionManager:(MDProjectionStrategyManager*) projectionStrategyManager{
    self = [super init];
    if (self) {
        self.projectionStrategyManager = projectionStrategyManager;
    }
    return self;
}

- (void)dealloc{
    self.projectionStrategyManager = nil;
}
@end

#pragma mark MDTouchStrategy
@interface MDTouchStrategy:AbsInteractiveStrategy
@end

@implementation MDTouchStrategy

-(void) handleDragDistX:(float)distX distY:(float)distY{
    if ([self.projectionStrategyManager respondsToSelector:@selector(getDirectors)]) {
        NSArray* directors = [self.projectionStrategyManager getDirectors];
        for (MD360Director* director in directors) {
            [director updateTouch:distX distY:distY];
        }
    }
    
}

@end


#pragma mark MDMotionStrategy
@interface MDMotionStrategy:AbsInteractiveStrategy
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
        if ([self.projectionStrategyManager respondsToSelector:@selector(getDirectors)]) {
            NSArray* directors = [self.projectionStrategyManager getDirectors];
            for (MD360Director* director in directors) {
                [director updateSensorMatrix:sensor];
            }
        }
    }];
}

- (void)stopDeviceMotion {
    [self.motionManager stopDeviceMotionUpdates];
    self.motionManager = nil;
}

@end

#pragma mark MDTouchStrategy
@interface MDMotionWithTouchStrategy:MDMotionStrategy
@end

@implementation MDMotionWithTouchStrategy

-(void) handleDragDistX:(float)distX distY:(float)distY{
    if ([self.projectionStrategyManager respondsToSelector:@selector(getDirectors)]) {
        NSArray* directors = [self.projectionStrategyManager getDirectors];
        for (MD360Director* director in directors) {
            [director updateTouch:distX distY:distY];
        }
    }
}

@end

#pragma mark MDInteractiveStrategyManager
@interface MDInteractiveStrategyManager()

@end

@implementation MDInteractiveStrategyManager

- (void) switchMode:(int)mode{
    int prev = self.mMode;
    [super switchMode:mode];
    if (prev != mode) {
        if([self.projectionStrategyManager respondsToSelector:@selector(getDirectors)]){
            NSArray* directors = [self.projectionStrategyManager getDirectors];
            for (MD360Director* director in directors) {
                [director reset];
            }
        }
    }
}

-(void) handleDragDistX:(float)distX distY:(float)distY{
    if ([self.mStrategy respondsToSelector:@selector(handleDragDistX:distY:)]) {
        [self.mStrategy handleDragDistX:distX distY:distY];
    }
}

- (id) createStrategy:(int)mode{
    switch (mode) {
        case MDModeInteractiveMotion:
            return [[MDMotionStrategy alloc] initWithProjectionManager:self.projectionStrategyManager];
        case MDModeInteractiveMotionWithTouch:
            return [[MDMotionWithTouchStrategy alloc] initWithProjectionManager:self.projectionStrategyManager];
        case MDModeInteractiveTouch:
        default:
            return [[MDTouchStrategy alloc] initWithProjectionManager:self.projectionStrategyManager];
    }
    return nil;
}

- (NSArray*) createModes{
    return [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:MDModeInteractiveTouch], [NSNumber numberWithInt:MDModeInteractiveMotion], [NSNumber numberWithInt:MDModeInteractiveMotionWithTouch], nil];
}

@end
