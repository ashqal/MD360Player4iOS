//
//  MDGLView.h
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/7.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MDGLViewController <NSObject>
@required
- (void) rendererOnCreated:(EAGLContext*)context;
- (void) rendererOnChanged:(EAGLContext*)context width:(int)width height:(int)height;
- (void) rendererOnDrawFrame:(EAGLContext*)context;
@end

@interface MDGLView : UIView
@property (nonatomic,weak) id<MDGLViewController> controller;
// - (void) setup;
// - (void) tearDown;
@end
