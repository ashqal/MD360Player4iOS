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
@interface MDAbsObject3D(){
    float* mVertexBuffer0;
    float* mTextureBuffer0;
    float* mVertexBuffer1;
    float* mTextureBuffer1;
    short* mIndicesBuffer;
    int mVertexSize;
    int mTextureSize;
}

@end
@implementation MDAbsObject3D

- (void)dealloc{
    [self destroy];
}

- (void) destroy {
    if (mVertexBuffer0 != NULL)  free(mVertexBuffer0);
    if (mTextureBuffer0 != NULL)  free(mTextureBuffer0);
    if (mVertexBuffer1 != NULL)  free(mVertexBuffer1);
    if (mTextureBuffer1 != NULL)  free(mTextureBuffer1);
    if (mIndicesBuffer != NULL) free(mIndicesBuffer);
    
    mVertexBuffer0 = NULL;
    mTextureBuffer0 = NULL;
    mVertexBuffer1 = NULL;
    mTextureBuffer1 = NULL;
    mIndicesBuffer = NULL;
}

- (float*)getVertexBuffer:(int)index{
    if(index == 1 && mVertexBuffer1 != NULL){
        return mVertexBuffer1;
    }
    return mVertexBuffer0;
}

- (float*)getTextureBuffer:(int)index{
    if(index == 1 && mTextureBuffer1 != NULL){
        return mTextureBuffer1;
    }
    return mTextureBuffer0;
}

- (void)setVertexIndex:(int)index buffer:(float*)buffer size:(int)size{
    float* ptr;
    int size_t = sizeof(float)*size;
    ptr = malloc(size_t);
    memcpy(ptr, buffer, size_t);
    
    if (index == 1) {
        mVertexBuffer1 = ptr;
    } else {
        mVertexBuffer0 = ptr;
    }
}

- (void)setTextureIndex:(int)index buffer:(float*)buffer size:(int)size{
    float* ptr;
    int size_t = sizeof(float)*size;
    ptr = malloc(size_t);
    memcpy(ptr, buffer, size_t);
    
    if (index == 1) {
        mTextureBuffer1 = ptr;
    } else {
        mTextureBuffer0 = ptr;
    }
}

- (void)setIndicesBuffer:(short*)buffer size:(int)size{
    int size_t = sizeof(short)*size;
    mIndicesBuffer = malloc(size_t);
    assert(mIndicesBuffer);
    memcpy(mIndicesBuffer, buffer, size_t);
}

- (short*) getIndices{
    return mIndicesBuffer;
}

- (void)setNumIndices:(int)value{
    _mNumIndices = value;
}

- (void)executeLoad{
    NSString* obj3dPath = [self obtainObjPath];
    if (obj3dPath == nil) {
        NSLog(@"obj3dPath can't be null");
        return;
    }
    [GLUtil loadObject3DWithPath:obj3dPath output:self];
    //[GLUtil loadObject3DMock:self];
}

- (void)uploadVerticesBufferIfNeed:(MD360Program*) program index:(int)index{
    float* pointer = [self getVertexBuffer:index];
    if (pointer == NULL){
        glDisableVertexAttribArray(program.mPositionHandle);
    } else {
        glEnableVertexAttribArray(program.mPositionHandle);
        glVertexAttribPointer(program.mPositionHandle, sPositionDataSize, GL_FLOAT, 0, 0, pointer);
    }
    
    
}

- (void)uploadTexCoordinateBufferIfNeed:(MD360Program*) program index:(int)index{
    float* pointer = [self getTextureBuffer:index];
    if (pointer == NULL){
        glDisableVertexAttribArray(program.mTextureCoordinateHandle);
    } else {
        glEnableVertexAttribArray(program.mTextureCoordinateHandle);
        glVertexAttribPointer(program.mTextureCoordinateHandle, 2, GL_FLOAT, 0, 0, pointer);
    }
    
}

- (void)onDraw{
    
    if ([self getIndices] != 0) {
        GLsizei count = self.mNumIndices;
        const GLvoid* indices = [self getIndices];
        glDrawElements(GL_TRIANGLE_STRIP, count, GL_UNSIGNED_SHORT, indices);
    } else {
        glDrawArrays(GL_TRIANGLES, 0, self.mNumIndices);
    }
    // Draw
    
    [GLUtil glCheck:@"glDrawArrays"];
}

@end
