//
//  MDDrawingCache.m
//  MDVRLibrary
//
//  Created by Asha on 2017/7/2.
//  Copyright © 2017年 asha. All rights reserved.
//

#import "MDDrawingCache.h"
#import "GLUtil.h"

@interface MDDrawingCache(){
    GLuint mTextureIdOutput;
    GLuint mFrameBufferId;
    GLuint mRenderBufferId;
    GLint mOriginalFrameBufferId;
}
@property (nonatomic) int width;
@property (nonatomic) int height;


@end

@implementation MDDrawingCache

- (void)dealloc
{
    if (mTextureIdOutput != 0) {
        glDeleteTextures(1, &mTextureIdOutput);
    }
    
    if (mRenderBufferId != 0) {
        glDeleteRenderbuffers(1, &mRenderBufferId);
    }
    
    if (mFrameBufferId != 0) {
        glDeleteFramebuffers(1, &mFrameBufferId);
    }
    
}

-(void) bindTotalWidth:(int)w totalHeight:(int)h
{
    [self setupTotalWidth:w totalHeight:h];
    
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &mOriginalFrameBufferId);
    glBindFramebuffer(GL_FRAMEBUFFER, mFrameBufferId);
    
    // NSLog(@"bind:%d", mFrameBufferId);
}

-(void) unbind
{
    glBindFramebuffer(GL_FRAMEBUFFER, mOriginalFrameBufferId);
    // NSLog(@"bind:%d", mOriginalFrameBufferId);
}

-(GLuint) getTextureOutput
{
    return mTextureIdOutput;
}

-(void) setupTotalWidth:(int)w totalHeight:(int)h
{
    if (self.width != w || self.height != h) {
        self.width = w;
        self.height = h;
        [self createFrameBufferWidth:w height:h];
    }
}

-(void) createFrameBufferWidth:(int)w height:(int)h
{
    if (mTextureIdOutput != 0) {
        glDeleteTextures(1, &mTextureIdOutput);
    }
    
    if (mRenderBufferId != 0) {
        glDeleteRenderbuffers(1, &mRenderBufferId);
    }
    
    if (mFrameBufferId != 0) {
        glDeleteFramebuffers(1, &mFrameBufferId);
    }
    
    
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &mOriginalFrameBufferId);
    
    //
    
    glGenFramebuffers(1, &mFrameBufferId);
    glBindFramebuffer(GL_FRAMEBUFFER, mFrameBufferId);
    [GLUtil glCheck:@"Multi Fish Eye frame buffer"];
    
    // renderer buffer
    glGenRenderbuffers(1, &mRenderBufferId);
    glBindRenderbuffer(GL_RENDERBUFFER, mRenderBufferId);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, w, h);
    [GLUtil glCheck:@"Multi Fish Eye renderer buffer"];
    
    glActiveTexture(GL_TEXTURE0);
    glGenTextures(1, &mTextureIdOutput);
    glBindTexture(GL_TEXTURE_2D, mTextureIdOutput);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, w, h, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
    [GLUtil glCheck:@"Multi Fish Eye texture"];
    
    // attach
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, mTextureIdOutput, 0);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, mRenderBufferId);
    [GLUtil glCheck:@"Multi Fish Eye attach"];
    
    // check
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"Framebuffer is not complete: %d", status);
    }
    
    glBindFramebuffer(GL_FRAMEBUFFER, mOriginalFrameBufferId);
    [GLUtil glCheck:@"Multi Fish Eye restore"];
}
@end
