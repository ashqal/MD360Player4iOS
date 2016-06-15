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
- (void)dealloc{
}

- (void) off{

}

- (int) getVisibleSize { return 0; }

@end

#pragma mark MDNormalStrategy
@interface MDNormalStrategy:MDDisplayStrategy
@end

@implementation MDNormalStrategy
-(void) on{
    // [self setVisibleSize:1];
}

- (int) getVisibleSize {
    return 1;
}
@end

#pragma mark MDGlassStrategy
@interface MDGlassStrategy:MDDisplayStrategy
@end

@implementation MDGlassStrategy
-(void) on{
    // [self setVisibleSize:2];
}

- (int) getVisibleSize {
    return 2;
}
@end


#pragma mark MDDisplayStrategyManager
@implementation MDDisplayStrategyManager
- (void) switchMode{
    int newMode = self.mMode == MDModeDisplayNormal ? MDModeDisplayGlass : MDModeDisplayNormal;
    [self switchMode:newMode];
}

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
@end
