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
@property (nonatomic,weak) MDSizeContext* sizeContext;
@property (nonatomic,weak) EAGLContext* context;
@property (nonatomic,strong) MD360Program* program;

- (void) createTexture:(EAGLContext*)context program:(MD360Program*) program;
- (void) resizeViewport:(int)width height:(int)height;
- (BOOL) updateTexture:(EAGLContext*)context;

- (BOOL) beginCommit;
- (void) postCommit;
@end

@interface MDRGBABitmapTexture : MD360Texture<TextureCallback>
+ (MD360Texture*) createWithProvider:(id<IMDImageProvider>) provider;
@end

@interface MDRGBAVideoTexture : MD360Texture
+ (MD360Texture*) createWithDataAdapter:(id<MDVideoDataAdapter>) adapter;
@end

@interface MDYUV420PVideoTexture : MD360Texture
+ (MD360Texture*) createWithProvider:(id<IMDYUV420PProvider>) provider;
@end

@interface MDDirectlyTexture : MD360Texture

@end
