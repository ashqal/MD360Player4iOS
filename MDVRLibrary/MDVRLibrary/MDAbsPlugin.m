//
//  MDAbsPlugin.m
//  MDVRLibrary
//
//  Created by ashqal on 16/7/31.
//  Copyright © 2016年 asha. All rights reserved.
//

#import "MDAbsPlugin.h"

@implementation MDAbsPlugin
- (void) setup:(EAGLContext *)context {}
- (void) destroy{}
- (void) resizeWidth:(int)width height:(int)height {}
- (void) beforeRenderer:(EAGLContext*)context totalW:(float) totalW totalH:(float)totalH {}
- (void) renderer:(EAGLContext*)context index:(int)index width:(int)width height:(int)height {}
@end
