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

@interface MDGLKViewController : GLKViewController
@property (nonatomic,weak) id<MDGLRendererDelegate> rendererDelegate;
@end
