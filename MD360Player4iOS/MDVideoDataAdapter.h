//
//  MDVideoDataAdapter.h
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/9.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol MDVideoDataAdapter <NSObject>
- (CVPixelBufferRef)copyPixelBuffer;
@end