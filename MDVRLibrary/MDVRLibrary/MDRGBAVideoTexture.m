//
//  MDRGBAVideoTexture.m
//  MDVRLibrary
//
//  Created by ashqal on 16/7/14.
//  Copyright © 2016年 asha. All rights reserved.
//

#import "MD360Texture.h"
#pragma mark MD360VideoTexture

@interface MDRGBAVideoTexture(){
    CVOpenGLESTextureCacheRef ref;
}

@property (nonatomic,strong) id<MDVideoDataAdapter> mDataAdatper;
@end

@implementation MDRGBAVideoTexture
//
- (instancetype)initWithAdatper: (id<MDVideoDataAdapter>)adapter {
    self = [super init];
    if (self) {
        self.mDataAdatper = adapter;
        ref = NULL;
    }
    return self;
}

- (void)dealloc{
    if (ref != NULL) {
        CFRelease(ref);
    }
    ref = NULL;
}

+ (MD360Texture*) createWithDataAdapter:(id<MDVideoDataAdapter>) adapter{
    MD360Texture* texture = [[MDRGBAVideoTexture alloc] initWithAdatper:adapter];
    return texture;
}

- (CVOpenGLESTextureCacheRef)textureCache:(EAGLContext*)context{
    if (ref == NULL){
        CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, (__bridge CVEAGLContext _Nonnull)((__bridge void *)context), NULL, &ref);
        if (err) NSAssert(NO, @"Error at CVOpenGLESTextureCacheCreate");
    }
    return ref;
}

- (BOOL) updateTexture:(EAGLContext*)context{
    if ([self.mDataAdatper respondsToSelector:@selector(copyPixelBuffer)]) {
        CVPixelBufferRef pixelBuffer = [self.mDataAdatper copyPixelBuffer];
        if (pixelBuffer == NULL) return YES;
        
        int bufferWidth = (int) CVPixelBufferGetWidth(pixelBuffer);
        int bufferHeight = (int) CVPixelBufferGetHeight(pixelBuffer);
        [self.sizeContext updateTextureWidth:bufferWidth height:bufferHeight];
        
        CVOpenGLESTextureCacheRef textureCache = [self textureCache:context];
        CVOpenGLESTextureRef texture = NULL;
        
        CVReturn err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, textureCache, pixelBuffer, NULL, GL_TEXTURE_2D, GL_RGBA, bufferWidth, bufferHeight, GL_BGRA, GL_UNSIGNED_BYTE, 0, &texture);
        
        if (texture == NULL || err){
            NSAssert(NO, @"Error at CVOpenGLESTextureCacheCreateTextureFromImage:%d",err);
        }
        
        int outputTexture = CVOpenGLESTextureGetName(texture);
        glBindTexture(GL_TEXTURE_2D, outputTexture);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        // Do processing work on the texture data here
        CVOpenGLESTextureCacheFlush(textureCache, 0);
        CVBufferRelease(pixelBuffer);
        CFRelease(texture);
        
        
        
        return YES;
    }
    return NO;
}

@end