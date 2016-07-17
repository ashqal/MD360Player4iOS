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
    BOOL mVerticesChanged;
    BOOL mTexCoordinateChanged;
    
    float* mVertexBuffer;
    float* mTextureBuffer;
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
    if (mVertexBuffer != NULL)  free(mVertexBuffer);
    if (mTextureBuffer != NULL)  free(mTextureBuffer);
    if (mIndicesBuffer != NULL) free(mIndicesBuffer);
    
    mVertexBuffer = NULL;
    mTextureBuffer = NULL;
    mIndicesBuffer = NULL;
}

- (float*)getVertexBuffer:(int)index{
    return mVertexBuffer;
}

- (float*)getTextureBuffer:(int)index{
    return mTextureBuffer;
}

- (void)setVertexBuffer:(float*)buffer size:(int)size{
    int size_t = sizeof(float)*size;
    mVertexBuffer = malloc(size_t);
    memcpy(mVertexBuffer, buffer, size_t);
}

- (void)setIndicesBuffer:(short *)buffer size:(int)size{
    int size_t = sizeof(short)*size;
    mIndicesBuffer = malloc(size_t);
    assert(mIndicesBuffer);
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

- (void)executeLoad{
    NSString* obj3dPath = [self obtainObjPath];
    if (obj3dPath == nil) {
        NSLog(@"obj3dPath can't be null");
        return;
    }
    [GLUtil loadObject3DWithPath:obj3dPath output:self];
    //[GLUtil loadObject3DMock:self];
}

- (void)markChanged{
    [self markVerticesChanged];
    [self markTexCoordinateChanged];
}

- (void)markVerticesChanged{
    mVerticesChanged = YES;
}

- (void)markTexCoordinateChanged{
    mTexCoordinateChanged = YES;
}

- (void)uploadVerticesBufferIfNeed:(MD360Program*) program index:(int)index{
    float* pointer = [self getVertexBuffer:index];
    if (pointer == NULL){
        glDisableVertexAttribArray(program.mPositionHandle);
    } else {
        if(mVerticesChanged){
            glEnableVertexAttribArray(program.mPositionHandle);
            glVertexAttribPointer(program.mPositionHandle, sPositionDataSize, GL_FLOAT, 0, 0, pointer);
            mVerticesChanged = NO;
        }
    }
    
    
}

- (void)uploadTexCoordinateBufferIfNeed:(MD360Program*) program index:(int)index{
    float* pointer = [self getTextureBuffer:index];
    if (pointer == NULL){
        glDisableVertexAttribArray(program.mTextureCoordinateHandle);
    } else {
        if(mTexCoordinateChanged){
            
            glEnableVertexAttribArray(program.mTextureCoordinateHandle);
            glVertexAttribPointer(program.mTextureCoordinateHandle, 2, GL_FLOAT, 0, 0, pointer);
            mTexCoordinateChanged = NO;
        }
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
