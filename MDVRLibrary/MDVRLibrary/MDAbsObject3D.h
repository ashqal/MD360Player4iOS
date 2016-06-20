//
//  MDAbsObject3D.h
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/6.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MD360Program.h"
#import "MDVRHeader.h"

@protocol MDAbsObject3DDelegate<NSObject>
@optional
-(NSString*) obtainObjPath;
@end

@interface MDAbsObject3D : NSObject<MDAbsObject3DDelegate,IMDDestroyable> {
    float* mVertexBuffer;
    float* mTextureBuffer;
    short* mIndicesBuffer;
    int mVertexSize;
    int mTextureSize;
}
@property (nonatomic,readonly) int mNumIndices;

- (void)setVertexBuffer:(float*)buffer size:(int)size;
- (void)setTextureBuffer:(float*)buffer size:(int)size;
- (void)setIndicesBuffer:(short*)buffer size:(int)size;
- (void)setNumIndices:(int)value;
- (void)onDraw;
- (void)loadObj;
- (void)uploadDataToProgram:(MD360Program*)program;

- (short*) getIndices;

@end

#pragma mark MDSphere3D48
@interface MDSphere3D48 : MDAbsObject3D

@end

#pragma mark MDSphere3D
@interface MDSphere3D : MDAbsObject3D

@end

#pragma mark MDDome3D
@interface MDDome3D : MDAbsObject3D

@end

