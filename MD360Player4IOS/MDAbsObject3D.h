//
//  MDAbsObject3D.h
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/6.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MDAbsObject3DDelegate<NSObject>
@optional
-(NSString*) obtainObjPath;
@end

@interface MDAbsObject3D : NSObject<MDAbsObject3DDelegate> {
    float* mVertexBuffer;
    float* mTextureBuffer;
    int mNumIndices;
}

- (void)setVertexBuffer:(float*)buffer size:(int)size;
- (void)setTextureBuffer:(float*)buffer size:(int)size;
- (void)setNumIndices:(int)value;
- (void)loadObj;

@end

#pragma mark MDSphere3D
@interface MDSphere3D : MDAbsObject3D

@end
