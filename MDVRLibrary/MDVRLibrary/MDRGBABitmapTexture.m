//
//  MDRGBABitmapTexture.m
//  MDVRLibrary
//
//  Created by ashqal on 16/7/14.
//  Copyright © 2016年 asha. All rights reserved.
//

#import "MD360Texture.h"

#pragma mark MD360BitmapTexture

@interface MDRGBABitmapTexture()
@property (nonatomic) GLuint textureId;
@property(nonatomic,weak) id<IMDImageProvider> provider;
@end

@implementation MDRGBABitmapTexture

+ (MD360Texture*) createWithProvider:(id<IMDImageProvider>) provider{
    MDRGBABitmapTexture* texture = [[MDRGBABitmapTexture alloc]init];
    texture.provider = provider;
    return texture;
}

- (void) load {
    if ([self.provider respondsToSelector:@selector(onProvideImage:)]) {
        [self.provider onProvideImage:self];
    }
}

- (void) createTexture:(EAGLContext*)context program:(MD360Program*) program{
    [super createTexture:context program:program];
    if (context == NULL) return;
    
    self.textureId = [self createTextureId];
    [self load];
    
}

- (GLuint) createTextureId {
    GLuint textureId;
    glActiveTexture(GL_TEXTURE0);
    glGenTextures(1, &textureId);
    return textureId;
}

- (BOOL) updateTexture:(EAGLContext*)context{
    return YES;
}

-(void) texture:(UIImage*)image{
    
    if (image == nil) {
        return;
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        
        [self beginCommit];
        
        // Bind to the texture in OpenGL
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, self.textureId);
        
        
        // Set filtering
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        
        // for not mipmap
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        // Load the bitmap into the bound texture.
        [GLUtil texImage2D:image];
        
        glUniform1i(self.program.mTextureUniformHandle[0], 0);
        
        GLuint width = (GLuint)CGImageGetWidth(image.CGImage);
        GLuint height = (GLuint)CGImageGetHeight(image.CGImage);
        [self.sizeContext updateTextureWidth:width height:height];
        
        [self postCommit];
    });
}

@end
