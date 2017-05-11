//
//  MDHotspot.h
//  MDVRLibrary
//
//  Created by Asha on 2017/5/11.
//  Copyright © 2017年 asha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDAbsPlugin.h"
#import "MDHitPoint.h"
#import "MDRay.h"
#import "MDHitEvent.h"

@protocol IMDHotspot <NSObject>

@required

- (MDHitPoint*) hit:(MDRay*) ray;
- (void) onEyeHitIn:(MDHitEvent*) hitEvent;
- (void) onEyeHitOut:(long) timestamp;
- (void) onTouchHit:(MDRay*) ray;
- (NSString*) getTitle;
- (NSString*) getTag;
- (void) rotateToCamera;
@end

@interface MDHotspot : MDAbsPlugin<IMDHotspot>

@end
