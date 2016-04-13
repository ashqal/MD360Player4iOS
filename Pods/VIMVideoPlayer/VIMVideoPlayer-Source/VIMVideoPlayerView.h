//
//  VideoPlayerView.h
//  Vimeo
//
//  Created by Alfred Hanssen on 2/9/14.
//  Copyright (c) 2014-2015 Vimeo (https://vimeo.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

@import Foundation;
@import AVFoundation;
@import UIKit;

@class VIMVideoPlayer;
@class VIMVideoPlayerView;

@protocol VIMVideoPlayerViewDelegate <NSObject>

@optional
- (void)videoPlayerViewIsReadyToPlayVideo:(VIMVideoPlayerView *)videoPlayerView;
- (void)videoPlayerViewDidReachEnd:(VIMVideoPlayerView *)videoPlayerView;
- (void)videoPlayerView:(VIMVideoPlayerView *)videoPlayerView timeDidChange:(CMTime)cmTime;
- (void)videoPlayerView:(VIMVideoPlayerView *)videoPlayerView loadedTimeRangeDidChange:(float)duration;
- (void)videoPlayerViewPlaybackBufferEmpty:(VIMVideoPlayerView *)videoPlayerView;
- (void)videoPlayerViewPlaybackLikelyToKeepUp:(VIMVideoPlayerView *)videoPlayerView;
- (void)videoPlayerView:(VIMVideoPlayerView *)videoPlayerView didFailWithError:(NSError *)error;

@end

@interface VIMVideoPlayerView : UIView

@property (nonatomic, weak) id<VIMVideoPlayerViewDelegate> delegate;

@property (nonatomic, strong) VIMVideoPlayer *player;

- (void)setPlayer:(VIMVideoPlayer *)player;

- (void)setVideoFillMode:(NSString *)fillMode;

@end
