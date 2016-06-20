//
//  MD360Surface.h
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/7.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLUtil.h"
#import "MDVideoDataAdapter.h"
#import "MDVRHeader.h"


@interface MD360Texture : NSObject<IMDDestroyable>

@property (nonatomic,readonly) int mWidth;
@property (nonatomic,readonly) int mHeight;

- (void) createTexture:(EAGLContext*)context;
- (void) resize:(int)width height:(int)height;
- (BOOL) updateTexture:(EAGLContext*)context;
@end

@interface MD360BitmapTexture : MD360Texture<TextureCallback>
+ (MD360Texture*) createWithProvider:(id<IMDImageProvider>) provider;
@end

@interface MD360VideoTexture : MD360Texture
+ (MD360Texture*) createWithDataAdapter:(id<MDVideoDataAdapter>) adapter;
@end
