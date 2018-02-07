//
//  GPUImageTextureProcessor.h
//  MD360Player4iOS
//
//  Created by Asha on 2018/2/7.
//  Copyright © 2018年 ashqal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImage.h"
#import "MDVRLibrary.h"

@interface GPUImageTextureProcessor : NSObject<IMDTextureProcessor, GPUImageTextureOutputDelegate>
@property (nonatomic,strong) GPUImageTextureInput* gpuInput;
@property (nonatomic,strong) GPUImageTextureOutput* gpuOutput;
@property (nonatomic,strong) NSDate* startTime;
@property (nonatomic,strong) id<IMDTextureProcessCallback> callback;
@end

