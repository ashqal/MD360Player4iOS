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
#import "MD360Surface.h"
#import "MD360Director.h"
#import "GLUtil.h"

@interface MD360Renderer()
@property (nonatomic,retain) MDAbsObject3D* mObject3D;
@property (nonatomic,retain) MD360Program* mProgram;
@property (nonatomic,retain) MD360Surface* mSurface;
@property (nonatomic,retain) MD360Director* mDirector;
@end

@implementation MD360Renderer

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup{
    // TODO
    self.mDirector = [[MD360Director alloc]init];
    
    self.mProgram = [[MD360Program alloc]init];
    self.mSurface = [[MD360Surface alloc]init];
    self.mObject3D = [[MDSphere3D alloc]init];
    
}

- (void) rendererOnCreated:(EAGLContext*)context{

    // init
    [self initProgram];
    [self initTexture];
    [self initObject3D];
}

- (void) rendererOnChanged:(EAGLContext*)context width:(int)width height:(int)height{
    // Set the OpenGL viewport to the same size as the surface.
    glViewport(0, 0, width, height);
    
    // update surface
    [self.mSurface resize:width height:height];
    
    // Update Projection
    [self.mDirector updateProjection:width height:height];
}

- (void) rendererOnDrawFrame:(EAGLContext*)context{
    // NSLog(@"rendererOnDrawFrame");
    
    // clear
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // use
    [self.mProgram use];
    
    // Tell the texture uniform sampler to use this texture in the shader by binding to texture unit 0.
    glUniform1i(self.mProgram.mTextureUniformHandle, 0);
    
    // Pass in the combined matrix.
    [self.mDirector shot:self.mProgram];
    
    // Draw
    glDrawArrays(GL_TRIANGLES, 0, self.mObject3D.mNumIndices);
}

- (void) initProgram {
    [self.mProgram build];
}

- (void) initTexture {
    [self.mSurface createSurface];
}

- (void) initObject3D {
    // load
    [self.mObject3D loadObj];
    
    // upload
    [self.mObject3D uploadDataToProgram:self.mProgram];
}

@end
