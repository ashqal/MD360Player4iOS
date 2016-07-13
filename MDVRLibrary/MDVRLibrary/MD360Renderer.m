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

@interface MD360Renderer()
@property (nonatomic,strong) MD360Program* mProgram;
@property (nonatomic,strong) MD360Texture* mTexture;
@property (nonatomic,weak) MDDisplayStrategyManager* mDisplayStrategyManager;
@property (nonatomic,weak) MDProjectionStrategyManager* mProjectionStrategyManager;
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
    [GLUtil glCheck:@"glEnable"];
    
    // init
    [self initProgram];
    [GLUtil glCheck:@"initProgram"];
    
    [self initTexture:context];
    [GLUtil glCheck:@"initTexture"];
    
    [self initObject3D];
    [GLUtil glCheck:@"initObject3D"];
    
}

- (void) rendererOnChanged:(EAGLContext*)context width:(int)width height:(int)height{
    // update surface
    [self.mTexture resizeViewport:width height:height];
}

- (void) rendererOnDrawFrame:(EAGLContext*)context width:(int)width height:(int)height{
    // clear
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [GLUtil glCheck:@"glClear"];
    
    // get object3D
    MDAbsObject3D* object3D = nil;
    if ([self.mProjectionStrategyManager respondsToSelector:@selector(getObject3D)]) {
        object3D = [self.mProjectionStrategyManager getObject3D];
    }
    if (object3D == nil) return;
    
    // get directors
    NSArray* directors = nil;
    if ([self.mProjectionStrategyManager respondsToSelector:@selector(getDirectors)]) {
        directors = [self.mProjectionStrategyManager getDirectors];
    }
    if (directors == nil) return;
    
    // update texture
    BOOL updated = [self.mTexture updateTexture:context];
    if (!updated) return;
    
    // draw
    float scale = [GLUtil getScrrenScale];
    int widthPx = width * scale;
    int heightPx = height * scale;
    
    int size = [self.mDisplayStrategyManager getVisibleSize];
    int itemWidthPx = widthPx * 1.0 / size;
    for (int i = 0; i < size; i++ ) {
        if (i >= [directors count]) {
            return;
        }
        
        MD360Director* direcotr = [directors objectAtIndex:i];
        glViewport(itemWidthPx * i, 0, itemWidthPx, heightPx);

        // Update Projection
        [direcotr updateProjection:itemWidthPx height:heightPx];
        
        // use
        [self.mProgram use];
        [GLUtil glCheck:@"mProgram use"];

        // upload
        [object3D uploadVerticesBufferIfNeed:self.mProgram index:i];
        [object3D uploadTexCoordinateBufferIfNeed:self.mProgram index:i];
        [GLUtil glCheck:@"uploadDataToProgram"];
        
        // Pass in the combined matrix.
        [direcotr shot:self.mProgram];
        [GLUtil glCheck:@"shot"];
        
        [object3D onDraw];
    }
}

- (void) initProgram {
    [self.mProgram build];
}

- (void) initTexture:(EAGLContext*)context {
    [self.mTexture createTexture:context program:self.mProgram];
}

- (void) initObject3D {
    // load

    if ([self.mProjectionStrategyManager respondsToSelector:@selector(getObject3D)]) {
        MDAbsObject3D* object3D = [self.mProjectionStrategyManager getObject3D];
        if ([object3D respondsToSelector:@selector(markChanged)]) {
            [object3D markChanged];
        }
    }
}

- (void) rendererOnDestroy:(EAGLContext*) context{
    // [self.mObject3D destroy];
    [self.mProgram destroy];
    // self.mDirectors = nil;
}

@end

@interface MD360RendererBuilder()
@property (nonatomic,readonly) NSArray* directors;
@property (nonatomic,readonly) MD360Texture* texture;
@property (nonatomic,readonly) MD360Program* program;
@property (nonatomic,weak) MDDisplayStrategyManager* displayStrategyManager;
@property (nonatomic,weak) MDProjectionStrategyManager* projectionStrategyManager;
@end

@implementation MD360RendererBuilder

- (void) setDirectors:(NSArray*) directors{
    _directors = directors;
}

- (void) setTexture:(MD360Texture*) texture{
    _texture = texture;
}

- (void) setProgram:(MD360Program*) program{
    _program = program;
}

- (void) setDisplayStrategyManager:(MDDisplayStrategyManager*) displayStrategyManager{
    _displayStrategyManager = displayStrategyManager;
}

- (void) setProjectionStrategyManager:(MDProjectionStrategyManager*) projectionStrategyManager{
    _projectionStrategyManager = projectionStrategyManager;
}

- (MD360Renderer*) build{
    MD360Renderer* renderer = [[MD360Renderer alloc]init];
    renderer.mTexture = self.texture;
    renderer.mProgram = self.program;
    renderer.mProjectionStrategyManager = self.projectionStrategyManager;
    renderer.mDisplayStrategyManager = self.displayStrategyManager;
    return renderer;
}

@end
