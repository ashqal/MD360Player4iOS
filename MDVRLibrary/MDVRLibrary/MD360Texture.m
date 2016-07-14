//
//  MD360Surface.m
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/7.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "MD360Texture.h"
#import "GLUtil.h"
#import "MDVideoDataAdatperAVPlayerImpl.h"
#import <CoreVideo/CVOpenGLESTextureCache.h>

@interface MD360Texture(){
    GLuint glTextureId;
}

@end
@implementation MD360Texture

- (void) createCommitter:(EAGLContext*)context{
    self.committer = [[MDTextureCommitter alloc] init];
    [self.committer setup:context];
}

- (void) createTexture:(EAGLContext*)context program:(MD360Program*) program{
    [self createCommitter:context];
    self.program = program;
}

- (void) destroy {}

- (void) resizeViewport:(int)width height:(int)height{
    [self.sizeContext updateViewportWidth:width height:height];
}

- (BOOL) updateTexture:(EAGLContext*)context{
    return NO;
}

- (void)dealloc {
}

@end