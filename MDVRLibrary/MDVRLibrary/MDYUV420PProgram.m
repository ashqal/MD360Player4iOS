//
//  MDYUV420PProgram.m
//  MDVRLibrary
//
//  Created by ashqal on 16/7/14.
//  Copyright © 2016年 asha. All rights reserved.
//

#import "MD360Program.h"
#import "GLUtil.h"

static const GLfloat g_md_bt709[] = {
    1.164,  1.164,  1.164,
    0.0,   -0.213,  2.112,
    1.793, -0.533,  0.0,
};

const GLfloat *MD_IJK_GLES2_getColorMatrix_bt709()
{
    return g_md_bt709;
}

static const GLfloat g_bt601[] = {
    1.164,  1.164, 1.164,
    0.0,   -0.392, 2.017,
    1.596, -0.813, 0.0,
};
const GLfloat *MD_IJK_GLES2_getColorMatrix_bt601()
{
    return g_bt601;
}




/**
 增加一个硬解码的protocol
 */
@interface MDYUV420PProgram()<MDYUV420PProgramHardCodecProtocol>
{
    
    /**
     保存CoreVideo 创建的textureId
     */
    BOOL    mHardCodec;
    GLuint   mYTexture;
    GLuint   mUVTexture;
    GLfloat *mColorConversionMatrix;
}
@end

@implementation MDYUV420PProgram

- (void) build {
    
}

- (void)build_
{
    [super build];
    
    NSString* vertexShader = [self getVertexShader];
    NSString* fragmentShader = [self getFragmentShader];
    
    if (![GLUtil compileShader:&vertexShaderHandle type:GL_VERTEX_SHADER source:vertexShader])
        NSLog(@"Failed to compile vertex shader");
    
    if (![GLUtil compileShader:&fragmentShaderHandle type:GL_FRAGMENT_SHADER source:fragmentShader])
        NSLog(@"Failed to compile fragment shader");
    
    NSArray* attrs = [[NSArray alloc] initWithObjects:@"a_Position", @"a_TexCoordinate", nil];
    self.mProgramHandle = [GLUtil createAndLinkProgramWith:vertexShaderHandle fsHandle:fragmentShaderHandle attrs:attrs];
    
    self.mMVMatrixHandle = glGetUniformLocation(self.mProgramHandle, "u_MVMatrix");
    self.mMVPMatrixHandle = glGetUniformLocation(self.mProgramHandle, "u_MVPMatrix");
    
    self.mTextureUniformHandle[0] = glGetUniformLocation(self.mProgramHandle, "u_TextureX");
    self.mTextureUniformHandle[1] = glGetUniformLocation(self.mProgramHandle, "u_TextureY");
    self.mTextureUniformHandle[2] = glGetUniformLocation(self.mProgramHandle, "u_TextureZ");
    
    self.mColorConversionHandle = glGetUniformLocation(self.mProgramHandle, "u_ColorConversion");
    self.mPositionHandle = glGetAttribLocation(self.mProgramHandle, "a_Position");
    self.mTextureCoordinateHandle = glGetAttribLocation(self.mProgramHandle, "a_TexCoordinate");
}

- (void)buildHardCodec
{
    [super build];
    
    NSString* vertexShader = [self getVertexShader];
    NSString* fragmentShader = [self getHardCodecFragmentShader];
    
    if (![GLUtil compileShader:&vertexShaderHandle type:GL_VERTEX_SHADER source:vertexShader])
        NSLog(@"Failed to compile vertex shader");
    
    if (![GLUtil compileShader:&fragmentShaderHandle type:GL_FRAGMENT_SHADER source:fragmentShader])
        NSLog(@"Failed to compile fragment shader");
    
    NSArray* attrs = [[NSArray alloc] initWithObjects:@"a_Position", @"a_TexCoordinate", nil];
    self.mProgramHandle = [GLUtil createAndLinkProgramWith:vertexShaderHandle fsHandle:fragmentShaderHandle attrs:attrs];
    
    self.mMVMatrixHandle = glGetUniformLocation(self.mProgramHandle, "u_MVMatrix");
    self.mMVPMatrixHandle = glGetUniformLocation(self.mProgramHandle, "u_MVPMatrix");
    
    self.mTextureUniformHandle[0] = glGetUniformLocation(self.mProgramHandle, "us2_SamplerX");
    self.mTextureUniformHandle[1] = glGetUniformLocation(self.mProgramHandle, "us2_SamplerY");
    
    self.mColorConversionHandle = glGetUniformLocation(self.mProgramHandle, "u_ColorConversion");
    self.mPositionHandle = glGetAttribLocation(self.mProgramHandle, "a_Position");
    self.mTextureCoordinateHandle = glGetAttribLocation(self.mProgramHandle, "a_TexCoordinate");
}

- (void) use {
    [super use];
    if (mHardCodec) {
        glUniformMatrix3fv(self.mColorConversionHandle, 1, GL_FALSE, mColorConversionMatrix);
        glPixelStorei(GL_UNPACK_ALIGNMENT, 1);//像素对齐
        GLuint texture[2] = {mYTexture,mUVTexture};
        for (int i = 0; i < 2; ++i) {
            glActiveTexture(GL_TEXTURE0 + i);
            glBindTexture(GL_TEXTURE_2D, texture[i]);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
            
            glUniform1i(self.mTextureUniformHandle[i], i);
        }
        
    }
    else
    {
        glPixelStorei(GL_UNPACK_ALIGNMENT, 1);//像素对齐
        for (int i = 0; i < 3; ++i) {
            glActiveTexture(GL_TEXTURE0 + i);
            glBindTexture(GL_TEXTURE_2D, self.mTextureUniformHandle[i]);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
            
            glUniform1i(self.mTextureUniformHandle[i], i);
        }
        glUniformMatrix3fv(self.mColorConversionHandle, 1, GL_FALSE, MD_IJK_GLES2_getColorMatrix_bt709());
    }
    
    
    
    //glUseProgram(0);
}

- (NSString*) getVertexShader {
    NSString* path = [MDVR_RAW pathForResource:@"per_pixel_vertex_shader" ofType:@"glsl"];
    return [GLUtil readRawText:path];
}

- (NSString*) getFragmentShader {
    NSString* path = [MDVR_RAW pathForResource:@"per_pixel_fragment_shader_yuv420p" ofType:@"glsl"];
    return [GLUtil readRawText:path];
}

- (NSString*) getHardCodecFragmentShader {
    NSString* path = [MDVR_RAW pathForResource:@"per_pixel_fragment_hardCodec_shader_yuv420p" ofType:@"glsl"];
    return [GLUtil readRawText:path];
}

- (int) getTextureUniformSize{
    if (mHardCodec) {
        return 2;
    }
    return 3;
}

#pragma mark MDYUV420PProgramHardCodecProtocol

- (void)switchHardCodec:(BOOL)hardCodec
{
    if (self.mProgramHandle == 0 ) { //首次创建 program
        mHardCodec = hardCodec;
        if (mHardCodec) {
            [self buildHardCodec];
        }
        else{
            [self build_];
        }
    }
    else{
        if (mHardCodec != hardCodec) {
            mHardCodec = hardCodec;
            [self destroy];
            if (mHardCodec) {
                [self buildHardCodec];
            }
            else{
                [self build_];
            }
        }
    }
    
    
}

- (void)setYTexture:(GLuint)YTexture UVTexture:(GLuint)UVTexture colorConversionMatrix:(GLfloat *)colorConversionMatrix{
    mYTexture = YTexture;
    mUVTexture = UVTexture;
    mColorConversionMatrix = colorConversionMatrix;
}


@end
