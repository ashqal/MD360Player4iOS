//
//  VideoPlayerViewController.m
//  MD360Player4iOS
//
//  Created by ashqal on 16/5/21.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "MDVRLibrary.h"

@interface CustomDirectorFactory : NSObject<MD360DirectorFactory>
@end

@implementation CustomDirectorFactory

- (MD360Director*) createDirector:(int) index{
    MD360Director* director = [[MD360Director alloc]init];
    switch (index) {
        case 1:
            [director setEyeX:-2.0f];
            [director setLookX:-2.0f];
            break;
        default:
            break;
    }
    return director;
}

@end

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
    [config projectionMode:MDModeProjectionStereoSphere];
    [config displayMode:MDModeDisplayNormal];
    [config interactiveMode:MDModeInteractiveTouch];
    [config pinchEnabled:true];
    [config setDirectorFactory:[[CustomDirectorFactory alloc]init]];
    
    self.vrLibrary = [config build];
    /////////////////////////////////////////////////////// MDVRLibrary
    
    [self.player play];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
