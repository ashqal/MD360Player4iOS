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

- (void) createTexture:(EAGLContext*)context{}

- (void) destroy {}

- (void) resize:(int)width height:(int)height{
    _mWidth = width;
    _mHeight = height;
}

- (BOOL) updateTexture:(EAGLContext*)context{
    return NO;
}

- (void)dealloc {
}

@end

#pragma mark MD360BitmapTexture

@interface MD360BitmapTexture()
@property(nonatomic,strong) UIImage* pendingImage;
@property (nonatomic) GLuint textureId;
@property(nonatomic,weak) id<IMDImageProvider> provider;
@end
@implementation MD360BitmapTexture


+ (MD360Texture*) createWithProvider:(id<IMDImageProvider>) provider{
    MD360BitmapTexture* texture = [[MD360BitmapTexture alloc]init];
    texture.provider = provider;
    [texture load];
    return texture;
}

- (void)load {

    if ([self.provider respondsToSelector:@selector(onProvideImage:)]) {
        [self.provider onProvideImage:self];
    }
}

- (void) createTexture:(EAGLContext*)context{
    if (context == NULL) return;
    
    self.textureId = [self createTextureId];
}

- (GLuint) createTextureId {
    GLuint textureId;
    glActiveTexture(GL_TEXTURE0);
    glGenTextures(1, &textureId);
    return textureId;
}

- (BOOL) updateTexture:(EAGLContext*)context{
    if (context == NULL) return NO;
    if (self.pendingImage != nil) {
        [self textureInThread:self.textureId];
    }
    
    return YES;
    
}

- (void) textureInThread:(int)textureId {
    if (self.pendingImage == nil) return;
    
    // Bind to the texture in OpenGL
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, textureId);
    
    
    // Set filtering
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    
    // for not mipmap
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    // Load the bitmap into the bound texture.
    [GLUtil texImage2D:self.pendingImage];
    
    self.pendingImage = nil;
}


-(void) texture:(UIImage*)image{
    NSLog(@"texture:%@",image);
    if(image == nil) return;
    self.pendingImage = image;
}

@end

#pragma mark MD360VideoTexture
@interface MD360VideoTexture(){
    CVOpenGLESTextureCacheRef ref;
}

@property (nonatomic,strong) id<MDVideoDataAdapter> mDataAdatper;
@end

@implementation MD360VideoTexture
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
    MD360Texture* texture = [[MD360VideoTexture alloc] initWithAdatper:adapter];
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
        if (pixelBuffer == NULL) return NO;
        
        int bufferHeight = (int) CVPixelBufferGetHeight(pixelBuffer);
        int bufferWidth = (int) CVPixelBufferGetWidth(pixelBuffer);
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
