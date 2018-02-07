//
//  GPUImageTextureProcessor.m
//  MD360Player4iOS
//
//  Created by Asha on 2018/2/7.
//  Copyright © 2018年 ashqal. All rights reserved.
//

#import "GPUImageTextureProcessor.h"
@implementation GPUImageTextureProcessor

- (void)dealloc {
    self.gpuOutput.delegate = nil;
}

-(void) processInit:(GLint)textureInput size:(CGSize)size {
    self.gpuInput = [[GPUImageTextureInput alloc] initWithTexture:textureInput size:size];
    self.gpuOutput = [[GPUImageTextureOutput alloc] init];
    self.gpuOutput.delegate = self;
    GPUImageColorInvertFilter* inputFilter = [[GPUImageColorInvertFilter alloc] init];
    [self.gpuInput addTarget:inputFilter];
    [inputFilter addTarget:self.gpuOutput];
    self.startTime = [[NSDate alloc] init];
}

-(void) processBegin:(id<IMDTextureProcessCallback>) callback {
    self.callback = callback;
    float currentTimeInMilliseconds = [[NSDate date] timeIntervalSinceDate:self.startTime] * 1000.0;
    [self.gpuInput processTextureWithFrameTime:CMTimeMake((int)currentTimeInMilliseconds, 1000)];
}

#pragma mark -
#pragma mark GPUImageTextureOutputDelegate delegate method
- (void)newFrameReadyFromTextureOutput:(GPUImageTextureOutput *)callbackTextureOutput {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSLog(@"GPUImageTextureOutput:%d", callbackTextureOutput.texture);
        if (self.callback != nil) {
            [self.callback processDone:callbackTextureOutput.texture];
            self.callback = nil;
        }
        // todo: should call in the next main tick
        [callbackTextureOutput doneWithTexture];
    });
}
@end

