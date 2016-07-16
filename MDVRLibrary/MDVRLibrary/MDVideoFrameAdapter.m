//
//  MDVideoFrameAdapter.m
//  MDVRLibrary
//
//  Created by ashqal on 16/7/15.
//  Copyright © 2016年 asha. All rights reserved.
//

#import "MDVRHeader.h"


@interface MDVideoFrameAdapter()

@property (nonatomic,weak) id<YUV420PTextureCallback> callback;

@end

@implementation MDVideoFrameAdapter

- (void) onFrameAvailable:(MDVideoFrame*) frame{
    if (self.callback != nil) {
        [self.callback texture:(MDVideoFrame*)frame];
    }
}

-(void) onProvideBuffer:(id<YUV420PTextureCallback>)callback{
    self.callback = callback;
}

@end
