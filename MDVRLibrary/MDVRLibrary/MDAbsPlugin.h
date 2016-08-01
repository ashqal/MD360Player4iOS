//
//  MDAbsPlugin.h
//  MDVRLibrary
//
//  Created by ashqal on 16/7/31.
//  Copyright © 2016年 asha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDVRHeader.h"
#import "MDAbsPlugin.h"
#import "MD360Program.h"
#import "MD360Texture.h"
#import "MDProjectionStrategy.h"

@interface MDAbsPlugin : NSObject<IMDDestroyable>

- (void) setup:(EAGLContext*)context;

- (void) resizeWidth:(int)width height:(int)height;

- (void) renderer:(EAGLContext*)context index:(int)index width:(int)width height:(int)height;

@end

#pragma mark MDPluginManager
@interface MDPluginManager : NSObject

- (void) add:(MDAbsPlugin*) plugin;

- (NSArray*) getPlugins;

@end

#pragma mark MDPanoramaPlugin
@class MDPanoramaPlugin;

@interface MDPanoramaPluginBuilder : NSObject
- (void) setTexture:(MD360Texture*) texture;
- (void) setProgram:(MD360Program*) program;
- (void) setProjectionStrategyManager:(MDProjectionStrategyManager*) projectionStrategyManager;
- (MDPanoramaPlugin*) build;
@end

@interface MDPanoramaPlugin : MDAbsPlugin
+ (MDPanoramaPluginBuilder*) builder;
@end

