//
//  GLUtil.h
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/6.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDAbsObject3D.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <CoreMotion/CoreMotion.h>
#import <GLKit/GLKit.h>

#ifndef MD360_DEBUG
#define MD360_DEBUG true
#endif

#define MD_RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define MD_DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

/** see {@link #remapCoordinateSystem} */
static const int AXIS_X = 1;
/** see {@link #remapCoordinateSystem} */
static const int AXIS_Y = 2;
/** see {@link #remapCoordinateSystem} */
static const int AXIS_Z = 3;
/** see {@link #remapCoordinateSystem} */
static const int AXIS_MINUS_X = AXIS_X | 0x80;
/** see {@link #remapCoordinateSystem} */
static const int AXIS_MINUS_Y = AXIS_Y | 0x80;
/** see {@link #remapCoordinateSystem} */
static const int AXIS_MINUS_Z = AXIS_Z | 0x80;

//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)
@interface GLUtil : NSObject
+ (void) loadObject3DWithPath:(NSString*)path output:(MDAbsObject3D*)output;
+ (void) loadObject3DMock:(MDAbsObject3D*)output;
+ (NSString*) readRawText:(NSString*)path;
+ (BOOL)compileShader:(GLuint *)shader type:(GLenum)type source:(NSString *)source;
+ (GLuint)createAndLinkProgramWith:(GLuint)vsHandle fsHandle:(GLuint)fsHandle attrs:(NSArray*)attrs;
+ (void)texImage2D:(UIImage*)image;
+ (void)texImage2DWithPath:(NSString*)path;
+ (void) glCheck:(NSString*) msg;
+ (GLKMatrix4) calculateMatrixFromQuaternion:(CMQuaternion*)quaternion orientation:(UIInterfaceOrientation) orientation;
+ (float) getScrrenScale;
// + (GLKMatrix4) getRotationMatrixFromQuaternion:(CMQuaternion*)quaternion;
// + (GLKMatrix4) remapCoordinateSystem:(float*)inR X:(int)X Y:(int)Y;
@end
