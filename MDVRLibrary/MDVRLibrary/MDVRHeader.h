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
#define MDVR_RAW_PATH [[[NSBundle bundleForClass: [self class]] resourcePath] stringByAppendingPathComponent: MDVR_RAW_NAME]
#define MDVR_RAW [NSBundle bundleWithPath: MDVR_RAW_PATH]
#define MULTI_SCREEN_SIZE 2

#import <UIKit/UIKit.h>
#import "MDExt.h"

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
-(void) onProvideImage:(id<TextureCallback>)callback;
@end

@protocol IMDYUV420PProvider <NSObject>
@required
-(void) onProvideBuffer:(id<YUV420PTextureCallback>)callback;
@end

#pragma mark MDVideoFrameAdapter
@interface MDVideoFrameAdapter : NSObject<IMDYUV420PProvider,MDVideoFrameCallback>

@end

@interface MDIJKAdapter : MDVideoFrameAdapter

+ (MDVideoFrameAdapter*) wrap:(id)ijk_sdl_view;

@end

@interface MDSizeContext : NSObject
- (void)updateTextureWidth:(float)width height:(float) height;
- (void)updateViewportWidth:(float)width height:(float) height;
- (float)getTextureRatioValue;
- (float)getViewportRatioValue;
@end

#endif /* MDVRHeader_h */
