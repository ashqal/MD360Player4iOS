//
//  MDPanoramaPlugin.m
//  MDVRLibrary
//
//  Created by ashqal on 16/7/31.
//  Copyright © 2016年 asha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDAbsPlugin.h"
#import "MD360Program.h"
#import "MD360Texture.h"
#import "MDProjectionStrategy.h"

@interface MDPanoramaPlugin(){

}
@property (nonatomic,strong) MD360Program* mProgram;
@property (nonatomic,strong) MD360Texture* mTexture;
@property (nonatomic,weak) MDProjectionStrategyManager* mProjectionStrategyManager;

@end

@implementation MDPanoramaPlugin

+ (MDPanoramaPluginBuilder*) builder{
    return [[MDPanoramaPluginBuilder alloc]init];
}

- (void) setup:(EAGLContext*)context{
    [self.mProgram build];
    [self.mTexture createTexture:context program:self.mProgram];
}

- (void) resizeWidth:(int)width height:(int)height{
    [self.mTexture resizeViewport:width height:height];
}

- (void) renderer:(EAGLContext*)context index:(int)index width:(int)width height:(int)height{
    // get directors
    NSArray* directors = nil;
    if ([self.mProjectionStrategyManager respondsToSelector:@selector(getDirectors)]) {
        directors = [self.mProjectionStrategyManager getDirectors];
    }
    
    if (directors == nil){
        return;
    }
    
    if (index >= [directors count]) {
        return;
    }
    
    // get object3D
    MDAbsObject3D* object3D = nil;
    if ([self.mProjectionStrategyManager respondsToSelector:@selector(getObject3D)]) {
        object3D = [self.mProjectionStrategyManager getObject3D];
    }
    if (object3D == nil) return;

    MD360Director* direcotr = [directors objectAtIndex:index];
    
    // Update Projection
    [direcotr updateProjection:width height:height];
    
    // use
    [self.mProgram use];
    [GLUtil glCheck:@"mProgram use"];
    
    // update texture
    [self.mTexture updateTexture:context];

    // upload
    [object3D uploadVerticesBufferIfNeed:self.mProgram index:index];
    [object3D uploadTexCoordinateBufferIfNeed:self.mProgram index:index];
    [GLUtil glCheck:@"uploadDataToProgram"];
    
    // Pass in the combined matrix.
    [direcotr shot:self.mProgram];
    [GLUtil glCheck:@"shot"];
    
    [object3D onDraw];

}

@end

@interface MDPanoramaPluginBuilder()
@property (nonatomic,readonly) MD360Texture* texture;
@property (nonatomic,readonly) MD360Program* program;
@property (nonatomic,weak) MDPluginManager* pluginManager;
@property (nonatomic,weak) MDProjectionStrategyManager* projectionStrategyManager;
@end

@implementation MDPanoramaPluginBuilder

- (void) setTexture:(MD360Texture*) texture{
    _texture = texture;
}

- (void) setProgram:(MD360Program*) program{
    _program = program;
}

- (void) setProjectionStrategyManager:(MDProjectionStrategyManager*) projectionStrategyManager{
    _projectionStrategyManager = projectionStrategyManager;
}

- (MDPanoramaPlugin*) build{
    MDPanoramaPlugin* plugin = [[MDPanoramaPlugin alloc]init];
    plugin.mTexture = self.texture;
    plugin.mProgram = self.program;
    plugin.mProjectionStrategyManager = self.projectionStrategyManager;
    return plugin;
}

@end