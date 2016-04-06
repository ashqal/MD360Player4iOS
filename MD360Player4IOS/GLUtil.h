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

#ifndef MD360_DEBUG
#define MD360_DEBUG true
#endif

//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)
@interface GLUtil : NSObject
+ (void) loadObject3DWithPath:(NSString*)path output:(MDAbsObject3D*)output;
+ (NSString*) readRawText:(NSString*)path;
+ (BOOL)compileShader:(GLuint *)shader type:(GLenum)type source:(NSString *)source;
+ (GLuint)createAndLinkProgramWith:(GLuint)vsHandle fsHandle:(GLuint)fsHandle attrs:(NSArray*)attrs;
@end
