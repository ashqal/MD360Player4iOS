//
//  MDAbsObject3D.m
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/6.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "MDAbsObject3D.h"
#import "GLUtil.h"

static int sPositionDataSize = 3;
@implementation MDAbsObject3D


- (void) destroy {
    if (mVertexBuffer != NULL)  free(mVertexBuffer);
    if (mTextureBuffer != NULL)  free(mTextureBuffer);
}

- (void)setVertexBuffer:(float*)buffer size:(int)size{
    int size_t = sizeof(float)*size;
    mVertexBuffer = malloc(size_t);
    memcpy(mVertexBuffer, buffer, size_t);
}

- (void)setIndicesBuffer:(short *)buffer size:(int)size{
    int size_t = sizeof(short)*size;
    mIndicesBuffer = malloc(size_t);
    memcpy(mIndicesBuffer, buffer, size_t);
}

- (short*) getIndices{
    return mIndicesBuffer;
}

- (void)setTextureBuffer:(float*)buffer size:(int)size{
    int size_t = sizeof(float)*size;
    mTextureBuffer = malloc(size_t);
    memcpy(mTextureBuffer, buffer, size_t);
}

- (void)setNumIndices:(int)value{
    _mNumIndices = value;
}

- (void)loadObj{
    NSString* obj3dPath = [self obtainObjPath];
    if (obj3dPath == nil) {
        NSLog(@"obj3dPath can't be null");
        return;
    }
    [GLUtil loadObject3DWithPath:obj3dPath output:self];
    //[GLUtil loadObject3DMock:self];
}


- (void)uploadDataToProgram:(MD360Program*)program{
    
    
    int positionHandle = program.mPositionHandle;
    glVertexAttribPointer(positionHandle, sPositionDataSize, GL_FLOAT, 0, 0, mVertexBuffer);
    glEnableVertexAttribArray(positionHandle);
    
    int textureCoordinateHandle = program.mTextureCoordinateHandle;
    glVertexAttribPointer(textureCoordinateHandle, 2, GL_FLOAT, 0, 0, mTextureBuffer);
    glEnableVertexAttribArray(textureCoordinateHandle);
    
    //int vertexIndicesBufferID = 0;
    
    //Indices
//    glGenBuffers(1, &vertexIndicesBufferID);
//    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vertexIndicesBufferID);
//    glBufferData(GL_ELEMENT_ARRAY_BUFFER,
//                 sizeof(GLushort) * self.mNumIndices,
//                 mIndicesBuffer, GL_STATIC_DRAW);
}

-(NSString *)description{

    NSMutableString* vertexSB = [[NSMutableString alloc]init];
    for (int i = 0; i < self.mNumIndices * 3; i++) {
        [vertexSB appendFormat:@"%f ",mVertexBuffer[i]];
    }
    NSMutableString* textureSB = [[NSMutableString alloc]init];
    for (int i = 0; i < self.mNumIndices * 2; i++) {
        [textureSB appendFormat:@"%f ",mTextureBuffer[i]];
    }
    NSString* result = [NSString stringWithFormat:@"loadObject3D complete:\n %@\n\n %@\n\n %d\n\n",vertexSB,textureSB,self.mNumIndices];
    return result;
}
@end

#pragma mark MDSphere3D48
@implementation MDSphere3D48

-(NSString*) obtainObjPath{
    //return [MDVR_RAW pathForResource:@"sphere48" ofType:@"obj"];
    return nil;
}

@end

#pragma mark MDSphere3D
@implementation MDSphere3D

-(NSString*) obtainObjPath{
    return nil;
}

- (void)loadObj{
    generateSphere(18,75,150,self);
}

#define ES_PI  (3.14159265f)

void generateSphere(float radius, int rings, int sectors, MDAbsObject3D* object3D) {
    float PI = ES_PI;
    float PI_2 = ES_PI / 2;
    float R = 1.0f/(float)(rings-1);
    float S = 1.0f/(float)(sectors-1);
    short r, s;
    float x, y, z;
    
    int numPoints = rings * sectors * 3;
    int numNormals = rings * sectors * 3;
    int numTexcoords = rings * sectors * 2;
    
    float* points = malloc ( sizeof(float) *  numPoints); //new float[rings * sectors * 3];
    float* normals = malloc ( sizeof(float) * numNormals);//new float[rings * sectors * 3];
    float* texcoords = malloc ( sizeof(float) *  numTexcoords);//new float[rings * sectors * 2];
    
    int t = 0, v = 0, n = 0;
    for(r = 0; r < rings; r++) {
        for(s = 0; s < sectors; s++) {
            x = (float) (cosf(2*PI * s * S) * sinf( PI * r * R ));
            y = (float) sinf( -PI_2 + PI * r * R );
            z = (float) (sinf(2*PI * s * S) * sinf( PI * r * R ));
            
            texcoords[t++] = s*S;
            texcoords[t++] = r*R;
            
            points[v++] = x * radius;
            points[v++] = - y * radius;
            points[v++] = z * radius;
            
            normals[n++] = x;
            normals[n++] = y;
            normals[n++] = z;
        }
        
        
    }
    int counter = 0;
    int numIndices = rings * sectors * 6;
    short* indices = malloc ( sizeof(short) * numIndices );//new short[rings * sectors * 6];
    for(r = 0; r < rings - 1; r++){
        for(s = 0; s < sectors-1; s++) {
            indices[counter++] = (short) (r * sectors + s);       //(a)
            indices[counter++] = (short) ((r+1) * sectors + (s));    //(b)
            indices[counter++] = (short) ((r+1) * sectors + (s+1));  // (c)
            indices[counter++] = (short) ((r) * sectors + (s));  // (a)
            indices[counter++] = (short) ((r) * sectors + (s+1));     //(d)
            indices[counter++] = (short) ((r+1) * sectors + (s+1));    //(c)
            
        }
    }
    
    [object3D setIndicesBuffer:indices size:numIndices]; //object3D.setIndicesBuffer(indexBuffer);
    [object3D setTextureBuffer:texcoords size:numTexcoords]; //object3D.setTexCoordinateBuffer(texBuffer);
    [object3D setVertexBuffer:points size:numPoints]; //object3D.setVerticesBuffer(vertexBuffer);
    [object3D setNumIndices:numIndices];
    
    free(indices);
    free(texcoords);
    free(points);
}

#pragma mark generate sphere

int esGenSphere ( int numSlices, float radius, float **vertices, float **normals,
                 float **texCoords, uint16_t **indices, int *numVertices_out) {
    int i;
    int j;
    int numParallels = numSlices / 2;
    int numVertices = ( numParallels + 1 ) * ( numSlices + 1 );
    int numIndices = numParallels * numSlices * 6;
    float angleStep = (2.0f * ES_PI) / ((float) numSlices);
    
    if ( vertices != NULL )
        *vertices = malloc ( sizeof(float) * 3 * numVertices );
    
    if ( texCoords != NULL )
        *texCoords = malloc ( sizeof(float) * 2 * numVertices );
    
    if ( indices != NULL )
        *indices = malloc ( sizeof(uint16_t) * numIndices );
    
    for ( i = 0; i < numParallels + 1; i++ ) {
        for ( j = 0; j < numSlices + 1; j++ ) {
            int vertex = ( i * (numSlices + 1) + j ) * 3;
            
            if ( vertices ) {
                (*vertices)[vertex + 0] = radius * sinf ( angleStep * (float)i ) * sinf ( angleStep * (float)j );
                (*vertices)[vertex + 1] = radius * cosf ( angleStep * (float)i );
                (*vertices)[vertex + 2] = radius * sinf ( angleStep * (float)i ) * cosf ( angleStep * (float)j );
                //NSLog(@"%f,%f,%f,step=%f",(*vertices)[vertex + 0],(*vertices)[vertex + 1],(*vertices)[vertex + 2],angleStep * (float)i);
                
            }
            
            if (texCoords) {
                int texIndex = ( i * (numSlices + 1) + j ) * 2;
                (*texCoords)[texIndex + 0] = (float) j / (float) numSlices;
                (*texCoords)[texIndex + 1] = 1.0f - ((float) i / (float) (numParallels));
            }
        }
    }
    
    // Generate the indices
    if ( indices != NULL ) {
        uint16_t *indexBuf = (*indices);
        for ( i = 0; i < numParallels ; i++ ) {
            for ( j = 0; j < numSlices; j++ ) {
                *indexBuf++  = i * ( numSlices + 1 ) + j;
                *indexBuf++ = ( i + 1 ) * ( numSlices + 1 ) + j;
                *indexBuf++ = ( i + 1 ) * ( numSlices + 1 ) + ( j + 1 );
                
                *indexBuf++ = i * ( numSlices + 1 ) + j;
                *indexBuf++ = ( i + 1 ) * ( numSlices + 1 ) + ( j + 1 );
                *indexBuf++ = i * ( numSlices + 1 ) + ( j + 1 );
                
            }
        }
        
    }
   
    if (numVertices_out) {
        *numVertices_out = numVertices;
    }
    
    return numIndices;
}

@end
