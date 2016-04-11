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
#import "MDVRLibrary.h"


@interface ViewController()<VIMVideoPlayerViewDelegate>{
}
@property (nonatomic, strong) VIMVideoPlayerView *videoPlayerView;
@property (nonatomic, strong) MDVRLibrary* vrLibrary;
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
    
    
    
    /////////////////////////////////////////////////////// MDVRLibrary
    MDVRConfiguration* config = [MDVRLibrary createConfig];
    
    [config asVideo:playerItem];
    [config setFrames:[self twoFrames] vc:self];
    
    self.vrLibrary = [config build];
    /////////////////////////////////////////////////////// MDVRLibrary
    
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
