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

@interface MDYUV420PVideoTexture()<YUV420PTextureCallback>
@property (nonatomic,strong) id<IMDYUV420PProvider> mProvider;
@property (nonatomic) GLuint* textures;
@property (nonatomic) BOOL mRendererBegin;

@end


@implementation MDYUV420PVideoTexture
//
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

- (void) texture:(MDVideoFrame*)frame{
    dispatch_sync(dispatch_get_main_queue(), ^{
        int     planes[3]    = { 0, 1, 2 };
        const GLsizei widths[3]    = { frame->pitches[0], frame->pitches[1], frame->pitches[2] };
        const GLsizei heights[3]   = { frame->h,          frame->h / 2,      frame->h / 2 };
        const GLubyte *pixels[3]   = { frame->pixels[0],  frame->pixels[1],  frame->pixels[2] };
        
        switch (frame->format) {
            case SDL_FCC_I420:
                break;
            case SDL_FCC_YV12:
                planes[1] = 2;
                planes[2] = 1;
                break;
            default:
                NSLog(@"[yuv420p] unexpected format %x\n", frame->format);
                return;
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
    });
}

- (void)destroy{
    [super destroy];
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