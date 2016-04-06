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
#import "MDAbsObject3D.h"
#import "MD360Program.h"

@interface ViewController()<VIMVideoPlayerViewDelegate>{
}
@property (nonatomic, strong) VIMVideoPlayerView *videoPlayerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.videoPlayerView = [[VIMVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    self.videoPlayerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.videoPlayerView.delegate = self;
    
    [self.videoPlayerView setVideoFillMode:AVLayerVideoGravityResizeAspect];
    [self.videoPlayerView.player enableTimeUpdates];
    [self.videoPlayerView.player enableAirplay];
    
    [self.view addSubview:self.videoPlayerView];
    
    NSString* url = [[NSBundle mainBundle] pathForResource:@"skyrim360" ofType:@"mp4"];
    NSLog(@"url:%@",url);
    [self.videoPlayerView.player setURL:[NSURL fileURLWithPath:url]];
    [self.videoPlayerView.player play];
    
    MDAbsObject3D* obj3d = [[MDSphere3D alloc]init];
    [obj3d loadObj];
    
    EAGLContext *theContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:theContext];
    
    MD360Program* program = [[MD360Program alloc]init];
    [program build];
    [program use];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
