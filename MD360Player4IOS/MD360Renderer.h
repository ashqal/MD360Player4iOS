//
//  MD360Renderer.h
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/7.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDGLRendererDelegate.h"
#import "MD360Director.h"
#import "MD360Texture.h"

@interface MD360Renderer : NSObject <MDGLRendererDelegate>
@property (nonatomic,retain) MD360Texture* mTexture;
@property (nonatomic,retain) MD360Director* mDirector;
@end
