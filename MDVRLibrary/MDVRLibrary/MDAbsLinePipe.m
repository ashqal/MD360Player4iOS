//
//  MDAbsLinePipe.m
//  MDVRLibrary
//
//  Created by Asha on 2017/7/2.
//  Copyright © 2017年 asha. All rights reserved.
//

#import "MDAbsLinePipe.h"

@interface MDAbsLinePipe(){
    BOOL mIsInit;
}
@end

@implementation MDAbsLinePipe
-(void) fireSetup:(EAGLContext*) context {
    if (!mIsInit) {
        [self setup:context];
        mIsInit = YES;
    }
}

-(void) takeOverTotalWidth:(int)w totalHeight:(int)h size:(int)size {}

-(void) commitTotalWidth:(int)w totalHeight:(int)h size:(int)size texture:(GLint)texture {}

-(void) setup: (EAGLContext*)context {}

-(GLint) getTextureId { return 0; }

@end
