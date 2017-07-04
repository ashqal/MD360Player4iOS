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

@interface MDBarrelDistortionMesh : MDAbsObject3D{
    float* mSingleTexCoorBuffer;
}
@property (nonatomic) int mode;

@end

#pragma mark MDBarrelDistortionLinePipe
@interface MDBarrelDistortionLinePipe(){
}
@property (nonatomic,strong) MD360Program* mProgram;
@property (nonatomic,strong) MD360Texture* mTexture;
@property (nonatomic,strong) MDAbsObject3D* object3D;
@property (nonatomic,strong) MD360Director* mDirector;
@property (nonatomic,strong) MDDrawingCache* mDrawingCache;
@property (nonatomic,strong) MDDisplayStrategyManager* mDisplayManager;
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
        
        MDSizeContext* size = [[MDSizeContext alloc] init];
        [size updateViewportWidth:100 height:100];
        [size updateTextureWidth:100 height:100];
        self.object3D = [[MDPlane alloc] initWithSize:size];
    }
    return self;
}

-(void) setup:(EAGLContext*) context {
    [self.mProgram build];
    // todo load obj3d
    [MDObject3DHelper loadObj:self.object3D];
}

-(void) takeOverTotalWidth:(int)w totalHeight:(int)h size:(int)size {
    // NSLog(@"MDBarrelDistortionLinePipe takeOverTotalWidth %d %d %d, enabled:%d", w, h, size, YES);
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

@implementation MDBarrelDistortionMesh
- (float*)getTextureBuffer:(int)index {
    if(self.mode == 1) {
        return mSingleTexCoorBuffer;
    } else if (self.mode == 2) {
        return [super getTextureBuffer:index];
    } else {
        return nil;
    }
}

- (void)executeLoad{
    [self generateMesh:self];
}

- (void) generateMesh:(MDAbsObject3D*) object3D{
    int rows = 10;
    int columns = 10;
    int numPoint = (rows + 1) * (columns + 1);
    short r, s;
    float z = -8;
    float R = 1.0f/(float) rows;
    float S = 1.0f/(float) columns;
    
    
    float* vertexs = malloc(sizeof(float) * numPoint * 3);
    float* texcoords = malloc(sizeof(float) * numPoint * 2);
    float* texcoords1 = malloc(sizeof(float) * numPoint * 2);
    float* texcoords2 = malloc(sizeof(float) * numPoint * 2);
    short* indices = malloc(sizeof(short) * numPoint * 6);
    
    int t = 0;
    int v = 0;
    for(r = 0; r < rows + 1; r++) {
        for(s = 0; s < columns + 1; s++) {
            int tu = t++;
            int tv = t++;
            
            texcoords[tu] = s*S;
            texcoords[tv] = r*R;
            
            texcoords1[tu] = s*S*0.5f;
            texcoords1[tv] = r*R;
            
            texcoords2[tu] = s*S*0.5f + 0.5f;
            texcoords2[tv] = r*R;
            
            vertexs[v++] = (s * S * 2 - 1);
            vertexs[v++] = (r * R * 2 - 1);
            vertexs[v++] = z;
        }
    }
    
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
    [object3D setNumIndices:numPoint * 6];
    [object3D setIndicesBuffer:indices size:numPoint * 6];
    [object3D setVertexIndex:0 buffer:vertexs size:numPoint * 3];
    [object3D setTextureIndex:0 buffer:texcoords1 size:numPoint * 2];
    [object3D setTextureIndex:1 buffer:texcoords2 size:numPoint * 2];
    
    free(texcoords1);
    free(texcoords2);
    free(vertexs);
    free(indices);
}


@end
