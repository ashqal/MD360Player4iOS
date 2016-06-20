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
@property (nonatomic,strong) MDAbsObject3D* mObject3D;
@property (nonatomic,strong) MD360Program* mProgram;
@property (nonatomic,strong) MD360Texture* mTexture;
@property (nonatomic,strong) NSArray* mDirectors;
@property (nonatomic,strong) MDDisplayStrategyManager* mDisplayStrategyManager;
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
    self.mProgram = [[MD360Program alloc]init];
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
    [self.mTexture resize:width height:height];
}

- (void) rendererOnDrawFrame:(EAGLContext*)context width:(int)width height:(int)height{
    
    // clear
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [GLUtil glCheck:@"glClear"];
    
  
    // use
    [self.mProgram use];
    [GLUtil glCheck:@"mProgram use"];
    
    
    // update texture
    [self.mTexture updateTexture:context];
    
    // upload
    [self.mObject3D uploadDataToProgram:self.mProgram];
    [GLUtil glCheck:@"uploadDataToProgram"];
    float scale = [GLUtil getScrrenScale];
    int widthPx = width * scale;
    int heightPx = height * scale;
    
    int size = [self.mDisplayStrategyManager getVisibleSize];
    int itemWidthPx = widthPx * 1.0 / size;
    for (int i = 0; i < size; i++ ) {
        if (i >= [self.mDirectors count]) {
            return;
        }
        
        MD360Director* direcotr = [self.mDirectors objectAtIndex:i];
        glViewport(itemWidthPx * i, 0, itemWidthPx, heightPx);

        // Update Projection
        [direcotr updateProjection:itemWidthPx height:heightPx];
        
        // Pass in the combined matrix.
        [direcotr shot:self.mProgram];
        [GLUtil glCheck:@"shot"];
        
        // Tell the texture uniform sampler to use this texture in the shader by binding to texture unit 0.
        glUniform1i(self.mProgram.mTextureUniformHandle, 0);
        [GLUtil glCheck:@"glUniform1i mTextureUniformHandle"];
        
        [self.mObject3D onDraw];
    }
}

- (void) initProgram {
    [self.mProgram build];
}

- (void) initTexture:(EAGLContext*)context {
    [self.mTexture createTexture:context];
}

- (void) initObject3D {
    // load
    [self.mObject3D loadObj];
  
       
}

- (void) rendererOnDestroy:(EAGLContext*) context{
    [self.mObject3D destroy];
    [self.mProgram destroy];
    self.mDirectors = nil;
}

@end

@interface MD360RendererBuilder()
@property (nonatomic,readonly) NSArray* directors;
@property (nonatomic,readonly) MD360Texture* texture;
@property (nonatomic,readonly) MDAbsObject3D* object3D;
@property (nonatomic,readonly) MDDisplayStrategyManager* displayStrategyManager;
@end

@implementation MD360RendererBuilder

- (void) setDirectors:(NSArray*) directors{
    _directors = directors;
}

- (void) setTexture:(MD360Texture*) texture{
    _texture = texture;
}

- (void) setObject3D:(MDAbsObject3D*) object3D{
    _object3D = object3D;
}

- (void) setDisplayStrategyManager:(MDDisplayStrategyManager*) displayStrategyManager{
    _displayStrategyManager = displayStrategyManager;
}

- (MD360Renderer*) build{
    MD360Renderer* renderer = [[MD360Renderer alloc]init];
    renderer.mDirectors = self.directors;
    renderer.mTexture = self.texture;
    renderer.mObject3D = self.object3D;
    renderer.mDisplayStrategyManager = self.displayStrategyManager;
    return renderer;
}

@end
