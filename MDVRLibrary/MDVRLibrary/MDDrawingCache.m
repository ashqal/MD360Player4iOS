//
//  MDDrawingCache.m
//  MDVRLibrary
//
//  Created by Asha on 2017/7/2.
//  Copyright © 2017年 asha. All rights reserved.
//

#import "MDDrawingCache.h"
#import "GLUtil.h"

@interface MDDrawingCache()
@property (nonatomic) int width;
@property (nonatomic) int height;
@property (nonatomic) GLuint* mTextureIdOutput;
@property (nonatomic) GLuint* mFrameBufferId;
@property (nonatomic) GLuint* mRenderBufferId;
@property (nonatomic) GLint mOriginalFrameBufferId;

@end

@implementation MDDrawingCache

- (void)dealloc
{
    if (self.mTextureIdOutput != 0) {
        glDeleteTextures(1, self.mTextureIdOutput);
        free(self.mTextureIdOutput);
    }
    
    if (self.mRenderBufferId != 0) {
        glDeleteRenderbuffers(1, self.mRenderBufferId);
        free(self.mRenderBufferId);
    }
    
    if (self.mFrameBufferId != 0) {
        glDeleteFramebuffers(1, self.mFrameBufferId);
        free(self.mFrameBufferId);
    }
    
}

-(void) bindTotalWidth:(int)w totalHeight:(int)h
{
    [self setupTotalWidth:w totalHeight:h];
    
    GLint orignialFrameBufferId[1];
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, orignialFrameBufferId);
    self.mOriginalFrameBufferId = orignialFrameBufferId[0];
    
    glBindFramebuffer(GL_FRAMEBUFFER, self.mFrameBufferId[0]);
}

-(void) unbind
{
    glBindFramebuffer(GL_FRAMEBUFFER, self.mOriginalFrameBufferId);
}

-(GLuint) getTextureOutput
{
    return self.mTextureIdOutput[0];
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
    if (self.mTextureIdOutput != 0) {
        glDeleteTextures(1, self.mTextureIdOutput);
    }
    
    if (self.mRenderBufferId != 0) {
        glDeleteRenderbuffers(1, self.mRenderBufferId);
    }
    
    if (self.mFrameBufferId != 0) {
        glDeleteFramebuffers(1, self.mFrameBufferId);
    }
    
    GLint orignialFrameBufferId[1];
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, orignialFrameBufferId);
    self.mOriginalFrameBufferId = orignialFrameBufferId[0];
    
    //
    glGenFramebuffers(1, self.mFrameBufferId);
    glBindFramebuffer(GL_FRAMEBUFFER, self.mFrameBufferId[0]);
    [GLUtil glCheck:@"Multi Fish Eye frame buffer"];
    
    // renderer buffer
    glGenRenderbuffers(1, self.mRenderBufferId);
    glBindRenderbuffer(GL_RENDERBUFFER, self.mRenderBufferId[0]);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, w, h);
    [GLUtil glCheck:@"Multi Fish Eye renderer buffer"];
    
    glGenTextures(1, self.mTextureIdOutput);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, self.mTextureIdOutput[0]);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, w, h, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
    [GLUtil glCheck:@"Multi Fish Eye texture"];
    
    // attach
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, self.mTextureIdOutput[0], 0);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, self.mRenderBufferId[0]);
    [GLUtil glCheck:@"Multi Fish Eye attach"];
    
    // check
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"Framebuffer is not complete: %d", status);
    }
    
    glBindFramebuffer(GL_FRAMEBUFFER, self.mOriginalFrameBufferId);
    [GLUtil glCheck:@"Multi Fish Eye restore"];
}
@end
