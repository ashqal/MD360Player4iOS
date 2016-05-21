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

@interface MD360Renderer()
@property (nonatomic,strong) MDAbsObject3D* mObject3D;
@property (nonatomic,strong) MD360Program* mProgram;
@property (nonatomic,strong) MD360Texture* mTexture;
@property (nonatomic,strong) MD360Director* mDirector;
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
    [self.mObject3D destroy];
    [self.mProgram destroy];
    [self.mDirector destroy];
}

- (void) setup{
    self.mProgram = [[MD360Program alloc]init];
    self.mObject3D = [[MDSphere3D alloc]init];
}

- (void) rendererOnCreated:(EAGLContext*)context{
    //glEnable(GL_DEPTH_TEST);
    //glEnable(GL_CULL_FACE);
    //glEnable(GL_TEXTURE_2D);
    //glEnable(GL_BLEND);
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
    // Set the OpenGL viewport to the same size as the surface.
    glViewport(0, 0, width, height);
    
    // update surface
    [self.mTexture resize:width height:height];
    
    // Update Projection
    [self.mDirector updateProjection:width height:height];
}

- (void) rendererOnDrawFrame:(EAGLContext*)context{
    // clear
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    // glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    // glClear(GL_COLOR_BUFFER_BIT);
    [GLUtil glCheck:@"glClear"];
    
    // use
    [self.mProgram use];
    [GLUtil glCheck:@"mProgram use"];
    
    // update texture
    [self.mTexture updateTexture:context];
    
    // Tell the texture uniform sampler to use this texture in the shader by binding to texture unit 0.
    glUniform1i(self.mProgram.mTextureUniformHandle, 0);
    [GLUtil glCheck:@"glUniform1i mTextureUniformHandle"];
    
    // Pass in the combined matrix.
    [self.mDirector shot:self.mProgram];
    [GLUtil glCheck:@"shot"];
    
    if ([self.mObject3D getIndices] != 0) {
        GLsizei count = self.mObject3D.mNumIndices;
        const GLvoid* indices = [self.mObject3D getIndices];
        glDrawElements(GL_TRIANGLES, count, GL_UNSIGNED_SHORT, indices);
    } else {
        glDrawArrays(GL_TRIANGLES, 0, self.mObject3D.mNumIndices);
    }
    // Draw
    
    [GLUtil glCheck:@"glDrawArrays"];
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
    
    // upload
    [self.mObject3D uploadDataToProgram:self.mProgram];
}

- (void) rendererOnDestroy:(EAGLContext*) context{
    
}

@end

@interface MD360RendererBuilder()
@property (nonatomic,readonly) MD360Director* director;
@property (nonatomic,readonly) MD360Texture* texture;
@end

@implementation MD360RendererBuilder

- (void) setDirector:(MD360Director*) director{
    _director = director;
}

- (void) setTexture:(MD360Texture*) texture{
    _texture = texture;
}

- (MD360Renderer*) build{
    MD360Renderer* renderer = [[MD360Renderer alloc]init];
    renderer.mDirector = self.director;
    renderer.mTexture = self.texture;
    return renderer;
}

@end
