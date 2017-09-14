//
//  MDYUV420PVideoTexture.m
//  MDVRLibrary
//
//  Created by ashqal on 16/7/14.
//  Copyright © 2016年 asha. All rights reserved.
//

#import "MD360Texture.h"
#pragma mark MD360VideoTexture

#if SDL_BYTEORDER == SDL_LIL_ENDIAN
#   define SDL_FOURCC(a, b, c, d) \
(((uint32_t)a) | (((uint32_t)b) << 8) | (((uint32_t)c) << 16) | (((uint32_t)d) << 24))
#   define SDL_TWOCC(a, b) \
((uint16_t)(a) | ((uint16_t)(b) << 8))
#else
#   define SDL_FOURCC(a, b, c, d) \
(((uint32_t)d) | (((uint32_t)c) << 8) | (((uint32_t)b) << 16) | (((uint32_t)a) << 24))
#   define SDL_TWOCC( a, b ) \
((uint16_t)(b) | ((uint16_t)(a) << 8))
#endif

// YUV formats
#define SDL_FCC_YV12    SDL_FOURCC('Y', 'V', '1', '2')  /**< bpp=12, Planar mode: Y + V + U  (3 planes) */
#define SDL_FCC_IYUV    SDL_FOURCC('I', 'Y', 'U', 'V')  /**< bpp=12, Planar mode: Y + U + V  (3 planes) */
#define SDL_FCC_I420    SDL_FOURCC('I', '4', '2', '0')  /**< bpp=12, Planar mode: Y + U + V  (3 planes) */
#define SDL_FCC_I444P10LE   SDL_FOURCC('I', '4', 'A', 'L')

#define SDL_FCC_YUV2    SDL_FOURCC('Y', 'U', 'V', '2')  /**< bpp=16, Packed mode: Y0+U0+Y1+V0 (1 plane) */
#define SDL_FCC_UYVY    SDL_FOURCC('U', 'Y', 'V', 'Y')  /**< bpp=16, Packed mode: U0+Y0+V0+Y1 (1 plane) */
#define SDL_FCC_YVYU    SDL_FOURCC('Y', 'V', 'Y', 'U')  /**< bpp=16, Packed mode: Y0+V0+Y1+U0 (1 plane) */

#define SDL_FCC_NV12    SDL_FOURCC('N', 'V', '1', '2')

// RGB formats
#define SDL_FCC_RV16    SDL_FOURCC('R', 'V', '1', '6')    /**< bpp=16, RGB565 */
#define SDL_FCC_RV24    SDL_FOURCC('R', 'V', '2', '4')    /**< bpp=24, RGB888 */
#define SDL_FCC_RV32    SDL_FOURCC('R', 'V', '3', '2')    /**< bpp=32, RGBX8888 */

// opaque formats
#define SDL_FCC__AMC    SDL_FOURCC('_', 'A', 'M', 'C')    /**< Android MediaCodec */
#define SDL_FCC__VTB    SDL_FOURCC('_', 'V', 'T', 'B')    /**< iOS VideoToolbox */
#define SDL_FCC__GLES2  SDL_FOURCC('_', 'E', 'S', '2')    /**< let Vout choose format */

// undefine
#define SDL_FCC_UNDF    SDL_FOURCC('U', 'N', 'D', 'F')    /**< undefined */

const GLfloat *MD_IJK_GLES2_getColorMatrix_bt709();
const GLfloat *MD_IJK_GLES2_getColorMatrix_bt601();
@interface MDYUV420PVideoTexture()<YUV420PTextureCallback>
{
    float *mColorConversionMatrix;
}
@property (nonatomic,strong) id<IMDYUV420PProvider> mProvider;
@property (nonatomic) GLuint* textures;
@property (nonatomic) BOOL mRendererBegin;

@end


@implementation MDYUV420PVideoTexture
//

- (void)dealloc
{
    [self destroy];
    if (mColorAttachments != nil) {
        CFRelease(mColorAttachments);
        mColorAttachments = nil;
    }
}

- (instancetype)initWithProvider: (id<IMDYUV420PProvider>)provider {
    self = [super init];
    if (self) {
        self.mProvider = provider;
        self.mRendererBegin = NO;
    }
    return self;
}

- (void) createTexture:(EAGLContext*)context program:(MD360Program*) program{
    [super createTexture:context program:program];
    
    if (0 == self.textures){
        self.textures = malloc(sizeof(GLuint) * 3);
        glGenTextures(3, self.textures);
    }
    
    if ([self.mProvider respondsToSelector:@selector(onProvideBuffer:)]) {
        [self.mProvider onProvideBuffer:self];
    }
}


- (void)clearTexture
{
    if (mLumaTexture) {
        CFRelease(mLumaTexture);
        mLumaTexture = NULL;
    }
    
    if (mChromaTexture) {
        CFRelease(mChromaTexture);
        mChromaTexture = NULL;
    }
    CVOpenGLESTextureCacheFlush(mVideoTextureCache, 0);
}

- (void)bindTextureHardCodec:(CVPixelBufferRef)pixelBuffer
{
    if (pixelBuffer == NULL) {
        return;
    }
    if (mVideoTextureCache == NULL) {
        CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, [EAGLContext currentContext], NULL, &mVideoTextureCache);
        if (err != noErr) {
            //NSLog(@"Error at CVOpenGLESTextureCacheCreate %d", err);
            return;
        }
    }
    [self clearTexture];
    CFTypeRef color_attachments = CVBufferGetAttachment(pixelBuffer, kCVImageBufferYCbCrMatrixKey, NULL);
    //GLfloat *conversionMatrix = NULL;
    if (color_attachments != mColorAttachments) {
        if (mColorAttachments == nil) {
            //glUniformMatrix3fv(mShaderProgram.getUm3ColorConvertion(), 1, GL_FALSE, IJK_GLES2_getColorMatrix_bt709());
            glUniformMatrix3fv(self.program.mColorConversionHandle, 1, GL_FALSE,(const GLfloat*)MD_IJK_GLES2_getColorMatrix_bt709() );
            mColorConversionMatrix = (GLfloat*)MD_IJK_GLES2_getColorMatrix_bt709();
        } else if (mColorAttachments != nil && CFStringCompare((CFStringRef)color_attachments,(CFStringRef)mColorAttachments, 0) == kCFCompareEqualTo) {
            // remain prvious color attachment
        } else if (CFStringCompare((CFStringRef)color_attachments, kCVImageBufferYCbCrMatrix_ITU_R_709_2, 0) == kCFCompareEqualTo) {
            glUniformMatrix3fv(self.program.mColorConversionHandle, 1, GL_FALSE,(const GLfloat*)MD_IJK_GLES2_getColorMatrix_bt709() );
            mColorConversionMatrix = (GLfloat*)MD_IJK_GLES2_getColorMatrix_bt709();
        } else if (CFStringCompare((CFStringRef)color_attachments, kCVImageBufferYCbCrMatrix_ITU_R_601_4, 0) == kCFCompareEqualTo) {
            glUniformMatrix3fv(self.program.mColorConversionHandle, 1, GL_FALSE,(const GLfloat*)MD_IJK_GLES2_getColorMatrix_bt601() );
            mColorConversionMatrix = (GLfloat*)MD_IJK_GLES2_getColorMatrix_bt601();
        } else {
            glUniformMatrix3fv(self.program.mColorConversionHandle, 1, GL_FALSE,(const GLfloat*)MD_IJK_GLES2_getColorMatrix_bt709() );
            mColorConversionMatrix = (GLfloat*)MD_IJK_GLES2_getColorMatrix_bt709();
        }
        
        if (mColorAttachments != nil) {
            CFRelease(mColorAttachments);
            mColorAttachments = nil;
        }
        if (color_attachments != nil) {
            mColorAttachments = CFRetain(color_attachments);
        }
    }
    GLsizei  width  = (GLsizei)CVPixelBufferGetWidth(pixelBuffer);
    GLsizei  height = (GLsizei)CVPixelBufferGetHeight(pixelBuffer);
    CVReturn err;
    glActiveTexture(GL_TEXTURE0);
    err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                       mVideoTextureCache,
                                                       pixelBuffer,
                                                       NULL,
                                                       GL_TEXTURE_2D,
                                                       GL_RED_EXT,
                                                       width,
                                                       height,
                                                       GL_RED_EXT,
                                                       GL_UNSIGNED_BYTE,
                                                       0,
                                                       &mLumaTexture);
    if (err) {
        NSLog(@"Error at CVOpenGLESTextureCacheCreateTextureFromImage %d", err);
    }
    GLuint lumaTextureName = CVOpenGLESTextureGetName(mLumaTexture);
    glBindTexture(CVOpenGLESTextureGetTarget(mLumaTexture),  lumaTextureName);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    // UV-plane.
    glActiveTexture(GL_TEXTURE1);
    err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                       mVideoTextureCache,
                                                       pixelBuffer,
                                                       NULL,
                                                       GL_TEXTURE_2D,
                                                       GL_RG_EXT,
                                                       width/2,
                                                       height/2,
                                                       GL_RG_EXT,
                                                       GL_UNSIGNED_BYTE,
                                                       1,
                                                       &mChromaTexture);
    GLuint chromaTextureName = CVOpenGLESTextureGetName(mChromaTexture);
    glBindTexture(CVOpenGLESTextureGetTarget(mChromaTexture), chromaTextureName);
    
    if (err) {
        NSLog(@"Error at CVOpenGLESTextureCacheCreateTextureFromImage %d", err);
    }
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glBindTexture(GL_TEXTURE_2D, 0);
    if ([self.program conformsToProtocol:@protocol(MDYUV420PProgramHardCodecProtocol)]) {
        id<MDYUV420PProgramHardCodecProtocol>  hardCodecP = (id<MDYUV420PProgramHardCodecProtocol>)self.program;
        [hardCodecP switchHardCodec:YES];
        [hardCodecP setYTexture:lumaTextureName UVTexture:chromaTextureName colorConversionMatrix:mColorConversionMatrix];
    }
    
    
}

- (void) texture:(MDVideoFrame*)frame{
    dispatch_sync(dispatch_get_main_queue(), ^{
        int     planes[3]    = { 0, 1, 2 };
        const GLsizei widths[3]    = { frame->pitches[0], frame->pitches[1], frame->pitches[2] };
        const GLsizei heights[3]   = { frame->h,          frame->h / 2,      frame->h / 2 };
        const GLubyte *pixels[3]   = { frame->pixels[0],  frame->pixels[1],  frame->pixels[2] };
        
        switch (frame->format) {
                
            case SDL_FCC_YV12:{
                planes[1] = 2;
                planes[2] = 1;
            }
            case SDL_FCC_I420:{
                if ([self.program conformsToProtocol:@protocol(MDYUV420PProgramHardCodecProtocol)]) {
                    id<MDYUV420PProgramHardCodecProtocol>  hardCodecP = (id<MDYUV420PProgramHardCodecProtocol>)self.program;
                    [hardCodecP switchHardCodec:NO];
                }
                if ([self beginCommit]) {
                    for (int i = 0; i < 3; ++i) {
                        int plane = planes[i];
                        glBindTexture(GL_TEXTURE_2D, self.program.mTextureUniformHandle[i]);
                        glTexImage2D(GL_TEXTURE_2D,
                                     0,
                                     GL_LUMINANCE,
                                     widths[plane],
                                     heights[plane],
                                     0,
                                     GL_LUMINANCE,
                                     GL_UNSIGNED_BYTE,
                                     pixels[plane]);
                    }
                    [self postCommit];
                    
                    self.mRendererBegin = YES;
                    [self.sizeContext updateTextureWidth:frame->w height:frame->h];
                }
            }break;
            case SDL_FCC__VTB:{
                if ([self beginCommit]) {
                    [self bindTextureHardCodec:frame->buffer];
                    [self postCommit];
                    self.mRendererBegin = YES;
                    [self.sizeContext updateTextureWidth:frame->w height:frame->h];
                }
            }break;
            default:
                NSLog(@"[yuv420p] unexpected format %x\n", frame->format);
                return;
        }
        
        
    });
}

- (void)destroy{
    [super destroy];
    [self clearTexture];
    self.mProvider = nil;
}

- (BOOL) updateTexture:(EAGLContext*)context{
    return self.mRendererBegin;
}

+ (MD360Texture*) createWithProvider:(id<IMDYUV420PProvider>) provider{
    MDYUV420PVideoTexture* texture = [[MDYUV420PVideoTexture alloc] initWithProvider:provider];
    return texture;
}

@end
