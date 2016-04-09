//
//  MDVideoDataAdatperAVPlayerImpl.h
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/9.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDVideoDataAdapter.h"

@interface MDVideoDataAdatperAVPlayerImpl : NSObject<MDVideoDataAdapter>
- (instancetype)initWithPlayerItem:(AVPlayerItem*) playerItem;
@end
