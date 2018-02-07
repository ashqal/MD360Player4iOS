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
#import "BarrelDistortionConfig.h"
#import "VRUtil.h"

#pragma mark MDBarrelDistortionMesh
@interface MDBarrelDistortionMesh : MDAbsObject3D {
    float* mSingleTexCoorBuffer;
}
@property (nonatomic) int mode;
@property (nonatomic, weak) BarrelDistortionConfig* mConfig;
-(instancetype) initWithConfig:(BarrelDistortionConfig*) config;
@end

#pragma mark MDBarrelDistortionLinePipe
@interface MDBarrelDistortionLinePipe(){
}
@property (nonatomic,strong) MD360Program* mProgram;
@property (nonatomic,strong) MDBarrelDistortionMesh* object3DAnti;
@property (nonatomic,strong) MDPlane* object3DPlane;
@property (nonatomic,strong) MD360Director* mDirector;
@property (nonatomic,strong) MDDrawingCache* mDrawingCache;
@property (nonatomic,strong) MDDisplayStrategyManager* mDisplayManager;
@property (nonatomic,strong) BarrelDistortionConfig* mConfig;
@property (nonatomic) BOOL mEnabled;
@end

@implementation MDBarrelDistortionLinePipe

-(instancetype)initWith:(MDDisplayStrategyManager*) displayManager{
    self = [super init];
    if (self) {
        self.mDisplayManager = displayManager;
        self.mProgram = [[MDRGBAFboProgram alloc] init];
        self.mDrawingCache = [[MDDrawingCache alloc] init];
        self.mDirector = [[[MD360OrthogonalDirectorFactory alloc] init] createDirector:0];
        
        MDSizeContext* size = [[MDSizeContext alloc] init];
        [size updateTextureWidth:100 height:100];
        [size updateViewportWidth:100 height:100];
        
        // self.object3D = [[MDPlane alloc] initWithSize:size];
        self.object3DAnti = [[MDBarrelDistortionMesh alloc] initWithConfig:self.mDisplayManager.barrelDistortionConfig];
        self.object3DPlane = [[MDPlane alloc] initWithSize:size];
    }
    return self;
}

-(void) setup:(EAGLContext*) context {
    
    [self.mProgram build];
    // todo load obj3d
    [MDObject3DHelper loadObj:self.object3DAnti];
    [MDObject3DHelper loadObj:self.object3DPlane];
}

-(void) takeOverTotalWidth:(int)w totalHeight:(int)h size:(int)size {
    // NSLog(@"MDBarrelDistortionLinePipe takeOverTotalWidth %d %d %d, enabled:%d", w, h, size, YES);
    // NSLog(@"takeOver");
    
    [self.mDrawingCache bindTotalWidth:w totalHeight:h];
    
    [self.mDirector updateProjection:w height:h];
    
    // obj3d setMode size
    self.object3DAnti.mode = size;
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [GLUtil glCheck:@"MDBarrelDistortionLinePipe glClear"];
}

-(void) commitTotalWidth:(int)w totalHeight:(int)h size:(int)size texture:(GLint)texture {
    // NSLog(@"commit");
    self.mEnabled = [self.mDisplayManager isAntiDistortionEnabled];
    
    [self.mDrawingCache unbind];
    if (!self.mEnabled) {
        size = 1;
    }
    
    int width = w / size;
    for (int i = 0; i < size; i++){
        glViewport(width * i, 0, width, h);
        glEnable(GL_SCISSOR_TEST);
        glScissor(width * i, 0, width, h);
        [self draw:i texture:texture];
        glDisable(GL_SCISSOR_TEST);
    }
}

-(void) draw:(int) index texture:(GLint)texture {
    [self.mProgram use];
    [GLUtil glCheck:@"MDBarrelDistortionLinePipe mProgram use"];
    
    if (self.mEnabled) {
        [self.object3DAnti uploadVerticesBufferIfNeed:self.mProgram index:index];
        [self.object3DAnti uploadTexCoordinateBufferIfNeed:self.mProgram index:index];
    } else {
        [self.object3DPlane uploadVerticesBufferIfNeed:self.mProgram index:index];
        [self.object3DPlane uploadTexCoordinateBufferIfNeed:self.mProgram index:index];
    }
    
    [self.mDirector shot:self.mProgram];
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(self.mProgram.mTextureUniformHandle[0], 0);
    
    if (self.mEnabled) {
        [self.object3DAnti onDraw];
    } else {
        [self.object3DPlane onDraw];
    }
    
    
    // NSLog(@"MDBarrelDistortionLinePipe draw");
}

-(GLint) getTextureId {
    return [self.mDrawingCache getTextureOutput];
}

@end


@implementation MDBarrelDistortionMesh

- (instancetype)initWithConfig:(BarrelDistortionConfig *)config
{
    self = [super init];
    if (self) {
        self.mConfig = config;
    }
    return self;
}

- (float*)getTextureBuffer:(int)index {
    if (self.mode == 2) {
        return [super getTextureBuffer:index];
    }
    return mSingleTexCoorBuffer;
}

- (void)executeLoad{
    [self generateMesh:self];
}

- (void) generateMesh:(MDAbsObject3D*) object3D{
    int rows = 16;
    int columns = 16;
    int numPoint = (rows + 1) * (columns + 1);
    int numIndices = rows * columns;
    
    short r, s;
    float z = -1;
    float R = 1.0f/(float) rows;
    float S = 1.0f/(float) columns;
    
    
    float* vertexs = malloc(sizeof(float) * numPoint * 3);
    float* texcoords = malloc(sizeof(float) * numPoint * 2);
    float* texcoords1 = malloc(sizeof(float) * numPoint * 2);
    float* texcoords2 = malloc(sizeof(float) * numPoint * 2);
    
    short* indices = malloc(sizeof(short) * numIndices * 6);
    
    int t = 0;
    int v = 0;
    for(r = 0; r < rows + 1; r++) {
        for(s = 0; s < columns + 1; s++) {
            int tu = t++;
            int tv = t++;
            
            texcoords[tu] = s*S;
            texcoords[tv] = 1 - r*R;
            
            texcoords1[tu] = s*S*0.5f;
            texcoords1[tv] = 1 - r*R;
            
            texcoords2[tu] = s*S*0.5f + 0.5f;
            texcoords2[tv] = 1 - r*R;
            
            vertexs[v++] = (s * S * 2.0f - 1.0f);
            vertexs[v++] = (r * R * 2.0f - 1.0f);
            vertexs[v++] = z;
        }
    }
    
    [self applyBarrelDistortionNumPoint:numPoint vertexs:vertexs];
    
    int counter = 0;
    int sectorsPlusOne = columns + 1;
    for(r = 0; r < rows; r++){
        for(s = 0; s < columns; s++) {
            short k0 = (short) ((r) * sectorsPlusOne + (s+1));  // (c)
            short k1 = (short) ((r+1) * sectorsPlusOne + (s));    //(b)
            short k2 = (short) (r * sectorsPlusOne + s);       //(a);
            short k3 = (short) ((r) * sectorsPlusOne + (s+1));  // (c)
            short k4 = (short) ((r+1) * sectorsPlusOne + (s+1));  // (d)
            short k5 = (short) ((r+1) * sectorsPlusOne + (s));    //(b)
            
            indices[counter++] = k0;
            indices[counter++] = k1;
            indices[counter++] = k2;
            indices[counter++] = k3;
            indices[counter++] = k4;
            indices[counter++] = k5;
        }
    }
    
    mSingleTexCoorBuffer = texcoords;
    [object3D setNumIndices:numIndices * 6];
    [object3D setIndicesBuffer:indices size:numIndices * 6];
    [object3D setVertexIndex:0 buffer:vertexs size:numPoint * 3];
    [object3D setTextureIndex:0 buffer:texcoords1 size:numPoint * 2];
    [object3D setTextureIndex:1 buffer:texcoords2 size:numPoint * 2];
    
    free(texcoords1);
    free(texcoords2);
    free(vertexs);
    free(indices);
}

-(void) applyBarrelDistortionNumPoint:(int) numPoint vertexs:(float*) vertexs {
    float tmp[2];
    
    for (int i = 0; i < numPoint; i++){
        int xIndex = i * 3;
        int yIndex = i * 3 + 1;
        float xValue = vertexs[xIndex];
        float yValue = vertexs[yIndex];
        tmp[0] = xValue;
        tmp[1] = yValue;
        
        [VRUtil barrelDistortionA:self.mConfig.paramA b:self.mConfig.paramB c:self.mConfig.paramC src:tmp];
            
        vertexs[xIndex] = tmp[0] * self.mConfig.scale;
        vertexs[yIndex] = tmp[1] * self.mConfig.scale;

    }
}

@end
