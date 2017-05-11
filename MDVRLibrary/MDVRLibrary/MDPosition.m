//
//  MDPosition.m
//  MDVRLibrary
//
//  Created by Asha on 2017/5/11.
//  Copyright © 2017年 asha. All rights reserved.
//

#import "MDPosition.h"

#pragma mark interface MDPosition
@interface MDPosition()
@end

#pragma mark interface MDOriginalPosition
@interface MDOriginalPosition : MDPosition
@end

#pragma mark MDPosition
@implementation MDPosition

static MDPosition* sOriginalPosition;
+(MDPosition*) getOriginalPosition
{
    if (sOriginalPosition == NULL) {
        sOriginalPosition = [[MDOriginalPosition alloc] init];
    }
    return sOriginalPosition;
}
@end

#pragma mark MDOriginalPosition
@implementation MDOriginalPosition
-(GLKMatrix4) getMatrix
{
    return GLKMatrix4Identity;
}

-(void) setRotationMatrix:(GLKMatrix4) mat
{
    // nop
}
@end

#pragma mark MDMutablePosition
@interface MDMutablePosition()
@property (nonatomic) float mX;
@property (nonatomic) float mY;
@property (nonatomic) float mZ;
@property (nonatomic) float mAngleX;
@property (nonatomic) float mAngleY;
@property (nonatomic) float mAngleZ;
@property (nonatomic) float mPitch;
@property (nonatomic) float mYaw;
@property (nonatomic) float mRoll;
@property (nonatomic) BOOL mChanged;
@property (nonatomic) GLKMatrix4 mMat;
@property (nonatomic) GLKMatrix4 mRotationMat;
@end

@implementation MDMutablePosition
-(float) getX { return self.mX;}
-(float) getY { return self.mY;}
-(float) getZ { return self.mZ;}
-(float) getAngleX { return self.mAngleX;}
-(float) getAngleY { return self.mAngleY;}
-(float) getAngleZ { return self.mAngleZ;}
-(float) getPitch { return self.mPitch;}
-(float) getYaw { return self.mYaw;}
-(float) getRoll { return self.mRoll;}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mMat = self.mRotationMat = GLKMatrix4Identity;
    }
    return self;
}

-(void) setX:(float)x
{
    self.mChanged |= self.mX != x;
    self.mX = x;
}

-(void) setY:(float)y
{
    self.mChanged |= self.mY != y;
    self.mY = y;
}

-(void) setZ:(float)z
{
    self.mChanged |= self.mZ != z;
    self.mZ = z;
}

-(void) setAngleX:(float)angleX
{
    self.mChanged |= self.mAngleX != angleX;
    self.mAngleX = angleX;
}

-(void) setAngleY:(float)angleY
{
    self.mChanged |= self.mAngleY != angleY;
    self.mAngleY = angleY;
}

-(void) setAngleZ:(float)angleZ
{
    self.mChanged |= self.mAngleZ != angleZ;
    self.mAngleZ = angleZ;
}

-(void) setPitch:(float)pitch
{
    self.mChanged |= self.mPitch != pitch;
    self.mPitch = pitch;
}

-(void) setYaw:(float)yaw
{
    self.mChanged |= self.mYaw != yaw;
    self.mYaw = yaw;
}

-(void) setRoll:(float)roll
{
    self.mChanged |= self.mRoll != roll;
    self.mRoll = roll;
}

-(void) ensure
{
    if (self.mChanged) {
        
        self.mMat = GLKMatrix4Identity;
        self.mMat = GLKMatrix4RotateX(self.mMat, GLKMathDegreesToRadians([self getAngleX]));
        self.mMat = GLKMatrix4RotateY(self.mMat, GLKMathDegreesToRadians([self getAngleY]));
        self.mMat = GLKMatrix4RotateZ(self.mMat, GLKMathDegreesToRadians([self getAngleZ]));
        
        self.mMat = GLKMatrix4Translate(self.mMat, [self getX], [self getY], [self getZ]);
        
        self.mMat = GLKMatrix4RotateX(self.mMat, GLKMathDegreesToRadians([self getYaw]));
        self.mMat = GLKMatrix4RotateY(self.mMat, GLKMathDegreesToRadians([self getPitch]));
        self.mMat = GLKMatrix4RotateZ(self.mMat, GLKMathDegreesToRadians([self getRoll]));
        
        self.mMat = GLKMatrix4Multiply(self.mRotationMat, self.mMat);
    }
    
    self.mChanged = NO;
}

-(GLKMatrix4) getMatrix
{
    [self ensure];
    return self.mMat;
}

-(void) setRotationMatrix:(GLKMatrix4) mat
{
    self.mRotationMat = mat;
    self.mChanged = YES;
}
@end
