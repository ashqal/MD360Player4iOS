//
//  MDGLKViewController.m
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/8.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "MDGLKViewController.h"
#import "GLUtil.h"

@interface MDGLKViewController(){
    Boolean pendingToVisible;
    CGRect pendingFrame;
}
@property (nonatomic, strong) EAGLContext* context;
@end

@implementation MDGLKViewController

- (void)dealloc{
    
    NSLog(@"MDGLKViewController dealloc!!!!!!!!!!!!!!!!!!");
    [self destroy:self.context];
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
        // NSLog(@"EAGLContext debugDescription:%@",self.context.debugLabel);
        
        
    }
    // self.context = nil;
}

- (void)viewDidLoad{
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    self.preferredFramesPerSecond = 30.0f;
    
    
    assert(self.context != nil);
    if ([EAGLContext setCurrentContext:self.context]) {
        NSLog(@"MDGLKViewController viewDidLoad [enter %@]",self.name);
        GLKView *view = (GLKView *)self.view;
        view.context = self.context;
        view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
        if ([self.rendererDelegate respondsToSelector:@selector(rendererOnCreated:)]) {
            [self.rendererDelegate rendererOnCreated:self.context];
            [GLUtil glCheck:@"rendererOnCreated"];
        }
        NSLog(@"MDGLKViewController viewDidLoad [exit %@]",self.name);
    }
}

- (void)viewDidLayoutSubviews{
    if (self.context == nil) return;
    if ([EAGLContext setCurrentContext:self.context]) {
        NSLog(@"MDGLKViewController viewDidLayoutSubviews [enter %@]",self.name);
        if([self.rendererDelegate respondsToSelector:@selector(rendererOnChanged:width:height:)]){
            int width = self.view.bounds.size.width;
            int height = self.view.bounds.size.height;
            [self.rendererDelegate rendererOnChanged:self.context width:width height:height];
            [GLUtil glCheck:@"rendererOnChanged"];
        }
        NSLog(@"MDGLKViewController viewDidLayoutSubviews [exit %@]",self.name);
    }
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    if (!self.view.hidden || pendingToVisible){
        if (self.context == nil) return;
        
        if (pendingToVisible) {
            [self.view setFrame:pendingFrame];
        }
        
        if ([EAGLContext setCurrentContext:self.context]) {
            NSLog(@"MDGLKViewController drawInRect [enter %@]",self.name);
            if ([self.rendererDelegate respondsToSelector:@selector(rendererOnDrawFrame:width:height:)]) {
                [self.rendererDelegate rendererOnDrawFrame:self.context width:rect.size.width height:rect.size.height];
                [GLUtil glCheck:@"rendererOnDrawFrame"];
            }
            NSLog(@"MDGLKViewController drawInRect [exit %@]",self.name);
        }
        
        pendingToVisible = NO;
        self.view.hidden = NO;
    }
    
}

- (void) destroy:(EAGLContext*) context{
    if (self.context == nil) return;
    if ([EAGLContext setCurrentContext:self.context]) {
        NSLog(@"MDGLKViewController destroy [enter %@]",self.name);
        if ([self.rendererDelegate respondsToSelector:@selector(rendererOnDestroy:)]) {
            [self.rendererDelegate rendererOnDestroy:self.context];
            [GLUtil glCheck:@"rendererOnDestroy"];
        }
        NSLog(@"MDGLKViewController destroy [exit %@]",self.name);
    }
}

-(void)setPendingVisible:(BOOL)visible frame:(CGRect)frame{
    pendingFrame = frame;
    if (visible) {
        pendingToVisible = true;
    } else {
        pendingToVisible = false;
        self.view.hidden = YES;
    }

}

@end
