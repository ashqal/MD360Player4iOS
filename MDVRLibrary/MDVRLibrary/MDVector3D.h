//
//  MDVector3D.h
//  MDVRLibrary
//
//  Created by Asha on 2017/5/11.
//  Copyright © 2017年 asha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface MDVector3D : NSObject
-(float) x;
-(float) y;
-(float) z;
-(void) setX:(float) x;
-(void) setY:(float) y;
-(void) setZ:(float) z;
-(void) multiplyMV:(GLKMatrix4) mat;
@end
