//
//  MDDome3D.m
//  MDVRLibrary
//
//  Created by ashqal on 16/7/2.
//  Copyright © 2016年 asha. All rights reserved.
//

#import "MDAbsObject3D.h"

@interface MDDome3D(){
    float mDegree;
    BOOL mIsUpper;
    float prevRatio;
    float* pTexCoordinateBuffer;
    int numVertices;
}

@property (nonatomic,weak) MDSizeContext* sizeContext;

@end

@implementation MDDome3D

- (void) destroy{
    free(pTexCoordinateBuffer);
}

- (instancetype)initWithSizeContext:(MDSizeContext*) sizeContext degree:(float) degree isUpper:(BOOL) isUpper{
    self = [super init];
    if (self) {
        self.sizeContext = sizeContext;
        self->mDegree = degree;
        self->mIsUpper = isUpper;
        self->prevRatio = 1.0f;
    }
    return self;
}

- (void) uploadTexCoordinateBufferIfNeed:(MD360Program *)program index:(int)index{
    if ([super getTextureBuffer:index] == nil) {
        return;
    }

    if (index == 0) {
        float ratio = [self.sizeContext getTextureRatioValue];
        if (ratio != prevRatio) {
            
            float* superBuffer = pTexCoordinateBuffer;
            float* scaledTexCoordinateBuffer = [super getTextureBuffer:index];
            for (int i = 0; i < numVertices; i += 2){
                scaledTexCoordinateBuffer[i] = (superBuffer[i] - 0.5f)/ratio + 0.5f;
                scaledTexCoordinateBuffer[i+1] = superBuffer[i + 1];
            }
            self->prevRatio = ratio;
        }

    }
    
    [super uploadTexCoordinateBufferIfNeed:program index:index];
}

- (void) executeLoad {
    [MDDome3D generateDome:18 numSlices:128 object3D:self];
}

#define ES_PI  (3.14159265f)

#pragma mark generate sphere
+(int) generateDome:(float)radius numSlices:(int)numSlices object3D:(MDDome3D*)object3D {
    int i;
    int j;
    float percent = object3D->mDegree / 360.0f;
    int numParallels = numSlices >> 1;
    int numVertices = ( numParallels + 1 ) * ( numSlices + 1 );
    int numParallelActual = numParallels * percent;
    int numIndices = numParallelActual * numSlices * 6;
    float angleStep = (2.0f * ES_PI) / ((float) numSlices);
    
    float* vertices = malloc ( sizeof(float) * 3 * numVertices );
    float* texCoords = malloc ( sizeof(float) * 2 * numVertices );
    short* indices = malloc ( sizeof(short) * numIndices );
    
    int upper = object3D->mIsUpper ? 1 : -1;
    
    for ( i = 0; i < numParallelActual + 1; i++ ) {
        for ( j = 0; j < numSlices + 1; j++ ) {
            int vertex = ( i * (numSlices + 1) + j ) * 3;
            
            if ( vertices ) {
                vertices[vertex + 0] = radius * sinf ( angleStep * (float)i ) * sinf ( angleStep * (float)j ) * upper;
                vertices[vertex + 1] = radius * sinf ( ES_PI/2 + angleStep * (float)i ) * upper;
                vertices[vertex + 2] = radius * sinf ( angleStep * (float)i ) * cosf ( angleStep * (float)j );
            }
            
            if (texCoords) {
                // (Math.cos( 2 * PI * s * S) * r * R / percent)/2.0f + 0.5f;
                int texIndex = ( i * (numSlices + 1) + j ) * 2;
                float a = cosf((float) j * angleStep) * (float)i / (numParallels + 1) / percent * 0.5f + 0.5f;
                float b = sinf((float) j * angleStep) * (float)i / (numParallels + 1) / percent * 0.5f + 0.5f;
                
                texCoords[texIndex + 0] = b;
                texCoords[texIndex + 1] = a;
            }
        }
    }
    
    // Generate the indices
    if ( indices != NULL ) {
        short* indexBuf = indices;
        for ( i = 0; i < numParallelActual ; i++ ) {
            for ( j = 0; j < numSlices; j++ ) {
                *indexBuf++ = (short)(i * ( numSlices + 1 ) + j); // a
                *indexBuf++ = (short)(( i + 1 ) * ( numSlices + 1 ) + j); // b
                *indexBuf++ = (short)(( i + 1 ) * ( numSlices + 1 ) + ( j + 1 )); // c
                *indexBuf++ = (short)(i * ( numSlices + 1 ) + j); // a
                *indexBuf++ = (short)(( i + 1 ) * ( numSlices + 1 ) + ( j + 1 )); // c
                *indexBuf++ = (short)(i * ( numSlices + 1 ) + ( j + 1 )); // d
                
            }
        }
        
    }
    object3D->numVertices = numVertices;
    [object3D setIndicesBuffer:indices size:numIndices]; //object3D.setIndicesBuffer(indexBuffer);
    [object3D setTextureIndex:0 buffer:texCoords size: 2 * numVertices]; //object3D.setTexCoordinateBuffer(texBuffer);
    [object3D setVertexIndex:0 buffer:vertices size: 3 * numVertices]; //object3D.setVerticesBuffer(vertexBuffer);
    [object3D setNumIndices:numIndices];
    
    object3D->pTexCoordinateBuffer = texCoords;
    
    free(indices);
    // free(texCoords);
    free(vertices);
    
    return numIndices;
}

@end
