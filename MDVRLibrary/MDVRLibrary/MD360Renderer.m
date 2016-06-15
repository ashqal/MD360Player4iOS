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
        
        NSLog(@"MD360Renderer init:%@",self);
    }
    return self;
}

- (void)dealloc{
    
    NSLog(@"MD360Renderer dealloc:%@",self);
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
    
    // float contentScale = [GLUtil getScrrenScale];
    // self.mWidth = width;// / contentScale;
    // self.mHeight = height;// / contentScale;
}

- (void) rendererOnDrawFrame:(EAGLContext*)context width:(int)width height:(int)height{
    
    // NSLog(@"rendererOnDrawFrame ");
    
    // clear
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [GLUtil glCheck:@"glClear"];

    // use
    [self.mProgram use];
    [GLUtil glCheck:@"mProgram use"];
    
    
    // update texture
    BOOL updated = [self.mTexture updateTexture:context];
    if (updated) {
        
        // upload
        [self.mObject3D uploadDataToProgram:self.mProgram];
        [GLUtil glCheck:@"uploadDataToProgram"];
        float scale = [GLUtil getScrrenScale];
        int widthPx = width * scale;
        int heightPx = height * scale;
        
        int size = 2;
        int itemWidthPx = widthPx * 1.0 / size;
        for (int i = 0; i < size; i++ ) {
            glViewport(itemWidthPx * i, 0, itemWidthPx, heightPx);
            
            // update surface
            // [self.mTexture resize:itemWidth height:self.mHeight];
            
            // Update Projection
            [self.mDirector updateProjection:itemWidthPx height:heightPx];
            
            // Pass in the combined matrix.
            [self.mDirector shot:self.mProgram];
            [GLUtil glCheck:@"shot"];
            
            
            // Tell the texture uniform sampler to use this texture in the shader by binding to texture unit 0.
            glUniform1i(self.mProgram.mTextureUniformHandle, 0);
            [GLUtil glCheck:@"glUniform1i mTextureUniformHandle"];
            
            [self.mObject3D onDraw];
        }
        
        
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
    [self.mDirector destroy];
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
