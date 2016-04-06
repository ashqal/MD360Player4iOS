//
//  MD360Program.h
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/6.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MD360Program : NSObject
@property (nonatomic,readonly) int mMVPMatrixHandle;
@property (nonatomic,readonly) int mMVMatrixHandle;
@property (nonatomic,readonly) int mTextureUniformHandle;
@property (nonatomic,readonly) int mPositionHandle;
@property (nonatomic,readonly) int mTextureCoordinateHandle;
@property (nonatomic,readonly) int mProgramHandle;
@property (nonatomic,readonly) int mContentType;
- (void) build;
- (void) use;
@end
