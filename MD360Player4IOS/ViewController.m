//
//  ViewController.m
//  MD360Player4IOS
//
//  Created by ashqal on 16/3/27.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "ViewController.h"
#import "VIMVideoPlayerView.h"
#import "VIMVideoPlayer.h"
#import "GLUtil.h"
#import "MD360Program.h"
#import "MD360Renderer.h"
#import "MDGLKViewController.h"
#import "MDVideoDataAdatperAVPlayerImpl.h"
#import "MD360Texture.h"

@interface ViewController()<VIMVideoPlayerViewDelegate>{
}
@property (nonatomic, strong) VIMVideoPlayerView *videoPlayerView;
@property (nonatomic, strong) MD360Renderer* renderer;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // video player
    self.videoPlayerView = [[VIMVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    self.videoPlayerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.videoPlayerView.delegate = self;
    [self.videoPlayerView setVideoFillMode:AVLayerVideoGravityResizeAspect];
    [self.videoPlayerView.player enableTimeUpdates];
    [self.videoPlayerView.player enableAirplay];
    
    NSString* url = [[NSBundle mainBundle] pathForResource:@"skyrim360" ofType:@"mp4"];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:url]];
    [self.videoPlayerView.player setPlayerItem:playerItem];
    [self.videoPlayerView.player play];
    

    // renderer
    self.renderer = [[MD360Renderer alloc]init];
    
    // create Texture
    self.renderer.mTexture = [MD360VideoTexture createWithAVPlayerItem:playerItem];
    
    MDGLKViewController* glkViewController = [[MDGLKViewController alloc] init];
    glkViewController.rendererDelegate = self.renderer;
    glkViewController.touchDelegate = self.renderer.mDirector;
    [self.view addSubview:glkViewController.view];
    [self addChildViewController:glkViewController];
    [glkViewController didMoveToParentViewController:self];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
