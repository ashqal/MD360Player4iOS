//
//  MDVideoFrameAdapter.m
//  MDVRLibrary
//
//  Created by ashqal on 16/7/15.
//  Copyright © 2016年 asha. All rights reserved.
//

#import "MDVRHeader.h"


@interface MDVideoFrameAdapter()

@property (nonatomic,weak) MDTextureCommitter* committer;
@property (nonatomic,weak) id<YUV420PTextureCallback> callback;

@end

@implementation MDVideoFrameAdapter

- (void) onFrameAvailable:(MDVideoFrame*) frame{
    //
    if (self.committer != nil) {
        if ([self.committer respondsToSelector:@selector(begin)]) {
            [self.committer begin];
            [self.callback texture:(MDVideoFrame*)frame];
            [self.committer commit];
        }
    }
}

-(void) onProvideBuffer:(MDTextureCommitter*)committer callback:(id<YUV420PTextureCallback>)callback{
    self.committer = committer;
    self.callback = callback;
}

@end
