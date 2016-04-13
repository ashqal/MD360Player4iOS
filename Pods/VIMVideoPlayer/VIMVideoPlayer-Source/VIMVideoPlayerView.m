//
//  VideoPlayerView.m
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

#import "VIMVideoPlayerView.h"
#import "VIMVideoPlayer.h"

@interface VIMVideoPlayerView () <VIMVideoPlayerDelegate>

@end

@implementation VIMVideoPlayerView

- (void)dealloc
{
    [self detachPlayer];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    VIMVideoPlayer *player = [[VIMVideoPlayer alloc] init];
    
    [self setPlayer:player];
}

#pragma mark - Public API

- (void)setPlayer:(VIMVideoPlayer *)player
{
    if (_player == player)
    {
        return;
    }
    
    [self detachPlayer];
    
    _player = player;
    
    [self attachPlayer];
}

- (void)setVideoFillMode:(NSString *)fillMode
{
    AVPlayerLayer *playerLayer = (AVPlayerLayer*)[self layer];
    playerLayer.videoGravity = fillMode;
}

#pragma mark - Private API

- (void)attachPlayer
{
    if (_player)
    {
        _player.delegate = self;
        
        [(AVPlayerLayer *)[self layer] setPlayer:_player.player];
    }
}

- (void)detachPlayer
{
    if (_player && _player.delegate == self)
    {
        _player.delegate = nil;
    }
    
    [(AVPlayerLayer *)[self layer] setPlayer:nil];
}

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

#pragma mark - VideoPlayerDelegate

- (void)videoPlayerIsReadyToPlayVideo:(VIMVideoPlayer *)videoPlayer
{
    if ([self.delegate respondsToSelector:@selector(videoPlayerViewIsReadyToPlayVideo:)])
    {
        [self.delegate videoPlayerViewIsReadyToPlayVideo:self];
    }
}

- (void)videoPlayerDidReachEnd:(VIMVideoPlayer *)videoPlayer
{
    if ([self.delegate respondsToSelector:@selector(videoPlayerViewDidReachEnd:)])
    {
        [self.delegate videoPlayerViewDidReachEnd:self];
    }
}

- (void)videoPlayer:(VIMVideoPlayer *)videoPlayer timeDidChange:(CMTime)cmTime
{
    if ([self.delegate respondsToSelector:@selector(videoPlayerView:timeDidChange:)])
    {
        [self.delegate videoPlayerView:self timeDidChange:cmTime];
    }
}

- (void)videoPlayer:(VIMVideoPlayer *)videoPlayer loadedTimeRangeDidChange:(float)duration
{
    if ([self.delegate respondsToSelector:@selector(videoPlayerView:loadedTimeRangeDidChange:)])
    {
        [self.delegate videoPlayerView:self loadedTimeRangeDidChange:duration];
    }
}

- (void)videoPlayerPlaybackBufferEmpty:(VIMVideoPlayer *)videoPlayer
{
    if ([self.delegate respondsToSelector:@selector(videoPlayerViewPlaybackBufferEmpty:)])
    {
        [self.delegate videoPlayerViewPlaybackBufferEmpty:self];
    }
}

- (void)videoPlayerPlaybackLikelyToKeepUp:(VIMVideoPlayer *)videoPlayer
{
    if ([self.delegate respondsToSelector:@selector(videoPlayerViewPlaybackLikelyToKeepUp:)])
    {
        [self.delegate videoPlayerViewPlaybackLikelyToKeepUp:self];
    }
}

- (void)videoPlayer:(VIMVideoPlayer *)videoPlayer didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(videoPlayerView:didFailWithError:)])
    {
        [self.delegate videoPlayerView:self didFailWithError:error];
    }
}

@end
