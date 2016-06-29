//
//  MDDisplayStrategy.m
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/12.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "MDDisplayStrategy.h"
#import "MDVRLibrary.h"
#import "MDGLKViewController.h"

#pragma mark MDDisplayStrategy
@interface MDDisplayStrategy: NSObject<IMDModeStrategy>

@end

@implementation MDDisplayStrategy

- (int) getVisibleSize {
    return 0;
}

@end

#pragma mark MDNormalStrategy
@interface MDNormalStrategy:MDDisplayStrategy
@end

@implementation MDNormalStrategy

- (int) getVisibleSize {
    return 1;
}
@end

#pragma mark MDGlassStrategy
@interface MDGlassStrategy:MDDisplayStrategy
@end

@implementation MDGlassStrategy

- (int) getVisibleSize {
    return MULTI_SCREEN_SIZE;
}
@end


#pragma mark MDDisplayStrategyManager
@implementation MDDisplayStrategyManager

- (id<IMDModeStrategy>) createStrategy:(int)mode{
    MDDisplayStrategy* strategy;
    switch (mode) {
        case MDModeDisplayGlass:
            strategy = [[MDGlassStrategy alloc] init];
            break;
        case MDModeDisplayNormal:
        default:
            strategy = [[MDNormalStrategy alloc] init];
            break;
    }
    return strategy;
}

- (int) getVisibleSize{
    MDDisplayStrategy* strategy = self.mStrategy;
    return [strategy getVisibleSize];
}

- (NSArray*) createModes{
    return [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:MDModeDisplayNormal], [NSNumber numberWithInt:MDModeDisplayGlass], nil];
}
@end
