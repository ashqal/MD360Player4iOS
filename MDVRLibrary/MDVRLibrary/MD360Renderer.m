//
//  MD360Renderer.m
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/7.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "MD360Renderer.h"
#import "MDAbsObject3D.h"
#import "MD360Program.h"
#import "GLUtil.h"
#import "MD360Director.h"
#import "MDAbsPlugin.h"

@interface MD360Renderer()
@property (nonatomic,weak) MDDisplayStrategyManager* mDisplayStrategyManager;
@property (nonatomic,weak) MDProjectionStrategyManager* mProjectionStrategyManager;
@property (nonatomic,weak) MDPluginManager* mPluginManager;
@end

@implementation MD360Renderer

+ (MD360RendererBuilder*) builder{
    return [[MD360RendererBuilder alloc]init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)dealloc{
    
}

- (void) setup{
    // nop
}

- (void) rendererOnCreated:(EAGLContext*)context{
    
    NSArray* plugins = [self.mPluginManager getPlugins];
    for (MDAbsPlugin* plugin in plugins) {
        [plugin setup:context];
    }
    
    [GLUtil glCheck:@"rendererOnCreated"];
}

- (void) rendererOnChanged:(EAGLContext*)context width:(int)width height:(int)height{
    NSArray* plugins = [self.mPluginManager getPlugins];
    for (MDAbsPlugin* plugin in plugins) {
        [plugin resizeWidth:width height:height];
    }
    
    [GLUtil glCheck:@"rendererOnChanged"];
}

- (void) rendererOnDrawFrame:(EAGLContext*)context width:(int)width height:(int)height{
    // clear
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [GLUtil glCheck:@"glClear"];
        
    // draw
    float scale = [GLUtil getScrrenScale];
    int widthPx = width * scale;
    int heightPx = height * scale;
    
    int size = [self.mDisplayStrategyManager getVisibleSize];
    int itemWidthPx = widthPx * 1.0 / size;
    
    NSArray* plugins = [self.mPluginManager getPlugins];
    for (MDAbsPlugin* plugin in plugins) {
        [plugin beforeRenderer:context totalW:widthPx totalH:heightPx];
    }
    
    for (int i = 0; i < size; i++ ) {
        glViewport(itemWidthPx * i, 0, itemWidthPx, heightPx);
        glEnable(GL_SCISSOR_TEST);
        glScissor(itemWidthPx * i, 0, itemWidthPx, heightPx);
        
        for (MDAbsPlugin* plugin in plugins) {
            [plugin renderer:context index:i width:itemWidthPx height:heightPx];
        }
        
        glDisable(GL_SCISSOR_TEST);
    }
}

- (void) rendererOnDestroy:(EAGLContext*) context{
    NSArray* plugins = [self.mPluginManager getPlugins];
    for (MDAbsPlugin* plugin in plugins) {
        [plugin destroy];
    }
}

@end

@interface MD360RendererBuilder()
@property (nonatomic,weak) MDPluginManager* pluginManager;
@property (nonatomic,weak) MDDisplayStrategyManager* displayStrategyManager;
@property (nonatomic,weak) MDProjectionStrategyManager* projectionStrategyManager;
@end

@implementation MD360RendererBuilder

- (void) setDisplayStrategyManager:(MDDisplayStrategyManager*) displayStrategyManager{
    _displayStrategyManager = displayStrategyManager;
}

- (void) setProjectionStrategyManager:(MDProjectionStrategyManager*) projectionStrategyManager{
    _projectionStrategyManager = projectionStrategyManager;
}

- (void) setPluginManager:(MDPluginManager*) pluginManager{
    _pluginManager = pluginManager;
}

- (MD360Renderer*) build{
    MD360Renderer* renderer = [[MD360Renderer alloc]init];
    renderer.mPluginManager = self.pluginManager;
    renderer.mProjectionStrategyManager = self.projectionStrategyManager;
    renderer.mDisplayStrategyManager = self.displayStrategyManager;
    return renderer;
}

@end
