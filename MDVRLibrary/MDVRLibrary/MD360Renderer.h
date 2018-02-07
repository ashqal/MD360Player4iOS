//
//  MD360Renderer.h
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/7.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDGLRendererDelegate.h"
#import "MDVRHeader.h"
#import "MDDisplayStrategy.h"
#import "MDProjectionStrategy.h"
#import "MDAbsPlugin.h"
#import "IMDTextureProcessor.h"

@class MD360Renderer;
@interface MD360RendererBuilder : NSObject
- (void) setDisplayStrategyManager:(MDDisplayStrategyManager*) displayStrategyManager;
- (void) setProjectionStrategyManager:(MDProjectionStrategyManager*) projectionStrategyManager;
- (void) setPluginManager:(MDPluginManager*) pluginManager;
- (void) setTextureProcessor:(id<IMDTextureProcessor>) textureProcessor;
- (MD360Renderer*) build;
@end

@interface MD360Renderer : NSObject <MDGLRendererDelegate>
+ (MD360RendererBuilder*) builder;
@end


