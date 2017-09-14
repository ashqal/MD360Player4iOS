//
//  MDHotspot.m
//  MDVRLibrary
//
//  Created by Asha on 2017/5/11.
//  Copyright © 2017年 asha. All rights reserved.
//

#import "MDHotspot.h"

@implementation MDHotspot
- (MDHitPoint*) hit:(MDRay*) ray { return nil; }
- (void) onEyeHitIn:(MDHitEvent*) hitEvent {}
- (void) onEyeHitOut:(long) timestamp {}
- (void) onTouchHit:(MDRay*) ray {}
- (NSString*) getTitle { return nil; }
- (NSString*) getTag { return nil; }
- (void) rotateToCamera {}
@end
