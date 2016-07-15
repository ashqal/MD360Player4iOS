//
//  MDExt.h
//  IJKMediaPlayer
//
//  Created by ashqal on 16/7/14.
//  Copyright © 2016年 bilibili. All rights reserved.
//

#ifndef MDExt_h
#define MDExt_h

#import <UIKit/UIKit.h>

struct MDVideoFrame {
    int w; /**< Read-only */
    int h; /**< Read-only */
    uint32_t format; /**< Read-only */
    int planes; /**< Read-only */
    uint16_t *pitches; /**< in bytes, Read-only */
    unsigned char **pixels; /**< Read-write */
};

typedef struct MDVideoFrame MDVideoFrame;

@protocol MDVideoFrameCallback <NSObject>
@required
- (void) onFrameAvailable:(MDVideoFrame*) frame;
@end

#pragma mark just for ijk
@protocol MDIJKSDLGLView <NSObject>
@required
- (void) setFrameCallback:(id<MDVideoFrameCallback>) callback;
@end


#endif /* MDExt_h */
