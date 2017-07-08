//
//  MDPlane.m
//  MDVRLibrary
//
//  Created by ashqal on 16/7/24.
//  Copyright © 2016年 asha. All rights reserved.
//

#import "MDAbsObject3D.h"

static const int sNumRow = 10;
static const int sNumColumn = 10;

@interface MDPlane(){
    float mPrevRatio;
    float* pScaledVerticesBuffer;
    float* mScaledVerticesBuffer;
}

@property (nonatomic,strong) MDPlaneScaleCalculator* mCalculator;

@end

@implementation MDPlane
- (instancetype)initWithCalculator:(MDPlaneScaleCalculator*) calculator{
    self = [super init];
    if (self) {
        //
        self.mCalculator = calculator;
    }
    return self;
}

- (instancetype)initWithSize:(MDSizeContext*) size {
    MDPlaneScaleCalculator* calculator = [[MDPlaneScaleCalculator alloc] initWithScale:MDModeProjectionPlaneFull sizeContext:size];
    return [self initWithCalculator:calculator];
}

-(NSString*) obtainObjPath{
    return nil;
}

- (void)executeLoad{
    [self generatePlane:self];
}

- (void) destroy{
    [super destroy];
    if (mScaledVerticesBuffer != NULL) {
        free(mScaledVerticesBuffer);
        mScaledVerticesBuffer = NULL;
    }
}

- (void)uploadVerticesBufferIfNeed:(MD360Program*) program index:(int)index{
    
    if ([super getVertexBuffer:index] == NULL){
        return;
    }
    float ratio = [self.mCalculator getTextureRatio];
    if (ratio == mPrevRatio) {
        pScaledVerticesBuffer = [super getVertexBuffer:index];
    } else {
        mScaledVerticesBuffer = [self generateVertex];
        pScaledVerticesBuffer = mScaledVerticesBuffer;
    }
    
    [super uploadVerticesBufferIfNeed:program index:index];
}

- (float*)getVertexBuffer:(int)index{
    return pScaledVerticesBuffer;
}

- (void) generatePlane:(MDAbsObject3D*) object3D{
    int numPoint = [self getNumPoint];
    float* texcoords = [self generateTexcoords];
    float* vertexs = [self generateVertex];
    
    int rows = [self getNumRow];
    int columns = [self getNumColumn];
    float numIndices = rows * columns * 6;
    short* indices = malloc(sizeof(short) * numIndices);
    
    short r,s;
    
    int counter = 0;
    int sectorsPlusOne = columns + 1;
    for(r = 0; r < rows; r++){
        for(s = 0; s < columns; s++) {
            // d a c d a b
            
            short k0 = (short) (r * sectorsPlusOne + s);       //(a);
            short k1 = (short) ((r) * sectorsPlusOne + (s+1));  // (c)
            short k2 = (short) ((r+1) * sectorsPlusOne + (s));    //(b)
            short k3 = (short) (r * sectorsPlusOne + s);       //(a);
            short k4 = (short) ((r+1) * sectorsPlusOne + (s+1));  // (d)
            short k5 = (short) ((r) * sectorsPlusOne + (s+1));  // (c)
            
            indices[counter++] = k0;
            indices[counter++] = k1;
            indices[counter++] = k2;
            indices[counter++] = k3;
            indices[counter++] = k4;
            indices[counter++] = k5;
        }
    }
    
    [object3D setTextureIndex:0 buffer:texcoords size: 2 * numPoint]; //object3D.setTexCoordinateBuffer(texBuffer);
    [object3D setVertexIndex:0 buffer:vertexs size: 3 * numPoint]; //object3D.setVerticesBuffer(vertexBuffer);
    [object3D setIndicesBuffer:indices size: numIndices];
    [object3D setNumIndices: numIndices];
    
    free(texcoords);
    free(vertexs);
    free(indices);
}

- (float*) generateVertex{
    int numPoint = [self getNumPoint];
    int z = -1;
    
    [self.mCalculator calculate];
    mPrevRatio = [self.mCalculator getTextureRatio];
    float width = [self.mCalculator getTextureWidth];
    float height = [self.mCalculator getTextureHeight];
    
    float* vertexs = malloc (sizeof(float) * 3 * numPoint);
    int rows = [self getNumRow];
    int columns = [self getNumColumn];
    float R = 1.0f / rows;
    float S = 1.0f / columns;
    short r,s;
    
    int v = 0;
    for(r = 0; r < rows + 1; r++) {
        for (s = 0; s < columns + 1; s++) {
            vertexs[v++] = (s * S) * width * 2.0f - 1.0f;
            vertexs[v++] = (r * R) * height * 2.0f - 1.0f;
            vertexs[v++] = z;
        }
    }
    
    return vertexs;
}

-(float*) generateTexcoords{
    int numPoint = [self getNumPoint];
    float* texcoords = malloc (sizeof(float) * 2 * numPoint);
    
    int rows = [self getNumRow];
    int columns = [self getNumColumn];
    float R = 1.0f / rows;
    float S = 1.0f / columns;
    short r,s;
    
    int t = 0;
    for(r = 0; r < rows + 1; r++) {
        for (s = 0; s < columns + 1; s++) {
            texcoords[t++] = s*S;
            texcoords[t++] = 1 - r*R;
        }
    }
    
    return texcoords;
}

- (int) getNumPoint {
    return ([self getNumRow] + 1) * ([self getNumColumn] + 1);
}

- (int) getNumRow {
    return sNumRow;
}

- (int) getNumColumn {
    return sNumColumn;
}

@end
