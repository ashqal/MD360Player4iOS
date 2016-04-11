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
//@property (nonatomic,strong) MD360Renderer* renderer;
@property (nonatomic,strong) MDInteractiveStrategyManager* interactiveStrategyManager;
@property (nonatomic,strong) NSMutableArray* renderers;
@property (nonatomic,strong) NSMutableArray* directors;

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
    }
    return self;
}

- (void) setup {
    self.interactiveStrategyManager.dirctors = self.directors;
    [self.interactiveStrategyManager prepare];

}

- (void) addDisplay:(CGRect)frame viewController:(UIViewController*)viewController view:(UIView*)parentView{
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
    glkViewController.touchDelegate = director;
    [glkViewController.view setFrame:frame];
    [parentView addSubview:glkViewController.view];
    if (viewController != nil) {
        [viewController addChildViewController:glkViewController];
        [glkViewController didMoveToParentViewController:viewController];
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

@end

#pragma mark MDVRConfiguration
@interface MDVRConfiguration()

@property (nonatomic,readonly) NSArray* vrFrames;
@property (nonatomic,readonly) MD360Texture* texture;
@property (nonatomic,readonly) UIViewController* viewController;
@property (nonatomic,readonly) UIView* view;
@property (nonatomic,readonly) MDModeInteractive interactiveMode;

@end

@implementation MDVRConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _interactiveMode = MDModeInteractiveTouch;
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

- (void) setFrames:(NSArray*)frames vc:(UIViewController*)vc {
    [self setFrames:frames vc:vc view:vc.view];
}

- (void) setFrames:(NSArray*)frames vc:(UIViewController*)vc  view:(UIView*)view{
    _vrFrames = frames;
    _viewController = vc;
    _view = view;
}

- (MDVRLibrary*) build{
    MDVRLibrary* library = [[MDVRLibrary alloc]init];
    library.texture = self.texture;
    library.interactiveStrategyManager = [[MDInteractiveStrategyManager alloc]initWithDefault:self.interactiveMode];
    
    for (NSValue* value in self.vrFrames) {
        [library addDisplay:[value CGRectValue] viewController:self.viewController view:self.view];
    }
    
    [library setup];
    return library;
}

@end
