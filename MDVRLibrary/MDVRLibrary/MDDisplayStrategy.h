//
//  MDDisplayStrategy.h
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/12.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDModeStrategy.h"
#import <UIKit/UIKit.h>
#import "BarrelDistortionConfig.h"

@interface MDDisplayStrategyManager : MDModeManager
@property (nonatomic, strong) BarrelDistortionConfig* barrelDistortionConfig;
- (int) getVisibleSize;
- (BOOL) isAntiDistortionEnabled;
- (void) setAntiDistortionEnabled:(BOOL)antiDistortionEnabled;
@end
