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
#import "MDVRHeader.h"

@interface MDVRLibrary()<IAdvanceGestureListener>
@property (nonatomic,strong) MD360Texture* texture;
@property (nonatomic,strong) MD360Program* program;
@property (nonatomic,strong) MDInteractiveStrategyManager* interactiveStrategyManager;
@property (nonatomic,strong) MDDisplayStrategyManager* displayStrategyManager;
@property (nonatomic,strong) MDProjectionStrategyManager* projectionStrategyManager;
@property (nonatomic,strong) MD360Renderer* renderer;
@property (nonatomic,strong) MDTouchHelper* touchHelper;
@property (nonatomic,strong) MDSizeContext* sizeContext;
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
        self.sizeContext = [[MDSizeContext alloc]init];
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

- (void) setupStrategyManager{
    self.interactiveStrategyManager.projectionStrategyManager = self.projectionStrategyManager;
    [self.projectionStrategyManager prepare];
    [self.interactiveStrategyManager prepare];
    [self.displayStrategyManager prepare];
}

- (void) setupDisplay:(UIViewController*)viewController view:(UIView*)parentView{
    MDGLKViewController* glkViewController = [[MDGLKViewController alloc] init];
    
    // renderer
    MD360RendererBuilder* builder = [MD360Renderer builder];
    [builder setTexture:self.texture];
    [builder setProgram:self.program];
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
@property (nonatomic,readonly) MD360Program* program;
@property (nonatomic,readonly) UIViewController* viewController;
@property (nonatomic,readonly) UIView* view;
@property (nonatomic,readonly) MDModeInteractive interactiveMode;
@property (nonatomic,readonly) MDModeDisplay displayMode;
@property (nonatomic,readonly) MDModeProjection projectionMode;
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
    MDVideoDataAdatperAVPlayerImpl* adapter = [[MDVideoDataAdatperAVPlayerImpl alloc]initWithPlayerItem:playerItem];
    _texture = [MDRGBAVideoTexture createWithDataAdapter:adapter];
    _program = [[MDRGBAProgram alloc] init];
}

- (void) asVideoWithDataAdatper:(id<MDVideoDataAdapter>)adapter{
    _texture = [MDRGBAVideoTexture createWithDataAdapter:adapter];
    _program = [[MDRGBAProgram alloc] init];
}

- (void) asVideoWithYUV420PProvider:(id<IMDYUV420PProvider>)provider{
    _texture = [MDYUV420PVideoTexture createWithProvider:provider];
    _program = [[MDYUV420PProgram alloc] init];
}

- (void) asImage:(id<IMDImageProvider>)data{
    // nop
    _texture = [MDRGBABitmapTexture createWithProvider:data];
    _program = [[MDRGBAProgram alloc] init];
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


- (MDVRLibrary*) build{
    if (self.directorFactory == nil) {
        _directorFactory = [[MD360DefaultDirectorFactory alloc]init];
    }
    
    MDVRLibrary* library = [[MDVRLibrary alloc]init];
    
    // texture
    library.texture = self.texture;
    library.texture.sizeContext = library.sizeContext;
    
    library.program = self.program;
    
    // parent view
    library.parentView = self.view;
    
    // all strategy manager
    MDProjectionStrategyConfiguration* projectionConfig = [[MDProjectionStrategyConfiguration alloc]init];
    projectionConfig.directorFactory = self.directorFactory;
    projectionConfig.sizeContext = library.sizeContext;
    library.projectionStrategyManager = [[MDProjectionStrategyManager alloc]initWithDefault:self.projectionMode config:projectionConfig];
    library.interactiveStrategyManager = [[MDInteractiveStrategyManager alloc]initWithDefault:self.interactiveMode];
    library.displayStrategyManager = [[MDDisplayStrategyManager alloc]initWithDefault:self.displayMode];
    [library setupStrategyManager];
    
    // touch
    library.touchHelper.pinchEnabled = self.pinchEnabled;
    
    // display
    [library setupDisplay:self.viewController view:self.view];
    
    // last step
    [library setup];
     
    return library;
}

@end

#pragma mark MDSizeContext
@interface MDSizeContext(){
    float textureWidth;
    float textureHeight;
    float textureRatio;
    float viewportWidth;
    float viewportHeight;
    float viewportRatio;
}

@end

@implementation MDSizeContext
- (instancetype)init{
    self = [super init];
    if (self) {
        [self updateTextureWidth:3 height:2];
        [self updateViewportWidth:3 height:2];
    }
    return self;
}

- (void)updateTextureWidth:(float)width height:(float) height{
    textureWidth = width;
    textureHeight = height;
    textureRatio = textureWidth / textureHeight;
}

- (void)updateViewportWidth:(float)width height:(float) height{
    viewportWidth = width;
    viewportHeight = height;
    viewportRatio = viewportWidth / viewportHeight;
}

- (float) getTextureRatioValue{
    return self->textureRatio;
}

- (float) getViewportRatioValue{
    return self->viewportRatio;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%f %f %f %f,ratio1=%f,ratio2=%f", textureWidth,textureHeight,viewportWidth,viewportHeight,textureRatio,viewportRatio];
}

@end
