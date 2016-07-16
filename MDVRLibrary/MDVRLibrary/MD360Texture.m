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

- (void) createTexture:(EAGLContext*)context program:(MD360Program*) program{
    self.context = context;
    self.program = program;
}

- (void) destroy {}

- (void) resizeViewport:(int)width height:(int)height{
    [self.sizeContext updateViewportWidth:width height:height];
}

- (BOOL) updateTexture:(EAGLContext*)context{
    return NO;
}

- (BOOL) beginCommit{
    if (self.context) {
        if( self.context == [EAGLContext currentContext]){
            return YES;
        }
        if ([EAGLContext setCurrentContext:self.context]){
            return YES;
        }
    }
    return NO;
}

- (void) postCommit{
    // nop
}

- (void)dealloc {
}

@end