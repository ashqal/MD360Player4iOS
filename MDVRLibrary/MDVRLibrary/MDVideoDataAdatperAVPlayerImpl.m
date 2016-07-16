//
//  MDVideoDataAdatperAVPlayerImpl.m
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/9.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "MDVideoDataAdatperAVPlayerImpl.h"

@interface MDVideoDataAdatperAVPlayerImpl ()<AVPlayerItemOutputPullDelegate>
@property (nonatomic, strong) AVPlayerItemVideoOutput* output;
@property (nonatomic, strong) AVPlayerItem* playerItem;

@end

static void *VideoPlayer_PlayerItemStatusContext = &VideoPlayer_PlayerItemStatusContext;

@implementation MDVideoDataAdatperAVPlayerImpl

- (instancetype)initWithPlayerItem:(AVPlayerItem*) playerItem{
    self = [super init];
    if (self) {
        self.playerItem = playerItem;
        [self addObserver];
        
    }
    return self;
}

- (void) addObserver{
    [self.playerItem addObserver:self
                 forKeyPath:NSStringFromSelector(@selector(status))
                    options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                    context:VideoPlayer_PlayerItemStatusContext];
}

- (void) removeObserver{
    if (self.playerItem == nil) {
        return;
    }
    
    @try {
        [self.playerItem removeObserver:self
                        forKeyPath:NSStringFromSelector(@selector(status))
                           context:VideoPlayer_PlayerItemStatusContext];
    } @catch (NSException *exception) {
        NSLog(@"Exception removing observer: %@", exception);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (context == VideoPlayer_PlayerItemStatusContext) {
        AVPlayerStatus newStatus = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        // AVPlayerStatus oldStatus = [[change objectForKey:NSKeyValueChangeOldKey] integerValue];
        
        if (newStatus == AVPlayerItemStatusReadyToPlay && self.output == nil) {
            [self setup];
        }
    }
}

- (void) setup{
    NSDictionary *pixBuffAttributes = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
    self.output = [[AVPlayerItemVideoOutput alloc] initWithPixelBufferAttributes:pixBuffAttributes];
    [self.playerItem addOutput:self.output];
}

- (void)teardown{
    if (self.playerItem != nil && self.output != nil) {
        [self.playerItem removeOutput:self.output];
        self.output = nil;
    }
}

- (CVPixelBufferRef)copyPixelBuffer{
    if (self.output == nil) {
        return nil;
    }
    
    CMTime currentTime = [self.playerItem currentTime];
    if([self.output hasNewPixelBufferForItemTime:currentTime]){
        return [self.output copyPixelBufferForItemTime:currentTime itemTimeForDisplay:nil];
    } else {
        return nil;
    }
    
}

- (void)dealloc{
    [self removeObserver];
    [self teardown];
}

@end
