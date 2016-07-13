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
#import "MDVRHeader.h"
#import "MDDisplayStrategy.h"
#import "MDProjectionStrategy.h"

@class MD360Renderer;
@interface MD360RendererBuilder : NSObject
- (void) setTexture:(MD360Texture*) texture;
- (void) setProgram:(MD360Program*) program;
- (void) setDisplayStrategyManager:(MDDisplayStrategyManager*) displayStrategyManager;
- (void) setProjectionStrategyManager:(MDProjectionStrategyManager*) projectionStrategyManager;
- (MD360Renderer*) build;
@end

@interface MD360Renderer : NSObject <MDGLRendererDelegate>
+ (MD360RendererBuilder*) builder;
@end


