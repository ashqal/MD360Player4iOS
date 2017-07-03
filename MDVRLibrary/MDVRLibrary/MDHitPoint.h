//
//  MDHitPoint.h
//  MDVRLibrary
//
//  Created by Asha on 2017/5/11.
//  Copyright © 2017年 asha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>

@interface MDHitPoint : NSObject
@property (nonatomic) float distance;
@property (nonatomic) float u;
@property (nonatomic) float v;
- (void) asNotHit;
- (BOOL) isNotHit;

@end
