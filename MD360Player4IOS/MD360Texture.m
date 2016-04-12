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

- (void) createTexture {
    // check the createTextureId function
    if (![self respondsToSelector:@selector(createTextureId)]) return;
    
    glTextureId = [self createTextureId];
    if (glTextureId != 0 && [self respondsToSelector:@selector(onTextureCreated:)]) {
        [self onTextureCreated:glTextureId];
    }
}

- (void) releaseTexture {
    
}

- (void) resize:(int)width height:(int)height{
    _mWidth = width;
    _mHeight = height;
}

- (void) updateTexture:(EAGLContext*)context{

}

@end

#pragma mark MD360BitmapTexture
@implementation MD360BitmapTexture

- (GLuint) createTextureId {
    GLuint textureId;
    glActiveTexture(GL_TEXTURE0);
    glGenTextures(1, &textureId);
    return textureId;
}

- (void) onTextureCreated:(GLuint)textureId{
    [self textureInThread:textureId];
}

- (void) textureInThread:(int)textureId {
    // Bind to the texture in OpenGL
    //GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, textureId);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, textureId);
    
    
    // Set filtering
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    
    // for not mipmap
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    NSString* path = [[NSBundle mainBundle]pathForResource:@"bitmap360" ofType:@"png"];
    
    // Load the bitmap into the bound texture.
    [GLUtil texImage2D:path];
}

@end

#pragma mark MD360VideoTexture
@interface MD360VideoTexture(){
}
@property (nonatomic,strong) NSMutableDictionary* mContextTextureMap;
@property (nonatomic,strong) id<MDVideoDataAdapter> mDataAdatper;
@end

@implementation MD360VideoTexture
//
- (instancetype)initWithAdatper: (id<MDVideoDataAdapter>)adapter {
    self = [super init];
    if (self) {
        self.mDataAdatper = adapter;
        self.mContextTextureMap = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)dealloc{
    if (self.mContextTextureMap == nil) return;
    for (NSString* key in self.mContextTextureMap) {
        NSValue* value = [self.mContextTextureMap objectForKey:key];
        CVOpenGLESTextureCacheRef ref = [value pointerValue];
        CFRelease(ref);
    }
    self.mContextTextureMap = nil;
}

+ (MD360Texture*) createWithAVPlayerItem:(AVPlayerItem*) playerItem{
    MDVideoDataAdatperAVPlayerImpl* adapter = [[MDVideoDataAdatperAVPlayerImpl alloc]initWithPlayerItem:playerItem];
    MD360Texture* texture = [[MD360VideoTexture alloc] initWithAdatper:adapter];
    return texture;
}

- (CVOpenGLESTextureCacheRef)textureCache:(EAGLContext*)context{
    NSValue* value = [self.mContextTextureMap objectForKey:context.description];
    CVOpenGLESTextureCacheRef texture = [value pointerValue];
    if (texture == NULL){
        CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, (__bridge CVEAGLContext _Nonnull)((__bridge void *)context), NULL, &texture);
        if (err) NSAssert(NO, @"Error at CVOpenGLESTextureCacheCreate");
        [self.mContextTextureMap setObject:[NSValue valueWithPointer:texture] forKey:context.description];
    }
    return texture;
}

- (void) updateTexture:(EAGLContext*)context{
    if ([self.mDataAdatper respondsToSelector:@selector(copyPixelBuffer)]) {
        CVPixelBufferRef pixelBuffer = [self.mDataAdatper copyPixelBuffer];
        if (pixelBuffer == NULL) return;
        
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
        CFRelease(pixelBuffer);
        CFRelease(texture);
    }
}

@end
