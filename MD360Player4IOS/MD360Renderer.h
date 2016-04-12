//
//  MD360Renderer.h
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/7.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDGLRendererDelegate.h"
#import "MD360Director.h"
#import "MD360Texture.h"
#import "MDVRLibrary.h"

@class MD360Renderer;
@interface MD360RendererBuilder : NSObject
- (void) setDirector:(MD360Director*) director;
- (void) setTexture:(MD360Texture*) texture;
- (MD360Renderer*) build;
@end

@interface MD360Renderer : NSObject <MDGLRendererDelegate,IMDDestroyable>
+ (MD360RendererBuilder*) builder;
@end


