//
//  MD360Director.h
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/7.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MD360Program.h"
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "MDVRLibrary.h"

#pragma mark MD360Director
@interface MD360Director : NSObject<IMDDestroyable>
- (void) shot:(MD360Program*) program;
- (void) reset;
- (void) updateProjection:(int)width height:(int)height;
- (void) updateSensorMatrix:(GLKMatrix4)sensor;
- (void) updateTouch:(float)distX distY:(int)distY;
@end

#pragma mark MD360Director
@interface MD360DirectorFactory : NSObject
+ (MD360Director*) create:(int) index;
@end

