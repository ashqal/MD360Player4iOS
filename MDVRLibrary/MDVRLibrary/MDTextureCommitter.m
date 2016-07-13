//
//  MDTextureCommitter.m
//  MDVRLibrary
//
//  Created by ashqal on 16/7/13.
//  Copyright © 2016年 asha. All rights reserved.
//

#import "MDVRHeader.h"

@interface MDTextureCommitter()
@property (strong,nonatomic) EAGLContext* context;
@end

@implementation MDTextureCommitter

- (void)setup:(EAGLContext*)context{
    self.context = context;
}

- (void)teardown{
    self.context = nil;
}

- (BOOL) begin{
    
    if ([EAGLContext currentContext] != self.context) {
        [EAGLContext setCurrentContext:self.context];
    }
    return [EAGLContext currentContext] == self.context;
}

- (void) commit{
    // nop
}

@end
