//
//  MDGLKViewController.h
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/8.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "MDGLRendererDelegate.h"
#import "MD360Director.h"
#import <UIKit/UIKit.h>
#import "MDTouchHelper.h"

@interface MDGLKViewController : GLKViewController<UIGestureRecognizerDelegate>
@property (nonatomic,weak) id<MDGLRendererDelegate> rendererDelegate;
@property (nonatomic,strong) NSString* name;
// @property (nonatomic,weak) id<MDTouchDelegate> touchDelegate;
@end
