//
//  MDVRLibrary.m
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/7.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "MDVRLibrary.h"
#import "MDGLKViewController.h"
#import "MD360Renderer.h"
#import "MD360Texture.h"
#import "MDInteractiveStrategy.h"

@interface MDVRLibrary()
@property (nonatomic,strong) MD360Texture* texture;
@property (nonatomic,strong) MD360Renderer* renderer;
@property (nonatomic,strong) MDInteractiveStrategyManager* interactiveStrategyManager;

@end

#pragma mark MDVRLibrary
@implementation MDVRLibrary
+ (MDVRConfiguration*) createConfig{
    return [[MDVRConfiguration alloc]init];
}

- (void) setup {
    [self.interactiveStrategyManager prepare];
}

- (void) addDisplay:(UIViewController*)parent frame:(CGRect)frame{
    MDGLKViewController* glkViewController = [[MDGLKViewController alloc] init];
    glkViewController.rendererDelegate = self.renderer;
    glkViewController.touchDelegate = self.renderer.mDirector;
    UIView* parentView = parent.view;
    glkViewController.view.bounds = frame;
    [parentView addSubview:glkViewController.view];
    [parent addChildViewController:glkViewController];
    [glkViewController didMoveToParentViewController:parent];
}

#pragma mark InteractiveMode
- (void) switchInteractiveMode:(MDModeInteractive)interactiveMode{
    [self.interactiveStrategyManager switchMode:interactiveMode];
}

- (void) switchInteractiveMode{
    [self.interactiveStrategyManager switchMode];
}

- (MDModeInteractive) getInteractiveMdoe{
    return self.interactiveStrategyManager.mMode;
}

@end

#pragma mark MDVRConfiguration
@interface MDVRConfiguration()

@property (nonatomic,readonly) NSArray* vrFrames;
@property (nonatomic,readonly) MD360Texture* texture;
@property (nonatomic,readonly) UIViewController* viewController;
@property (nonatomic,readonly) MDModeInteractive interactiveMode;

@end

@implementation MDVRConfiguration

- (void) asVideo:(AVPlayerItem*)playerItem{
    _texture = [MD360VideoTexture createWithAVPlayerItem:playerItem];
}

- (void) asImage:(id)data{
    // nop
}

- (void) interactiveMode:(MDModeInteractive)interactiveMode{
    _interactiveMode = interactiveMode;
}

- (void) setFramesInViewController:(UIViewController*)viewController frames:(NSArray*)frames{
    _viewController = viewController;
    _vrFrames = frames;
}

- (MDVRLibrary*) build{
    MDVRLibrary* library = [[MDVRLibrary alloc]init];
    library.texture = self.texture;
    library.renderer = [[MD360Renderer alloc]init];
    library.renderer.mTexture = self.texture;
    library.interactiveStrategyManager = [[MDInteractiveStrategyManager alloc]initWithDefault:self.interactiveMode];
    
    [library setup];
    for (NSValue* value in self.vrFrames) {
        [library addDisplay:self.viewController frame:[value CGRectValue] ];
    }
    return library;
}

@end
