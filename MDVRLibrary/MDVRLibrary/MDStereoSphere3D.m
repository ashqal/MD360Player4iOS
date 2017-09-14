//
//  MDStereoSphere3D.m
//  MDVRLibrary
//
//  Created by ashqal on 16/6/30.
//  Copyright © 2016年 asha. All rights reserved.
//

#import "MDAbsObject3D.h"

@interface MDStereoSphere3D()
@end

@implementation MDStereoSphere3D

-(NSString*) obtainObjPath{
    return nil;
}

- (void)executeLoad{
    [MDStereoSphere3D generateStereoSphere:18 numSlices:128 object3D:self];
}

#define ES_PI  (3.14159265f)

#pragma mark generate sphere
+ (int)generateStereoSphere:(float)radius numSlices:(int)numSlices object3D:(MDAbsObject3D*) object3D {
    int i;
    int j;
    int numParallels = numSlices / 2;
    int numVertices = ( numParallels + 1 ) * ( numSlices + 1 );
    int numIndices = numParallels * numSlices * 6;
    float angleStep = (2.0f * ES_PI) / ((float) numSlices);
    
    float* vertices = malloc ( sizeof(float) * 3 * numVertices );
    float* texCoords = malloc ( sizeof(float) * 2 * numVertices );
    float* texCoords2 = malloc ( sizeof(float) * 2 * numVertices );
    short* indices = malloc ( sizeof(short) * numIndices );
    
    
    for ( i = 0; i < numParallels + 1; i++ ) {
        for ( j = 0; j < numSlices + 1; j++ ) {
            int vertex = ( i * (numSlices + 1) + j ) * 3;
            
            if ( vertices ) {
                vertices[vertex + 0] = - radius * sinf ( angleStep * (float)i ) * sinf ( angleStep * (float)j );
                vertices[vertex + 1] = radius * sinf ( ES_PI/2 + angleStep * (float)i );
                vertices[vertex + 2] = radius * sinf ( angleStep * (float)i ) * cosf ( angleStep * (float)j );
            }
            
            // NSLog(@"%f %f %f",vertices[vertex + 0],vertices[vertex + 1],vertices[vertex + 2]);
            
            if (texCoords) {
                int texIndex = ( i * (numSlices + 1) + j ) * 2;
                texCoords[texIndex + 0] = (float) j / (float) numSlices;
                texCoords[texIndex + 1] = ((float) i / (float) (numParallels)) * 0.5f;
                
                texCoords2[texIndex + 0] = (float) j / (float) numSlices;
                texCoords2[texIndex + 1] = ((float) i / (float) (numParallels)) * 0.5f + 0.5f;
            }
        }
    }
    
    // Generate the indices
    if ( indices != NULL ) {
        short* indexBuf = indices;
        for ( i = 0; i < numParallels ; i++ ) {
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
    
    [object3D setIndicesBuffer:indices size:numIndices];
    [object3D setTextureIndex:0 buffer:texCoords size:2 * numVertices];
    [object3D setTextureIndex:1 buffer:texCoords2 size:2 * numVertices];
    [object3D setVertexIndex:0 buffer:vertices size: 3 * numVertices];
    [object3D setNumIndices:numIndices];
    
    
    free(indices);
    free(texCoords);
    free(vertices);
    
    return numIndices;
}
@end
