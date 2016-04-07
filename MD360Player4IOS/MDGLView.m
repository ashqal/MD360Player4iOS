//
//  MDGLView.m
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/7.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "MDGLView.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "GLUtil.h"

@interface MDGLView()
@property (nonatomic, retain) EAGLContext* context;
@property (nonatomic, retain) CADisplayLink* displayLink;
@end

@implementation MDGLView

#pragma mark init && dealloc
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    [self tearDown];
}

#pragma mark setup
- (void) setup {
    NSLog(@"setup");
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    assert(self.context != nil);
    if ([EAGLContext setCurrentContext:self.context]) {
        if ([self.controller respondsToSelector:@selector(rendererOnCreated:)]) {
            [self.controller rendererOnCreated:self.context];
        }
    }
}

- (void)layoutSubviews {
    if ([EAGLContext setCurrentContext:self.context]) {
        if([self.controller respondsToSelector:@selector(rendererOnChanged:width:height:)]){
            int width = self.bounds.size.width;
            int height = self.bounds.size.height;
            [self.controller rendererOnChanged:self.context width:width height:height];
        }
        
        // invalidate old displayLink
        [self destroyDisplayLink];
        
        // create a new displayLink
        [self createDisplayLink];
    }
    
    NSLog(@"layoutSubviews");
}

- (void) tearDown {
    self.controller = nil;
    [self destroyDisplayLink];
}

#pragma mark displayLink
- (void) drawView {
    if ([EAGLContext setCurrentContext:self.context]) {
        if ([self.controller respondsToSelector:@selector(rendererOnDrawFrame:)]) {
            [self.controller rendererOnDrawFrame:self.context];
        }
    }
}

- (void) destroyDisplayLink{
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (void) createDisplayLink{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawView)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}


@end
