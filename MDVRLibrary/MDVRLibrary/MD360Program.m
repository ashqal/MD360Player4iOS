//
//  MD360Program.m
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/6.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "MD360Program.h"
#import "GLUtil.h"
@interface MD360Program(){
    GLuint vertexShaderHandle,fragmentShaderHandle;
}
@end

@implementation MD360Program
- (void) build {
    NSString* vertexShader = [self getVertexShader];
    NSString* fragmentShader = [self getFragmentShader];
    // NSLog(@"%@ %@",vertexShader,fragmentShader);
    //GLuint vertexShaderHandle,fragmentShaderHandle;
    
    if (![GLUtil compileShader:&vertexShaderHandle type:GL_VERTEX_SHADER source:vertexShader])
        NSLog(@"Failed to compile vertex shader");
    
    if (![GLUtil compileShader:&fragmentShaderHandle type:GL_FRAGMENT_SHADER source:fragmentShader])
        NSLog(@"Failed to compile fragment shader");
    
    NSArray* attrs = [[NSArray alloc] initWithObjects:@"a_Position", @"a_TexCoordinate", nil];
    _mProgramHandle = [GLUtil createAndLinkProgramWith:vertexShaderHandle fsHandle:fragmentShaderHandle attrs:attrs];

    _mMVMatrixHandle = glGetUniformLocation(self.mProgramHandle, "u_MVMatrix");
    _mMVPMatrixHandle = glGetUniformLocation(self.mProgramHandle, "u_MVPMatrix");
    _mTextureUniformHandle = glGetUniformLocation(self.mProgramHandle, "u_Texture");
    
    _mPositionHandle = glGetAttribLocation(self.mProgramHandle, "a_Position");
    _mTextureCoordinateHandle = glGetAttribLocation(self.mProgramHandle, "a_TexCoordinate");
}

- (void) destroy {
    if (vertexShaderHandle) glDeleteShader(vertexShaderHandle);
    if (fragmentShaderHandle) glDeleteShader(fragmentShaderHandle);
    if (self.mProgramHandle) glDeleteProgram(self.mProgramHandle);
    vertexShaderHandle = fragmentShaderHandle = _mProgramHandle = 0;
}


- (void) use {
    if(self.mProgramHandle) glUseProgram(self.mProgramHandle);
}

- (NSString*) getVertexShader {
    NSString* path = [MDVR_RAW pathForResource:@"per_pixel_vertex_shader" ofType:@"glsl"];
    return [GLUtil readRawText:path];
}

- (NSString*) getFragmentShader {
    NSString* path = [MDVR_RAW pathForResource:@"per_pixel_fragment_shader_bitmap" ofType:@"glsl"];
    return [GLUtil readRawText:path];
}

@end
