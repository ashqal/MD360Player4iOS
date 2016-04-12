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

#pragma mark MDSphere3D
@implementation MDSphere3D

-(NSString*) obtainObjPath{
    return [[NSBundle mainBundle] pathForResource:@"sphere" ofType:@"obj"];
}

@end
