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

@implementation MDVideoDataAdatperAVPlayerImpl

- (instancetype)initWithPlayerItem:(AVPlayerItem*) playerItem{
    self = [super init];
    if (self) {
        self.playerItem = playerItem;
        [self setup];
    }
    return self;
}

- (void) setup{
    NSDictionary *pixBuffAttributes = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
    self.output = [[AVPlayerItemVideoOutput alloc] initWithPixelBufferAttributes:pixBuffAttributes];
    [self.output setDelegate:self queue:dispatch_get_main_queue()];
    [self.playerItem addOutput:self.output];

}

- (CVPixelBufferRef)copyPixelBuffer{
    CMTime currentTime = [self.playerItem currentTime];
    if([self.output hasNewPixelBufferForItemTime:currentTime]){
        // NSLog(@"copyPixelBuffer:%ld",currentTime.value / currentTime.timescale);
        return [self.output copyPixelBufferForItemTime:currentTime itemTimeForDisplay:nil];
    } else {
        // NSLog(@"copyPixelBuffer nil:%ld",currentTime.value / currentTime.timescale);
        return nil;
    }
    
    
    
}

- (void)dealloc{
    if (self.playerItem != nil && self.output != nil) {
        [self.playerItem removeOutput:self.output];
        self.output = nil;
        self.playerItem = nil;
    }
}

- (void)outputMediaDataWillChange:(AVPlayerItemOutput *)sender{
    NSLog(@"outputMediaDataWillChange");
}

/*!
	@method			outputSequenceWasFlushed:
	@abstract		A method invoked when the output is commencing a new sequence.
	@discussion
 This method is invoked after any seeking and change in playback direction. If you are maintaining any queued future samples, copied previously, you may want to discard these after receiving this message.
 */

- (void)outputSequenceWasFlushed:(AVPlayerItemOutput *)output{

    NSLog(@"outputSequenceWasFlushed");
}
@end
