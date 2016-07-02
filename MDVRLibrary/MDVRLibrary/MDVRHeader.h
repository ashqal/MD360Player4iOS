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

@protocol TextureCallback <NSObject>
@required
-(void) texture:(UIImage*)image;
@end

@protocol IMDDestroyable <NSObject>
-(void) destroy;
@end

@protocol IMDImageProvider <NSObject>
@required
-(void) onProvideImage:(id<TextureCallback>)callback;
@end

@interface MDSizeContext : NSObject
- (void)updateTextureWidth:(float)width height:(float) height;
- (void)updateViewportWidth:(float)width height:(float) height;
- (float)getTextureRatioValue;
- (float)getViewportRatioValue;
@end

#endif /* MDVRHeader_h */
