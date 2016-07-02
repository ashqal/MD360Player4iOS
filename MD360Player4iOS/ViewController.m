//
//  ViewController.m
//  MD360Player4IOS
//
//  Created by ashqal on 16/3/27.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <AFNetworking/AFNetworking.h>
#import "BitmapPlayerViewController.h"
#import "VideoPlayerViewController.h"


@interface ViewController(){
}
@property (nonatomic,strong) AFHTTPSessionManager* manager;
@property (weak, nonatomic) IBOutlet UIButton *mRefreshBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
}
- (IBAction)onRequestBtnClicked:(id)sender {
    [self request];
}

- (void) request{
    if (self.mRefreshBtn != nil) {
        [self.mRefreshBtn setEnabled:NO];
    }
    NSString* url = @"http://mnew14.yyport.com/videoset/video.json";
    [self.manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {}
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
             NSString* url = [dic objectForKey:@"url"];
             if (url != nil) {
                [self.mUrlTextView setText:url];
             }
             if (self.mRefreshBtn != nil) {
                 [self.mRefreshBtn setEnabled:YES];
             }
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);
             if (self.mRefreshBtn != nil) {
                 [self.mRefreshBtn setEnabled:YES];
             }
         }
     ];
}

- (IBAction)onNetworkButton:(id)sender {
    NSString* url = self.mUrlTextView.text;
    [self launchAsVideo:[NSURL URLWithString:url]];
}

- (IBAction)onLocalButton:(id)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"skyrim360" ofType:@"mp4"];
    // NSURL* url = [NSURL URLWithString:@"http://192.168.5.106/vr/stereo.mp4"];
    [self launchAsVideo:[NSURL fileURLWithPath:path]];
}
- (IBAction)onImageButton:(id)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"dome_pic" ofType:@"jpg"];
    [self launchAsImage:[NSURL fileURLWithPath:path]];
    //[self launchAsImage:[NSURL URLWithString:@"http://image5.tuku.cn/wallpaper/Landscape%20Wallpapers/8750_2560x1600.jpg"]];
}

- (void)launchAsVideo:(NSURL*)url {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"VideoPlayer" bundle:nil];
    PlayerViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
    
    [self presentViewController:vc animated:NO completion:^{
        [vc initParams:url];
    }];
}


- (void)launchAsImage:(NSURL*)url {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BitmapPlayer" bundle:nil];
    PlayerViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"BitmapPlayerViewController"];
    
    [self presentViewController:vc animated:NO completion:^{
        [vc initParams:url];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
