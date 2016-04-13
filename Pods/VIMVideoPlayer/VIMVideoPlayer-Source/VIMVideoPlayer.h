//
//  VideoPlayer.h
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

@class VIMVideoPlayer;

@protocol VIMVideoPlayerDelegate <NSObject>

@optional
- (void)videoPlayerIsReadyToPlayVideo:(VIMVideoPlayer *)videoPlayer;
- (void)videoPlayerDidReachEnd:(VIMVideoPlayer *)videoPlayer;
- (void)videoPlayer:(VIMVideoPlayer *)videoPlayer timeDidChange:(CMTime)cmTime;
- (void)videoPlayer:(VIMVideoPlayer *)videoPlayer loadedTimeRangeDidChange:(float)duration;
- (void)videoPlayerPlaybackBufferEmpty:(VIMVideoPlayer *)videoPlayer;
- (void)videoPlayerPlaybackLikelyToKeepUp:(VIMVideoPlayer *)videoPlayer;
- (void)videoPlayer:(VIMVideoPlayer *)videoPlayer didFailWithError:(NSError *)error;

@end

@interface VIMVideoPlayer : NSObject

@property (nonatomic, weak) id<VIMVideoPlayerDelegate> delegate;

@property (nonatomic, strong, readonly) AVPlayer *player;

@property (nonatomic, assign, getter=isPlaying, readonly) BOOL playing;
@property (nonatomic, assign, getter=isLooping) BOOL looping;
@property (nonatomic, assign, getter=isMuted) BOOL muted;

- (void)setURL:(NSURL *)URL;
- (void)setPlayerItem:(AVPlayerItem *)playerItem;
- (void)setAsset:(AVAsset *)asset;

// Playback

- (void)play;
- (void)pause;
- (void)seekToTime:(float)time;
- (void)reset;

// AirPlay

- (void)enableAirplay;
- (void)disableAirplay;
- (BOOL)isAirplayEnabled;

// Time Updates

- (void)enableTimeUpdates; // TODO: need these? no
- (void)disableTimeUpdates;

// Scrubbing

- (void)startScrubbing;
- (void)scrub:(float)time;
- (void)stopScrubbing;

// Volume

- (void)setVolume:(float)volume;
- (void)fadeInVolume;
- (void)fadeOutVolume;

@end
