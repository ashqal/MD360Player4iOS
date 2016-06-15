//
//  VideoPlayerViewController.m
//  MD360Player4iOS
//
//  Created by ashqal on 16/5/21.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "VideoPlayerViewController.h"

@interface VideoPlayerViewController ()<VIMVideoPlayerViewDelegate>
@property (nonatomic, strong) VIMVideoPlayerView *videoPlayerView;
@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) onClosed{
  [self.videoPlayerView.player reset];
}

- (void) initPlayer{
    // video player
    
     self.videoPlayerView = [[VIMVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
     self.videoPlayerView.translatesAutoresizingMaskIntoConstraints = NO;
     self.videoPlayerView.delegate = self;
     [self.videoPlayerView setVideoFillMode:AVLayerVideoGravityResizeAspect];
     [self.videoPlayerView.player enableTimeUpdates];
     [self.videoPlayerView.player enableAirplay];
     
     AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:self.mURL];
     [self.videoPlayerView.player setPlayerItem:playerItem];
     
    [self.videoPlayerView.player play];
    
    
    /////////////////////////////////////////////////////// MDVRLibrary
    MDVRConfiguration* config = [MDVRLibrary createConfig];
    
    [config displayMode:MDModeDisplayNormal];
    [config interactiveMode:MDModeInteractiveMotion];
    
    [config asVideo:playerItem];
    [config setContainer:self view:self.view];
    [config pinchEnabled:true];
    
    self.vrLibrary = [config build];
    /////////////////////////////////////////////////////// MDVRLibrary
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
