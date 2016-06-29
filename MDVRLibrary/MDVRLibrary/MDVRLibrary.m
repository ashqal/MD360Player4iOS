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
#import "MDVideoDataAdatperAVPlayerImpl.h"
#import "MDAbsObject3D.h"
#import "MDProjectionStrategy.h"

@interface MDVRLibrary()<IAdvanceGestureListener>
@property (nonatomic,strong) MD360Texture* texture;
@property (nonatomic,strong) MDInteractiveStrategyManager* interactiveStrategyManager;
@property (nonatomic,strong) MDDisplayStrategyManager* displayStrategyManager;
@property (nonatomic,strong) MDProjectionStrategyManager* projectionStrategyManager;
@property (nonatomic,strong) MD360Renderer* renderer;
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

- (void) setupStrategyManager:(id<MD360DirectorFactory>) factory {
    self.projectionStrategyManager.directorFactory = factory;
    self.interactiveStrategyManager.projectionStrategyManager = self.projectionStrategyManager;
    [self.interactiveStrategyManager prepare];
    [self.displayStrategyManager prepare];
}

- (void) setupDisplay:(UIViewController*)viewController view:(UIView*)parentView{
    MDGLKViewController* glkViewController = [[MDGLKViewController alloc] init];
    
    // renderer
    MD360RendererBuilder* builder = [MD360Renderer builder];
    [builder setTexture:self.texture];
    [builder setDisplayStrategyManager:self.displayStrategyManager];
    [builder setProjectionStrategyManager:self.projectionStrategyManager];
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
    NSArray* directors = [self.projectionStrategyManager getDirectors];
    for (MD360Director* dirctor in directors) {
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

#pragma mark ProjectionMode
- (void) switchProjectionMode{
    [self.projectionStrategyManager switchMode];
}

- (void) switchProjectionMode:(MDModeProjection)projectionMode{
    [self.projectionStrategyManager switchMode:projectionMode];
}

- (MDModeProjection) getProjectionMode{
    return self.projectionStrategyManager.mMode;
}

@end

#pragma mark MDVRConfiguration
@interface MDVRConfiguration()

@property (nonatomic,readonly) MD360Texture* texture;
@property (nonatomic,readonly) UIViewController* viewController;
@property (nonatomic,readonly) UIView* view;
@property (nonatomic,readonly) MDModeInteractive interactiveMode;
@property (nonatomic,readonly) MDModeDisplay displayMode;
@property (nonatomic,readonly) MDModeProjection projectionMode;
@property (nonatomic,readonly) bool pinchEnabled;
@property (nonatomic,weak) id<MD360DirectorFactory> directorFactory;
@property (nonatomic,readonly) MDAbsObject3D* object3D;

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
    MDVideoDataAdatperAVPlayerImpl* adapter = [[MDVideoDataAdatperAVPlayerImpl alloc]initWithPlayerItem:playerItem];
    _texture = [MD360VideoTexture createWithDataAdapter:adapter];
}

- (void) asVideoWithDataAdatper:(id<MDVideoDataAdapter>)adapter{
    _texture = [MD360VideoTexture createWithDataAdapter:adapter];
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

- (void) projectionMode:(MDModeProjection)projectionMode{
    _projectionMode = projectionMode;
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

- (void) displayAsDome{
    _object3D = [[MDDome3D alloc]init];
}

- (void) displayAsSphere{
    _object3D = [[MDSphere3D alloc]init];
}

- (MDVRLibrary*) build{
    if (self.directorFactory == nil) {
        _directorFactory = [[MD360DefaultDirectorFactory alloc]init];
    }
    
    if (self.object3D == nil) {
        [self displayAsSphere];
    }
    
    MDVRLibrary* library = [[MDVRLibrary alloc]init];
    library.texture = self.texture;
    library.parentView = self.view;
    library.projectionStrategyManager = [[MDProjectionStrategyManager alloc]initWithDefault:self.projectionMode];
    library.interactiveStrategyManager = [[MDInteractiveStrategyManager alloc]initWithDefault:self.interactiveMode];
    library.displayStrategyManager = [[MDDisplayStrategyManager alloc]initWithDefault:self.displayMode];
    [library setupStrategyManager:self.directorFactory];
    
    library.touchHelper.pinchEnabled = self.pinchEnabled;
    [library setupDisplay:self.viewController view:self.view];
    
    [library setup];
    return library;
}

@end
