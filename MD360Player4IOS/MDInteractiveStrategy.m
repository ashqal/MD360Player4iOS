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
@interface MDTouchStrategy:MDInteractiveStrategy<MDTouchDelegate>
@property (nonatomic,strong) NSMutableArray* currentTouches;
@end

static float sMDDamping = 0.2f;

@implementation MDTouchStrategy
- (instancetype)initWithDirectorList:(NSArray*) dirctors{
    self = [super initWithDirectorList:dirctors];
    if (self) {
        self.currentTouches = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)dealloc{
    self.currentTouches = nil;
}

-(void) on{
    for (MD360Director* director in self.dirctors) {
        director.touchDelegate = self;
    }
}

-(void) off{
    for (MD360Director* director in self.dirctors) {
        director.touchDelegate = nil;
    }
}

#pragma mark touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self.currentTouches addObject:touch];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    float distX = [touch locationInView:touch.view].x - [touch previousLocationInView:touch.view].x;
    float distY = [touch locationInView:touch.view].y - [touch previousLocationInView:touch.view].y;
    distX *= sMDDamping;
    distY *= sMDDamping;
    // mDeltaX += distX;
    // mDeltaY += distY;
    for (MD360Director* director in self.dirctors) {
        [director updateTouch:distX distY:distY];
    }
   
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self.currentTouches removeObject:touch];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self.currentTouches removeObject:touch];
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
