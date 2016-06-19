//
//  VideoPlayerViewController.m
//  MD360Player4iOS
//
//  Created by ashqal on 16/5/21.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "VideoPlayerViewController.h"

@interface VideoPlayerViewController ()<VIMVideoPlayerDelegate>
@property (nonatomic, strong) VIMVideoPlayer *player;
@property (nonatomic, strong) AVPlayer* avplayer;
@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) onClosed{
    [self.player reset];
}

- (void) initPlayer{
    // video player
    
    
      self.player = [[VIMVideoPlayer alloc] init];
    
     AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:self.mURL];
    
    //AVPlayer* avplayer = [[AVPlayer alloc]initWithPlayerItem:playerItem];
    //[avplayer play];
    
    [self.player setPlayerItem:playerItem];
    self.player.delegate = self;
    
    
    
    /////////////////////////////////////////////////////// MDVRLibrary
    MDVRConfiguration* config = [MDVRLibrary createConfig];
    
    [config displayMode:MDModeDisplayNormal];
    [config interactiveMode:MDModeInteractiveMotion];
    
    [config asVideo:playerItem];
    [config setContainer:self view:self.view];
    [config pinchEnabled:true];
    
    self.vrLibrary = [config build];
    /////////////////////////////////////////////////////// MDVRLibrary
    
    [self.player play];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)videoPlayerIsReadyToPlayVideo:(VIMVideoPlayer *)videoPlayer{
    NSLog(@"videoPlayerIsReadyToPlayVideo");
}
- (void)videoPlayerDidReachEnd:(VIMVideoPlayer *)videoPlayer{
    NSLog(@"videoPlayerDidReachEnd");
}
- (void)videoPlayer:(VIMVideoPlayer *)videoPlayer timeDidChange:(CMTime)cmTime{
    NSLog(@"timeDidChange");
}
- (void)videoPlayer:(VIMVideoPlayer *)videoPlayer loadedTimeRangeDidChange:(float)duration{
    NSLog(@"loadedTimeRangeDidChange");
}
- (void)videoPlayerPlaybackBufferEmpty:(VIMVideoPlayer *)videoPlayer{
    NSLog(@"videoPlayerPlaybackBufferEmpty");
}
- (void)videoPlayerPlaybackLikelyToKeepUp:(VIMVideoPlayer *)videoPlayer{
    NSLog(@"videoPlayerPlaybackLikelyToKeepUp");
}
- (void)videoPlayer:(VIMVideoPlayer *)videoPlayer didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError:%@",error);
}


@end
