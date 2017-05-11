//
//  MDVector3D.m
//  MDVRLibrary
//
//  Created by Asha on 2017/5/11.
//  Copyright © 2017年 asha. All rights reserved.
//

#import "MDVector3D.h"

@interface MDVector3D()
{
    GLKVector3 mVector3;
}
@end

@implementation MDVector3D
- (instancetype)init
{
    self = [super init];
    if (self) {
        mVector3.x = 0;
        mVector3.y = 0;
        mVector3.z = 0;
    }
    return self;
}

-(float) x
{
    return mVector3.x;
}

-(float) y
{
    return mVector3.y;
}

-(float) z
{
    return mVector3.z;
}

-(void) setX:(float) x
{
    mVector3.x = x;
}

-(void) setY:(float) y
{
    mVector3.y = y;
}

-(void) setZ:(float) z
{
    mVector3.z = z;
}

-(void) multiplyMV:(GLKMatrix4) mat
{
    mVector3 = GLKMatrix4MultiplyVector3(mat, mVector3);
}
@end
