//
//  MDRGBAFboProgram.m
//  MDVRLibrary
//
//  Created by Asha on 2017/7/8.
//  Copyright © 2017年 asha. All rights reserved.
//

#import "MD360Program.h"
#import "GLUtil.h"

@implementation MDRGBAFboProgram

- (void) build {
    [super build];
    
    NSString* vertexShader = [self getVertexShader];
    NSString* fragmentShader = [self getFragmentShader];
    // NSLog(@"%@ %@",vertexShader,fragmentShader);
    //GLuint vertexShaderHandle,fragmentShaderHandle;
    
    if (![GLUtil compileShader:&vertexShaderHandle type:GL_VERTEX_SHADER source:vertexShader])
        NSLog(@"Failed to compile vertex shader");
    
    if (![GLUtil compileShader:&fragmentShaderHandle type:GL_FRAGMENT_SHADER source:fragmentShader])
        NSLog(@"Failed to compile fragment shader");
    
    NSArray* attrs = [[NSArray alloc] initWithObjects:@"a_Position", @"a_TexCoordinate", nil];
    self.mProgramHandle = [GLUtil createAndLinkProgramWith:vertexShaderHandle fsHandle:fragmentShaderHandle attrs:attrs];
    
    self.mMVMatrixHandle = glGetUniformLocation(self.mProgramHandle, "u_MVMatrix");
    self.mMVPMatrixHandle = glGetUniformLocation(self.mProgramHandle, "u_MVPMatrix");
    
    self.mTextureUniformHandle[0] = glGetUniformLocation(self.mProgramHandle, "u_Texture");
    
    self.mPositionHandle = glGetAttribLocation(self.mProgramHandle, "a_Position");
    self.mTextureCoordinateHandle = glGetAttribLocation(self.mProgramHandle, "a_TexCoordinate");
}

- (NSString*) getVertexShader {
    NSString* path = [MDVR_RAW pathForResource:@"per_pixel_vertex_shader" ofType:@"glsl"];
    return [GLUtil readRawText:path];
}

- (NSString*) getFragmentShader {
    NSString* path = [MDVR_RAW pathForResource:@"per_pixel_fragment_shader_bitmap_fbo" ofType:@"glsl"];
    return [GLUtil readRawText:path];
}

- (int) getTextureUniformSize{
    return 1;
}

@end
