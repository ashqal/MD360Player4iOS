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
#import "MDPlaneScaleCalculator.h"

@protocol MDAbsObject3DDelegate<NSObject>
@optional
-(NSString*) obtainObjPath;
@end

@interface MDAbsObject3D : NSObject<MDAbsObject3DDelegate,IMDDestroyable>

@property (nonatomic,readonly) int mNumIndices;

- (void)setVertexBuffer:(float*)buffer size:(int)size;
- (void)setTextureBuffer:(float*)buffer size:(int)size;
- (void)setIndicesBuffer:(short*)buffer size:(int)size;
- (float*)getVertexBuffer:(int)index;
- (float*)getTextureBuffer:(int)index;

- (void)setNumIndices:(int)value;
- (void)onDraw;
- (void)executeLoad;
- (void)uploadVerticesBufferIfNeed:(MD360Program*) program index:(int)index;
- (void)uploadTexCoordinateBufferIfNeed:(MD360Program*) program index:(int)index;
- (void)markChanged;
- (void)markVerticesChanged;
- (void)markTexCoordinateChanged;

- (short*) getIndices;

@end


#pragma mark MDSphere3D
@interface MDSphere3D : MDAbsObject3D

@end

#pragma mark MDStereoSphere3D
@interface MDStereoSphere3D : MDAbsObject3D

@end

@interface MDDome3D : MDAbsObject3D
- (instancetype)initWithSizeContext:(MDSizeContext*) sizeContext degree:(float) degree isUpper:(BOOL) isUpper;
@end

@interface MDPlane : MDAbsObject3D
- (instancetype)initWithCalculator:(MDPlaneScaleCalculator*) calculator;
@end


