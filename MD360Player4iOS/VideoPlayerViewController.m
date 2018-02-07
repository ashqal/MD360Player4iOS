//
//  VideoPlayerViewController.m
//  MD360Player4iOS
//
//  Created by ashqal on 16/5/21.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "MDVRLibrary.h"
#import "GPUImage.h"
#import "CustomDirectorFactory.h"
#import "GPUImageTextureProcessor.h"

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
    [self.player setPlayerItem:playerItem];
    self.player.delegate = self;
    
    /////////////////////////////////////////////////////// MDVRLibrary
    MDVRConfiguration* config = [MDVRLibrary createConfig];
    
    [config asVideo:playerItem];
    [config setContainer:self view:self.view];
    
    // optional
    [config projectionMode:MDModeProjectionSphere];
    [config displayMode:MDModeDisplayNormal];
    [config interactiveMode:MDModeInteractiveTouch];
    [config pinchEnabled:true];
    [config setDirectorFactory:[[CustomDirectorFactory alloc] init]];
    [config setBarrelDistortionConfig:[[BarrelDistortionConfig alloc] init]];
    
    // gpuimage processor
    TextureProcessConfig* textureProcessConfig = [[TextureProcessConfig alloc] init];
    textureProcessConfig.sharegroup = [[[GPUImageContext sharedImageProcessingContext] context] sharegroup];
    textureProcessConfig.processor = [[GPUImageTextureProcessor alloc] init];
    [config setTextureProcessConfig:textureProcessConfig];
    
    self.vrLibrary = [config build];
    [self.vrLibrary setAntiDistortionEnabled:YES];
    /////////////////////////////////////////////////////// MDVRLibrary
    
    [self.player play];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

