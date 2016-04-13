//
//  MDAbsObject3D.h
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/6.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MD360Program.h"
#import "MDVRLibrary.h"

@protocol MDAbsObject3DDelegate<NSObject>
@optional
-(NSString*) obtainObjPath;
@end

@interface MDAbsObject3D : NSObject<MDAbsObject3DDelegate,IMDDestroyable> {
    float* mVertexBuffer;
    float* mTextureBuffer;
}
@property (nonatomic,readonly) int mNumIndices;

- (void)setVertexBuffer:(float*)buffer size:(int)size;
- (void)setTextureBuffer:(float*)buffer size:(int)size;
- (void)setNumIndices:(int)value;
- (void)loadObj;
- (void)uploadDataToProgram:(MD360Program*)program;

@end

#pragma mark MDSphere3D
@interface MDSphere3D : MDAbsObject3D

@end
