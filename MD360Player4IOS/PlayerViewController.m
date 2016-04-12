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
@property (nonatomic, strong) NSURL* mURL;
@end
@implementation PlayerViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)dealloc{
    NSLog(@"PlayerViewController dealloc");
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
    
    [config asVideo:playerItem];
    [config setFrames:[self twoFrames] vc:self];
    
    self.vrLibrary = [config build];
    /////////////////////////////////////////////////////// MDVRLibrary
}

- (IBAction)onCloseBtnClicked:(id)sender {
    [self.videoPlayerView.player reset];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onInteractiveModeBtnClicked:(id)sender {
    UIButton* button = sender;
    [self.vrLibrary switchInteractiveMode];
    int mode = [self.vrLibrary getInteractiveMdoe];
    NSString* label;
    if (mode == MDModeInteractiveTouch) {
        label = @"TOUCH";
    } else {
        label = @"MOTION";
    }
    [button setTitle:label forState:UIControlStateNormal];
}

- (NSArray*) twoFrames{
    float width = [[UIScreen mainScreen] bounds].size.width;
    float height = [[UIScreen mainScreen] bounds].size.height;
    int size = 2;
    float perWidth = width * 1.0f / size;
    CGRect frame1 = CGRectMake(0, 0, perWidth, height);
    CGRect frame2 = CGRectMake(perWidth, 0, perWidth, height);
    return [NSArray arrayWithObjects:[NSValue valueWithCGRect:frame1],[NSValue valueWithCGRect:frame2], nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
