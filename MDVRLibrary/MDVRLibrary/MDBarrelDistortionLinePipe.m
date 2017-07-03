//
//  MDBarrelDistortionLinePipe.m
//  MDVRLibrary
//
//  Created by Asha on 2017/7/2.
//  Copyright © 2017年 asha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDAbsLinePipe.h"
#import "MDAbsPlugin.h"
#import "MD360Program.h"
#import "MD360Texture.h"
#import "MDAbsObject3D.h"
#import "MDDrawingCache.h"
#import "MDObject3DHelper.h"

#pragma mark MDBarrelDistortionLinePipe
@interface MDBarrelDistortionLinePipe(){
}
@property (nonatomic,strong) MD360Program* mProgram;
@property (nonatomic,strong) MD360Texture* mTexture;
@property (nonatomic,strong) MDAbsObject3D* object3D;
@property (nonatomic,strong) MD360Director* mDirector;
@property (nonatomic,strong) MDDrawingCache* mDrawingCache;
@property (nonatomic,weak) MDDisplayStrategyManager* mDisplayManager;
@property (nonatomic,strong) MDSizeContext* size;
@property (nonatomic) BOOL mEnabled;
@end

@implementation MDBarrelDistortionLinePipe

-(instancetype)initWith:(MDDisplayStrategyManager*) displayManager{
    self = [super init];
    if (self) {
        self.mDisplayManager = displayManager;
        self.mProgram = [[MDRGBAProgram alloc] init];
        self.mDrawingCache = [[MDDrawingCache alloc] init];
        self.mDirector = [[[MD360OrthogonalDirectorFactory alloc] init] createDirector:0];
        
        self.size = [[MDSizeContext alloc] init];
        [self.size updateViewportWidth:100 height:100];
        [self.size updateTextureWidth:100 height:100];
        self.object3D = [[MDPlane alloc] initWithSize:self.size];
        
    }
    return self;
}

-(void) setup:(EAGLContext*) context {
    [self.mProgram build];
    // todo load obj3d
    [MDObject3DHelper loadObj:self.object3D];
}

-(void) takeOverTotalWidth:(int)w totalHeight:(int)h size:(int)size {
    self.mEnabled = [self.mDisplayManager isAntiDistortionEnabled];
    if(!self.mEnabled) {
        return;
    }
    
    [self.mDrawingCache bindTotalWidth:w totalHeight:h];
    
    [self.mDirector updateProjection:w height:h];
    
    // obj3d setMode size
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [GLUtil glCheck:@"MDBarrelDistortionLinePipe glClear"];
}

-(void) commitTotalWidth:(int)w totalHeight:(int)h size:(int)size {
    if(!self.mEnabled) {
        return;
    }
    [self.mDrawingCache unbind];
    int width = w / size;
    for (int i = 0; i < size; i++){
        glViewport(width * i, 0, width, h);
        glEnable(GL_SCISSOR_TEST);
        glScissor(width * i, 0, width, h);
        [self draw:i];
        glDisable(GL_SCISSOR_TEST);
    }
}

-(void) draw:(int) index {
    [self.mProgram use];
    [GLUtil glCheck:@"MDBarrelDistortionLinePipe mProgram use"];
    
    [self.object3D uploadVerticesBufferIfNeed:self.mProgram index:index];
    [self.object3D uploadTexCoordinateBufferIfNeed:self.mProgram index:index];
    
    [self.mDirector shot:self.mProgram];
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, [self.mDrawingCache getTextureOutput]);
    
    [self.object3D onDraw];
}

@end

@interface MDBarrelDistortionMesh : MDAbsObject3D
@property (nonatomic) int mode;

@end
