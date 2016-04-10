//
//  MD360Director.m
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/7.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "MD360Director.h"
#import "GLUtil.h"
#import <CoreMotion/CoreMotion.h>
#import <math.h>

@interface MD360Director(){
    GLKMatrix4 mModelMatrix;// = new float[16];
    GLKMatrix4 mViewMatrix;// = new float[16];
    GLKMatrix4 mProjectionMatrix;// = new float[16];
    
    GLKMatrix4 mMVMatrix;// = new float[16];
    GLKMatrix4 mMVPMatrix;// = new float[16];
    
    float mEyeZ;// = 0f;
    float mEyeX;// = 0f;
    float mAngle;// = 0f;
    float mRatio;// = 0f;
    float mNear;// = 0f;
    float mLookX;// = 0f;
    
    GLKMatrix4 mCurrentRotation;// = new float[16];
    GLKMatrix4 mAccumulatedRotation;// = new float[16];
    GLKMatrix4 mTemporaryMatrix;// = new float[16];
    GLKMatrix4 mSensorMatrix;// = new float[16];
    
    float mPreviousX;
    float mPreviousY;
    
    float mDeltaX;
    float mDeltaY;
}
@property (nonatomic,strong) NSMutableArray* currentTouches;
@property (nonatomic,strong) CMMotionManager* motionManager;
@property (nonatomic,strong) CMAttitude* prevMotionAttitude;
@end

static float sDamping = 0.2f;

@implementation MD360Director

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup{
    self.currentTouches = [[NSMutableArray alloc]init];
    mEyeZ = 0;
    mAngle = 0;
    mRatio = 1.5f;
    mNear = 0.7f;
    mEyeX = 0;
    mLookX = 0;
    mModelMatrix = mViewMatrix = mProjectionMatrix = mMVMatrix = mMVPMatrix = GLKMatrix4Identity;
    mCurrentRotation = mAccumulatedRotation = mTemporaryMatrix = mSensorMatrix = GLKMatrix4Identity;
    
    [self initCamera];
    [self initModel];
    
    [self startDeviceMotion];
}

- (void)initModel{
    mAccumulatedRotation = mSensorMatrix = GLKMatrix4Identity;
    // Model Matrix
    [self updateModelRotate:mAngle];
}

- (void)initCamera{
    [self updateViewMatrix];
}
// static GLfloat  rot = 0.0f;
- (void) shot:(MD360Program*) program{
    
    /*
    rot += 2.0f;
    if (rot > 360.f)
        rot -= 360.f;
    
    [self updateModelRotate:rot];
     */
    
    
    mModelMatrix = GLKMatrix4Identity;
    
    mCurrentRotation = GLKMatrix4Identity;

    mCurrentRotation = GLKMatrix4Rotate(mCurrentRotation, MD_DEGREES_TO_RADIANS(-mDeltaY), 1.0f, 0.0f, 0.0f);
    
    mCurrentRotation = GLKMatrix4Rotate(mCurrentRotation, MD_DEGREES_TO_RADIANS(-mDeltaX + mAngle), 0.0f, 1.0f, 0.0f);
    
    mCurrentRotation = GLKMatrix4Multiply(mSensorMatrix, mCurrentRotation);
    
    // set the accumulated rotation to the result.
    mAccumulatedRotation = mCurrentRotation;
    
    // Rotate the cube taking the overall rotation into account.
    mTemporaryMatrix = GLKMatrix4Multiply(mModelMatrix, mAccumulatedRotation);
    
    mModelMatrix = mTemporaryMatrix;
    
    // This multiplies the view matrix by the model matrix, and stores the result in the MVP matrix
    // (which currently contains model * view).
    mMVMatrix = GLKMatrix4Multiply(mViewMatrix, mModelMatrix);
    
    // This multiplies the model view matrix by the projection matrix, and stores the result in the MVP matrix
    // (which now contains model * view * projection).
    mMVPMatrix = GLKMatrix4Multiply(mProjectionMatrix, mMVMatrix);
    
    // Pass in the model view matrix
    glUniformMatrix4fv(program.mMVMatrixHandle, 1, GL_FALSE, mMVMatrix.m);
    
    // Pass in the combined matrix.
    glUniformMatrix4fv(program.mMVPMatrixHandle, 1, GL_FALSE, mMVPMatrix.m);
}

- (void) reset{
    mDeltaX = mDeltaY = mPreviousX = mPreviousY = 0;
    mSensorMatrix = GLKMatrix4Identity;
}

- (void) updateProjection:(int)width height:(int)height{
    mRatio = width * 1.0f / height;
    [self updateProjectionNear:mNear];
}

- (void) updateProjectionNear:(float)near{
    mNear = near;
    float left = -mRatio/2;
    float right = mRatio/2;
    float bottom = -0.5f;
    float top = 0.5f;
    float far = 500;
    mProjectionMatrix = GLKMatrix4MakeFrustum(left, right, bottom, top, mNear, far);
}

- (void) updateModelRotate:(float)angle{
    mAngle = angle;
}

- (void) updateViewMatrix{
    float eyeX = mEyeX;
    float eyeY = 0.0f;
    float eyeZ = mEyeZ;
    float lookX = mLookX;
    float lookY = 0.0f;
    float lookZ = -1.0f;
    float upX = 0.0f;
    float upY = 1.0f;
    float upZ = 0.0f;
    
    mViewMatrix = GLKMatrix4MakeLookAt(eyeX, eyeY, eyeZ, lookX, lookY, lookZ, upX, upY, upZ);
}

- (void) updateSensorMatrix:(GLKMatrix4)sensor{
    mSensorMatrix = sensor;
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
    distX *= sDamping;
    distY *= sDamping;
    mDeltaX += distX;
    mDeltaY += distY;
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

#pragma mark motion

- (void)startDeviceMotion {
    self.prevMotionAttitude = nil;
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
        sensor = [GLUtil getRotationMatrixFromQuaternion:&quaternion];
        switch (orientation) {
            case UIDeviceOrientationLandscapeRight:
                sensor = [GLUtil remapCoordinateSystem:sensor.m X:AXIS_MINUS_Y Y:AXIS_X];
                break;
            case UIDeviceOrientationLandscapeLeft:
                sensor = [GLUtil remapCoordinateSystem:sensor.m X:AXIS_Y Y:AXIS_MINUS_X];
                break;
            case UIDeviceOrientationUnknown:
            case UIDeviceOrientationPortrait:
            case UIDeviceOrientationPortraitUpsideDown://not support now
            default:
                break;
        }
        sensor = GLKMatrix4RotateX(sensor, M_PI_2);
        
        [self updateSensorMatrix:sensor];

    }];    
}

- (void)stopDeviceMotion {
    
    [self.motionManager stopDeviceMotionUpdates];
    self.motionManager = nil;
}


@end
