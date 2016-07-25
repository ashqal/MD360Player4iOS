//
//  MDPlane.m
//  MDVRLibrary
//
//  Created by ashqal on 16/7/24.
//  Copyright © 2016年 asha. All rights reserved.
//

#import "MDAbsObject3D.h"

static const int sPlaneNumPoint = 6;

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

-(NSString*) obtainObjPath{
    return nil;
}

- (void)executeLoad{
    [self generatePlane:self];
    [self markChanged];
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
        [self markVerticesChanged];
    }
    
    [super uploadVerticesBufferIfNeed:program index:index];
}

- (float*)getVertexBuffer:(int)index{
    return pScaledVerticesBuffer;
}

- (void) generatePlane:(MDAbsObject3D*) object3D{
    int numPoint = sPlaneNumPoint;
    
    float* texcoords = [self generateTexcoords];
    float* vertexs = [self generateVertex];
    
    [object3D setTextureBuffer:texcoords size: 2 * numPoint]; //object3D.setTexCoordinateBuffer(texBuffer);
    [object3D setVertexBuffer:vertexs size: 3 * numPoint]; //object3D.setVerticesBuffer(vertexBuffer);
    [object3D setNumIndices:numPoint];
    
    
    free(texcoords);
    free(vertexs);
}

- (float*) generateVertex{
    int numPoint = sPlaneNumPoint;
    int z = -2;
    
    [self.mCalculator calculate];
    mPrevRatio = [self.mCalculator getTextureRatio];
    float width = [self.mCalculator getTextureWidth];
    float height = [self.mCalculator getTextureHeight];
    
    float* vertexs = malloc ( sizeof(float) * 3 * numPoint );
    int i = 0;
    vertexs[i*3] = width;
    vertexs[i*3 + 1] = -height;
    vertexs[i*3 + 2] = z;
    i++;
    
    vertexs[i*3] = -width;
    vertexs[i*3 + 1] = height;
    vertexs[i*3 + 2] = z;
    i++;
    
    vertexs[i*3] = -width;
    vertexs[i*3 + 1] = -height;
    vertexs[i*3 + 2] = z;
    i++;
    
    vertexs[i*3] = width;
    vertexs[i*3 + 1] = -height;
    vertexs[i*3 + 2] = z;
    i++;
    
    vertexs[i*3] = width;
    vertexs[i*3 + 1] = height;
    vertexs[i*3 + 2] = z;
    i++;
    
    vertexs[i*3] = -width;
    vertexs[i*3 + 1] = height;
    vertexs[i*3 + 2] = z;
    i++;
    
    return vertexs;
    
}

-(float*) generateTexcoords{
    int numPoint = sPlaneNumPoint;
    float* texcoords = malloc ( sizeof(float) * 2 * numPoint );
    
    int i = 0;
    texcoords[i*2] = 1;
    texcoords[i*2 + 1] = 1;
    i++;
    
    texcoords[i*2] = 0;
    texcoords[i*2 + 1] = 0;
    i++;
    
    texcoords[i*2] = 0;
    texcoords[i*2 + 1] = 1;
    i++;
    
    texcoords[i*2] = 1;
    texcoords[i*2 + 1] = 1;
    i++;
    
    texcoords[i*2] = 1;
    texcoords[i*2 + 1] = 0;
    i++;
    
    texcoords[i*2] = 0;
    texcoords[i*2 + 1] = 0;
    i++;
    
    return texcoords;
}

@end
