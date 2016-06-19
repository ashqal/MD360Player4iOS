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

#define sMultiScreenSize 2

@interface MDVRLibrary()<IAdvanceGestureListener>
@property (nonatomic,strong) MD360Texture* texture;
@property (nonatomic,strong) MDInteractiveStrategyManager* interactiveStrategyManager;
@property (nonatomic,strong) MDDisplayStrategyManager* displayStrategyManager;
@property (nonatomic,strong) MD360Renderer* renderer;
@property (nonatomic,strong) NSMutableArray* directors;
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
        self.touchHelper = [[MDTouchHelper alloc]init];
        self.directors = [[NSMutableArray alloc]init];
        

    }
    return self;
}

-(void)dealloc{
    for(UIView* view in self.parentView.subviews){
        [view removeFromSuperview];
    }
}

- (void) setup {
    [self.touchHelper registerTo:self.parentView];
    self.touchHelper.advanceGestureListener = self;
    
}

- (void) setupStrategyManager {
    self.interactiveStrategyManager.dirctors = self.directors;
    [self.interactiveStrategyManager prepare];
    [self.displayStrategyManager prepare];
}

- (void) setupDirector:(id<MD360DirectorFactory>)factory{
    
    for (int i = 0; i < sMultiScreenSize; i++) {
        if ([factory respondsToSelector:@selector(createDirector:)]) {
            MD360Director* director = [factory createDirector:i];
            [self.directors addObject:director];
        }
    }
}

- (void) setupDisplay:(UIViewController*)viewController view:(UIView*)parentView{
    MDGLKViewController* glkViewController = [[MDGLKViewController alloc] init];
    
    // renderer
    MD360RendererBuilder* builder = [MD360Renderer builder];
    [builder setTexture:self.texture];
    [builder setDirectors:self.directors];
    [builder setDisplayStrategyManager:self.displayStrategyManager];
    self.renderer = [builder build];
    glkViewController.rendererDelegate = self.renderer;
    
    float width = [[UIScreen mainScreen] bounds].size.width;
    float height = [[UIScreen mainScreen] bounds].size.height;
    [glkViewController.view setFrame:CGRectMake(0, 0, width, height)];
    
    [parentView insertSubview:glkViewController.view atIndex:0];
    if (viewController != nil) {
        [viewController addChildViewController:glkViewController];
        [glkViewController didMoveToParentViewController:viewController];
    }
}

#pragma mark IAdvanceGestureListener
- (void) onDragDistanceX:(float)distanceX distanceY:(float)distanceY{
    [self.interactiveStrategyManager handleDragDistX:distanceX distY:distanceY];
}

- (void) onPinch:(float)scale{
    for (MD360Director* dirctor in self.directors) {
        [dirctor updateProjectionNearScale:scale];
    }
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
@property (nonatomic,readonly) bool pinchEnabled;
@property (nonatomic,readonly) id<MD360DirectorFactory> directorFactory;

@end

@implementation MDVRConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _interactiveMode = MDModeInteractiveTouch;
        _displayMode = MDModeDisplayNormal;
        _pinchEnabled = NO;
    }
    return self;
}
- (void) asVideo:(AVPlayerItem*)playerItem{
    _texture = [MD360VideoTexture createWithAVPlayerItem:playerItem];
}

- (void) asImage:(id<IMDImageProvider>)data{
    // nop
    _texture = [MD360BitmapTexture createWithProvider:data];
}

- (void) interactiveMode:(MDModeInteractive)interactiveMode{
    _interactiveMode = interactiveMode;
}

- (void) displayMode:(MDModeDisplay)displayMode{
    _displayMode = displayMode;
}

- (void) pinchEnabled:(bool)pinch{
    _pinchEnabled = pinch;
}

- (void) setContainer:(UIViewController*)vc{
    [self setContainer:vc view:vc.view];
}

- (void) setContainer:(UIViewController*)vc view:(UIView*)view{
    _viewController = vc;
    _view = view;
}

- (void) setDirectorFactory:(id<MD360DirectorFactory>) directorFactory{
    _directorFactory = directorFactory;
}

- (MDVRLibrary*) build{
    if (self.directorFactory == nil) {
        _directorFactory = [[MD360DefaultDirectorFactory alloc]init];
    }
    
    MDVRLibrary* library = [[MDVRLibrary alloc]init];
    [library setupDirector:self.directorFactory];
    library.texture = self.texture;
    library.parentView = self.view;
    library.interactiveStrategyManager = [[MDInteractiveStrategyManager alloc]initWithDefault:self.interactiveMode];
    library.displayStrategyManager = [[MDDisplayStrategyManager alloc]initWithDefault:self.displayMode];
    [library setupStrategyManager];
    
    library.touchHelper.pinchEnabled = self.pinchEnabled;
    [library setupDisplay:self.viewController view:self.view];
    
    [library setup];
    return library;
}

@end
