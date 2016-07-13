//
//  MD360Program.m
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/6.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "MD360Program.h"
#import "GLUtil.h"

@implementation MD360Program
- (void) build {
    self.mTextureUniformHandle = malloc(sizeof(int) * [self getTextureUniformSize]);
}

- (void) destroy {
    if (vertexShaderHandle) glDeleteShader(vertexShaderHandle);
    if (fragmentShaderHandle) glDeleteShader(fragmentShaderHandle);
    if (self.mProgramHandle) glDeleteProgram(self.mProgramHandle);
    if (self.mTextureUniformHandle) {
        free(self.mTextureUniformHandle);
        self.mTextureUniformHandle = 0;
    }
    vertexShaderHandle = fragmentShaderHandle = _mProgramHandle = 0;
}

- (void) use {
    if(self.mProgramHandle) glUseProgram(self.mProgramHandle);
}

- (int) getTextureUniformSize{
    return 0;
}

@end
