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
    [self destroy:self.context];
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;
}

- (void)viewDidLoad{
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    self.preferredFramesPerSecond = 30.0f;
    
    
    assert(self.context != nil);
    if ([EAGLContext setCurrentContext:self.context]) {
        
        GLKView *view = (GLKView *)self.view;
        view.context = self.context;
        view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
        if ([self.rendererDelegate respondsToSelector:@selector(rendererOnCreated:)]) {
            [self.rendererDelegate rendererOnCreated:self.context];
            [GLUtil glCheck:@"rendererOnCreated"];
        }
    }
}

- (void)viewDidLayoutSubviews{
    if (self.context == nil) return;
    if ([EAGLContext setCurrentContext:self.context]) {
        if([self.rendererDelegate respondsToSelector:@selector(rendererOnChanged:width:height:)]){
            int width = self.view.bounds.size.width;
            int height = self.view.bounds.size.height;
            [self.rendererDelegate rendererOnChanged:self.context width:width height:height];
            [GLUtil glCheck:@"rendererOnChanged"];
        }
    }
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    if (!self.view.hidden || pendingToVisible){
        if (self.context == nil) return;
        
        if (pendingToVisible) {
            [self.view setFrame:pendingFrame];
        }
        
        if ([EAGLContext setCurrentContext:self.context]) {
            if ([self.rendererDelegate respondsToSelector:@selector(rendererOnDrawFrame:)]) {
                [self.rendererDelegate rendererOnDrawFrame:self.context];
                [GLUtil glCheck:@"rendererOnDrawFrame"];
            }
        }
        
        
        
        pendingToVisible = NO;
        self.view.hidden = NO;
    }
    
}

- (void) destroy:(EAGLContext*) context{
    if (self.context == nil) return;
    if ([EAGLContext setCurrentContext:self.context]) {
        if ([self.rendererDelegate respondsToSelector:@selector(rendererOnDestroy:)]) {
            [self.rendererDelegate rendererOnDestroy:self.context];
            [GLUtil glCheck:@"rendererOnDestroy"];
        }
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

#pragma mark - touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if([self.touchDelegate respondsToSelector:@selector(touchesBegan:withEvent:)]){
        [self.touchDelegate touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if([self.touchDelegate respondsToSelector:@selector(touchesMoved:withEvent:)]){
        [self.touchDelegate touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if([self.touchDelegate respondsToSelector:@selector(touchesEnded:withEvent:)]){
        [self.touchDelegate touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if([self.touchDelegate respondsToSelector:@selector(touchesCancelled:withEvent:)]){
        [self.touchDelegate touchesCancelled:touches withEvent:event];
    }
}

@end
