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
#import "MDDisplayStrategy.h"
#import "MDTouchHelper.h"

@interface MDVRLibrary()<IAdvanceGestureListener>
@property (nonatomic,strong) MD360Texture* texture;
@property (nonatomic,strong) MDInteractiveStrategyManager* interactiveStrategyManager;
@property (nonatomic,strong) MDDisplayStrategyManager* displayStrategyManager;
@property (nonatomic,strong) NSMutableArray* renderers;
@property (nonatomic,strong) NSMutableArray* directors;
@property (nonatomic,strong) NSMutableArray* glViewControllers;
@property (nonatomic,strong) MDTouchHelper* touchHelper;
@property (nonatomic,weak) UIView* parentView;
@end

#pragma mark MDVRLibrary
@implementation MDVRLibrary
+ (MDVRConfiguration*) createConfig{
    return [[MDVRConfiguration alloc]init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.renderers = [[NSMutableArray alloc]init];
        self.directors = [[NSMutableArray alloc]init];
        self.glViewControllers = [[NSMutableArray alloc]init];
        self.touchHelper = [[MDTouchHelper alloc]init];
    }
    return self;
}

- (void) setup {
    self.interactiveStrategyManager.dirctors = self.directors;
    [self.interactiveStrategyManager prepare];
    
    self.displayStrategyManager.bounds = self.parentView.bounds;
    self.displayStrategyManager.glViewControllers = self.glViewControllers;
    [self.displayStrategyManager prepare];
    
    [self.touchHelper registerTo:self.parentView];
    self.touchHelper.advanceGestureListener = self;
    
}

- (void) addDisplay:(UIViewController*)viewController view:(UIView*)parentView{
    MDGLKViewController* glkViewController = [[MDGLKViewController alloc] init];
    
    // director
    int index = (int)[self.directors count];
    MD360Director* director = [MD360DirectorFactory create:index];
    [self.directors addObject:director];
    
    // renderer
    MD360RendererBuilder* builder = [MD360Renderer builder];
    [builder setTexture:self.texture];
    [builder setDirector:director];
    MD360Renderer* renderer = [builder build];
    [self.renderers addObject:renderer];
  
    glkViewController.rendererDelegate = renderer;
    // glkViewController.touchDelegate = director;
    
    glkViewController.view.hidden = YES;
    //[glkViewController.view setFrame:parentView.bounds];
    
    [parentView insertSubview:glkViewController.view atIndex:0];
    if (viewController != nil) {
        [viewController addChildViewController:glkViewController];
        [glkViewController didMoveToParentViewController:viewController];
    }
    
    [self.glViewControllers addObject:glkViewController];
    
}

#pragma mark IAdvanceGestureListener
- (void) onDragDistanceX:(float)distanceX distanceY:(float)distanceY{
    [self.interactiveStrategyManager handleDragDistX:distanceX distY:distanceY];
}

- (void) onPinch:(float)scale{
    
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

#pragma mark DisplayMode
- (void) switchDisplayMode:(MDModeDisplay)displayMode{
    [self.displayStrategyManager switchMode:displayMode];
}

- (void) switchDisplayMode{
    [self.displayStrategyManager switchMode];
}

- (MDModeDisplay) getDisplayMdoe{
    return self.displayStrategyManager.mMode;
}

@end

#pragma mark MDVRConfiguration
@interface MDVRConfiguration()

@property (nonatomic,readonly) MD360Texture* texture;
@property (nonatomic,readonly) UIViewController* viewController;
@property (nonatomic,readonly) UIView* view;
@property (nonatomic,readonly) MDModeInteractive interactiveMode;
@property (nonatomic,readonly) MDModeDisplay displayMode;

@end

@implementation MDVRConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _interactiveMode = MDModeInteractiveTouch;
        _displayMode = MDModeDisplayNormal;
    }
    return self;
}
- (void) asVideo:(AVPlayerItem*)playerItem{
    _texture = [MD360VideoTexture createWithAVPlayerItem:playerItem];
}

- (void) asImage:(id)data{
    // nop
}

- (void) interactiveMode:(MDModeInteractive)interactiveMode{
    _interactiveMode = interactiveMode;
}

- (void) displayMode:(MDModeDisplay)displayMode{
    _displayMode = displayMode;
}

- (void) setContainer:(UIViewController*)vc{
    [self setContainer:vc view:vc.view];
}

- (void) setContainer:(UIViewController*)vc view:(UIView*)view{
    _viewController = vc;
    _view = view;
}

- (MDVRLibrary*) build{
    MDVRLibrary* library = [[MDVRLibrary alloc]init];
    library.texture = self.texture;
    library.parentView = self.view;
    library.interactiveStrategyManager = [[MDInteractiveStrategyManager alloc]initWithDefault:self.interactiveMode];
    library.displayStrategyManager = [[MDDisplayStrategyManager alloc]initWithDefault:self.displayMode];
    for (int i = 0; i < 2; i++) {
        [library addDisplay:self.viewController view:self.view];
    }
    [library setup];
    return library;
}

@end
