//
//  MDPosition.h
//  MDVRLibrary
//
//  Created by Asha on 2017/5/11.
//  Copyright © 2017年 asha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#pragma mark MDPosition
@interface MDPosition : NSObject

-(GLKMatrix4) getMatrix;
-(void) setRotationMatrix:(GLKMatrix4) mat;
+(MDPosition*) getOriginalPosition;
@end

#pragma mark MDMutablePosition
@interface MDMutablePosition : MDPosition

-(void) setX:(float)x;
-(void) setY:(float)y;
-(void) setZ:(float)z;
-(void) setAngleX:(float)angleX;
-(void) setAngleY:(float)angleY;
-(void) setAngleZ:(float)angleZ;
-(void) setPitch:(float)pitch;
-(void) setYaw:(float)yaw;
-(void) setRoll:(float)roll;

-(float) getX;
-(float) getY;
-(float) getZ;
-(float) getAngleX;
-(float) getAngleY;
-(float) getAngleZ;
-(float) getPitch;
-(float) getYaw;
-(float) getRoll;

@end
