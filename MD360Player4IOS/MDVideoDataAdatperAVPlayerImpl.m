//
//  MDVideoDataAdatperAVPlayerImpl.m
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/9.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "MDVideoDataAdatperAVPlayerImpl.h"

@interface MDVideoDataAdatperAVPlayerImpl ()
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
    
    [self.playerItem addOutput:self.output];

}

- (CVPixelBufferRef)copyPixelBuffer{
    CVPixelBufferRef pixelBuffer = [self.output copyPixelBufferForItemTime:[self.playerItem currentTime] itemTimeForDisplay:nil];
    return pixelBuffer;
}
@end
