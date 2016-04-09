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

#import "MD360Director.h"
#import "GLUtil.h"

@interface MD360Renderer()
@property (nonatomic,retain) MDAbsObject3D* mObject3D;
@property (nonatomic,retain) MD360Program* mProgram;
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
    
    // TODO create by MDVRLibrary
    self.mTexture = [[MD360BitmapTexture alloc]init];
    
    self.mObject3D = [[MDSphere3D alloc]init];
    
}

- (void) rendererOnCreated:(EAGLContext*)context{
    NSLog(@"rendererOnCreated");
    //glEnable(GL_DEPTH_TEST);
    //glEnable(GL_CULL_FACE);
    //glEnable(GL_TEXTURE_2D);
    glEnable(GL_BLEND);
    [GLUtil glCheck:@"glEnable"];
    
    // init
    [self initProgram];
    [GLUtil glCheck:@"initProgram"];
    
    [self initTexture];
    [GLUtil glCheck:@"initTexture"];
    
    [self initObject3D];
    [GLUtil glCheck:@"initObject3D"];
    
}

- (void) rendererOnChanged:(EAGLContext*)context width:(int)width height:(int)height{
    NSLog(@"rendererOnChanged");
    // Set the OpenGL viewport to the same size as the surface.
    glViewport(0, 0, width, height);
    
    // update surface
    [self.mTexture resize:width height:height];
    
    // Update Projection
    [self.mDirector updateProjection:width height:height];
}

- (void) rendererOnDrawFrame:(EAGLContext*)context{
    // NSLog(@"rendererOnDrawFrame");
    
    // clear
    // glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
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
    
    // Draw
    glDrawArrays(GL_TRIANGLES, 0, self.mObject3D.mNumIndices);
    [GLUtil glCheck:@"glDrawArrays"];
}

- (void) initProgram {
    [self.mProgram build];
}

- (void) initTexture {
    [self.mTexture createTexture];
}

- (void) initObject3D {
    // load
    [self.mObject3D loadObj];
    
    // upload
    [self.mObject3D uploadDataToProgram:self.mProgram];
}

@end
