//
//  MDVRHeader.h
//  MDVRLibrary
//
//  Created by ashqal on 16/6/20.
//  Copyright © 2016年 asha. All rights reserved.
//

#ifndef MDVRHeader_h
#define MDVRHeader_h


#define MDVR_RAW_NAME @ "vrlibraw.bundle"
#define MDVR_RAW_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MDVR_RAW_NAME]
#define MDVR_RAW [NSBundle bundleWithPath: MDVR_RAW_PATH]
#define MULTI_SCREEN_SIZE 2

#import <UIKit/UIKit.h>
typedef struct MDVideoFrame MDVideoFrame;
struct MDVideoFrame {
    int w; /**< Read-only */
    int h; /**< Read-only */
    UInt32 format; /**< Read-only */
    int planes; /**< Read-only */
    UInt16 *pitches; /**< in bytes, Read-only */
    UInt8 **pixels; /**< Read-write */
};

@interface MDTextureCommitter : NSObject

- (void)setup:(EAGLContext*)context;

- (void)teardown;

- (BOOL) begin;

- (void) commit;

@end

@protocol TextureCallback <NSObject>
@required
-(void) texture:(UIImage*)image;
@end

@protocol YUV420PTextureCallback <NSObject>
@required
-(void) texture:(MDVideoFrame*)frame;
@end


@protocol IMDDestroyable <NSObject>
-(void) destroy;
@end

@protocol IMDImageProvider <NSObject>
@required
-(void) onProvideImage:(MDTextureCommitter*)committer callback:(id<TextureCallback>)callback;
@end

@protocol IMDYUV420PProvider <NSObject>
@required
-(void) onProvideBuffer:(MDTextureCommitter*)committer callback:(id<YUV420PTextureCallback>)callback;
@end

@interface MDSizeContext : NSObject
- (void)updateTextureWidth:(float)width height:(float) height;
- (void)updateViewportWidth:(float)width height:(float) height;
- (float)getTextureRatioValue;
- (float)getViewportRatioValue;
@end

#endif /* MDVRHeader_h */
