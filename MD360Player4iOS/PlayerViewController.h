//
//  PlayerViewController.h
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/11.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIMVideoPlayerView.h"
#import "VIMVideoPlayer.h"
#import "MDVRLibrary.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PlayerViewController : UIViewController
@property (nonatomic, strong) MDVRLibrary* vrLibrary;
@property (nonatomic, strong) NSURL* mURL;
- (void) initParams:(NSURL*)url;
- (void) onClosed;
@end
