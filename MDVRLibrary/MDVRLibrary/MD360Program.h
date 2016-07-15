//
//  MD360Program.h
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/6.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDVRHeader.h"

@interface MD360Program : NSObject<IMDDestroyable>{
    GLuint vertexShaderHandle,fragmentShaderHandle;
    
}
@property (nonatomic) int mMVPMatrixHandle;
@property (nonatomic) int mMVMatrixHandle;
@property (nonatomic) int mPositionHandle;
@property (nonatomic) int mTextureCoordinateHandle;
@property (nonatomic) int mProgramHandle;
@property (nonatomic) int mContentType;
@property (nonatomic) int* mTextureUniformHandle;
@property (nonatomic) int mColorConversionHandle;
- (void) build;
- (void) use;
- (int) getTextureUniformSize;
@end

@interface MDRGBAProgram : MD360Program

@end

@interface MDYUV420PProgram : MD360Program

@end