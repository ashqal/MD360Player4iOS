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

@class MD360Renderer;
@interface MD360RendererBuilder : NSObject
- (void) setDirectors:(NSArray*) directors;
- (void) setTexture:(MD360Texture*) texture;
- (void) setObject3D:(MDAbsObject3D*) object3D;
- (void) setDisplayStrategyManager:(MDDisplayStrategyManager*) displayStrategyManager;
- (MD360Renderer*) build;
@end

@interface MD360Renderer : NSObject <MDGLRendererDelegate>
+ (MD360RendererBuilder*) builder;
@end


