//
//  MDVRLibrary.h
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/7.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

#define MDVR_RAW_NAME @ "vrlibraw.bundle"
#define MDVR_RAW_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MDVR_RAW_NAME]
#define MDVR_RAW [NSBundle bundleWithPath: MDVR_RAW_PATH]

@protocol IMDDestroyable <NSObject>
-(void) destroy;
@end

@protocol TextureCallback <NSObject>
@required
-(void) texture:(UIImage*)image;
@end

@protocol IMDImageProvider <NSObject>
@required
-(void) onProvideImage:(id<TextureCallback>)callback;
@end

typedef NS_ENUM(NSInteger, MDModeInteractive) {
    MDModeInteractiveTouch,
    MDModeInteractiveMotion,
    MDModeInteractiveMotionWithTouch,
};

typedef NS_ENUM(NSInteger, MDModeDisplay) {
    MDModeDisplayNormal,
    MDModeDisplayGlass,
};

@class MDVRLibrary;
#pragma mark MDVRConfiguration
@interface MDVRConfiguration : NSObject
- (void) asVideo:(AVPlayerItem*)playerItem;
- (void) asImage:(id<IMDImageProvider>)data;
- (void) interactiveMode:(MDModeInteractive)interactiveMode;
- (void) displayMode:(MDModeDisplay)displayMode;
- (void) pinchEnabled:(bool)pinch;
- (void) setContainer:(UIViewController*)vc;
- (void) setContainer:(UIViewController*)vc view:(UIView*)view;
- (MDVRLibrary*) build;
@end

#pragma mark MDVRLibrary
@interface MDVRLibrary : NSObject
+ (MDVRConfiguration*) createConfig;

- (void) switchInteractiveMode;
// - (void) switchInteractiveMode:(MDModeInteractive)interactiveMode;
- (MDModeInteractive) getInteractiveMdoe;

- (void) switchDisplayMode:(MDModeDisplay)displayMode;
- (void) switchDisplayMode;
- (MDModeDisplay) getDisplayMdoe;
@end
