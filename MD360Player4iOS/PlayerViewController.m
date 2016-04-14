//
//  PlayerViewController.m
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/11.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "PlayerViewController.h"
#import "VIMVideoPlayerView.h"
#import "VIMVideoPlayer.h"
#import "MDVRLibrary.h"

@interface PlayerViewController()<VIMVideoPlayerViewDelegate>{
}
@property (nonatomic, strong) VIMVideoPlayerView *videoPlayerView;
@property (nonatomic, strong) MDVRLibrary* vrLibrary;
@property (weak, nonatomic) IBOutlet UIButton *mInteractiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *mDisplayBtn;
@property (nonatomic, strong) NSURL* mURL;
@end
@implementation PlayerViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)dealloc{
}

- (void) initParams:(NSURL*)url{
    self.mURL = url;
    [self initPlayer];
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
    
    [config displayMode:MDModeDisplayGlass];
    [config interactiveMode:MDModeInteractiveMotion];
    [config asVideo:playerItem];
    [config setContainer:self view:self.view];
    
    self.vrLibrary = [config build];
    /////////////////////////////////////////////////////// MDVRLibrary
    
    [self syncDisplayLabel];
    [self syncInteractiveLabel];
}

- (IBAction)onCloseBtnClicked:(id)sender {
    [self.videoPlayerView.player reset];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onDisplayModeBtnClicked:(id)sender {
    [self.vrLibrary switchDisplayMode];
    [self syncDisplayLabel];
    
}

- (IBAction)onInteractiveModeBtnClicked:(id)sender {
    [self.vrLibrary switchInteractiveMode];
    [self syncInteractiveLabel];
}

-(void)syncDisplayLabel{
    int mode = [self.vrLibrary getDisplayMdoe];
    NSString* label;
    if (mode == MDModeDisplayNormal) {
        label = @"NORMAL";
    } else {
        label = @"GLASS";
    }
    [self.mDisplayBtn setTitle:label forState:UIControlStateNormal];
}


-(void)syncInteractiveLabel{
    int mode = [self.vrLibrary getInteractiveMdoe];
    NSString* label;
    if (mode == MDModeInteractiveTouch) {
        label = @"TOUCH";
    } else {
        label = @"MOTION";
    }
    [self.mInteractiveBtn setTitle:label forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
