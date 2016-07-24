//
//  MD360Director.m
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/7.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "MD360Director.h"
#import "GLUtil.h"

@interface MD360Director(){
    GLKMatrix4 mModelMatrix;// = new float[16];
    GLKMatrix4 mViewMatrix;// = new float[16];
    GLKMatrix4 mProjectionMatrix;// = new float[16];
    
    GLKMatrix4 mMVMatrix;// = new float[16];
    GLKMatrix4 mMVPMatrix;// = new float[16];
    
    float mEyeZ;// = 0f;
    float mEyeX;// = 0f;
    float mAngleX;// = 0f;
    float mAngleY;
    float mLookX;// = 0f;
    float mRatio;// = 0f;
    float mNearScale;// = 0f;
    
    GLKMatrix4 mCurrentRotation;// = new float[16];
    GLKMatrix4 mAccumulatedRotation;// = new float[16];
    GLKMatrix4 mTemporaryMatrix;// = new float[16];
    GLKMatrix4 mSensorMatrix;// = new float[16];
    
    float mPreviousX;
    float mPreviousY;
    
    float mDeltaX;
    float mDeltaY;
}
@end

@implementation MD360Director

static float sNear = 0.7f;

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initValue];
    }
    return self;
}

- (void) initValue{
    mEyeZ = 0;
    mAngleX = 0;
    mAngleY = 0;
    mRatio = 1.5f;
    mNearScale = 1.0f;
    mEyeX = 0;
    mLookX = 0;
    mModelMatrix = mViewMatrix = mProjectionMatrix = mMVMatrix = mMVPMatrix = GLKMatrix4Identity;
    mCurrentRotation = mAccumulatedRotation = mTemporaryMatrix = mSensorMatrix = GLKMatrix4Identity;
}

- (void)destroy{

}

- (void) setup{
    [self initCamera];
    [self initModel];
}

- (void)initModel{
    mAccumulatedRotation = mSensorMatrix = GLKMatrix4Identity;
    // Model Matrix
    [self updateModelRotateAngleX:mAngleX angleY:mAngleY];
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

    mCurrentRotation = GLKMatrix4Rotate(mCurrentRotation, MD_DEGREES_TO_RADIANS(-mDeltaY + mAngleY), 1.0f, 0.0f, 0.0f);
    
    mCurrentRotation = GLKMatrix4Rotate(mCurrentRotation, MD_DEGREES_TO_RADIANS(-mDeltaX + mAngleX), 0.0f, 1.0f, 0.0f);
    
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
    [self updateProjection];
}

- (void) updateProjectionNearScale:(float)scale{
    mNearScale = scale;
    [self updateProjection];
}

- (void) updateModelRotateAngleX:(float)angleX angleY:(float)angleY {
    mAngleX = angleX;
    mAngleY = angleY;
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

- (void) updateProjection{
    float left = -mRatio/2;
    float right = mRatio/2;
    float bottom = -0.5f;
    float top = 0.5f;
    float far = 500;
    mProjectionMatrix = GLKMatrix4MakeFrustum(left, right, bottom, top, [self getNear], far);
}

- (void) updateSensorMatrix:(GLKMatrix4)sensor{
    mSensorMatrix = sensor;
}

- (void) updateTouch:(float)distX distY:(int)distY{
    mDeltaX += distX;
    mDeltaY += distY;
}

- (void) setProjection:(GLKMatrix4)project{
    mProjectionMatrix = project;
}

- (void) setLookX:(float)lookX{
    mLookX = lookX;
}

- (void) setEyeX:(float)eyeX{
    mEyeX  = eyeX;
}

- (void) setAngleX:(float)angleX{
    mAngleX = angleX;
}

- (void) setAngleY:(float)angleY{
    mAngleY = angleY;
}

- (float) getNear{
    return mNearScale * sNear;
}

- (float) getRatio{
    return mRatio;
}

@end

#pragma mark 
@implementation MD360DefaultDirectorFactory
- (MD360Director*) createDirector:(int) index{
    MD360Director* director = [[MD360Director alloc]init];
    switch (index) {
        case 1:
            [director setEyeX:-2.0f];
            [director setLookX:-2.0f];
            break;
        default:
            break;
    }
    [director setup];
    return director;
}
@end
