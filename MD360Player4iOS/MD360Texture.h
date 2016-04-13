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
#import "MDVRLibrary.h"

@protocol IMD360Texture <NSObject>
@optional
- (void) onTextureCreated:(GLuint)textureId;
- (GLuint) createTextureId;
@end

@interface MD360Texture : NSObject<IMD360Texture,IMDDestroyable>

@property (nonatomic,readonly) int mWidth;
@property (nonatomic,readonly) int mHeight;

- (void) createTexture;
- (void) resize:(int)width height:(int)height;
- (void) updateTexture:(EAGLContext*)context;
@end

@interface MD360BitmapTexture : MD360Texture

@end

@interface MD360VideoTexture : MD360Texture
+ (MD360Texture*) createWithAVPlayerItem:(AVPlayerItem*) playerItem;
@end
