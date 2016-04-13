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
@property(nonatomic,weak) NSArray* glViewControllers;
@property(nonatomic) CGRect bounds;
@end

@implementation MDDisplayStrategy
- (void)dealloc{
    self.glViewControllers = nil;
}

- (void) off{

}

+ (NSArray*) frames:(int)size{
    float width = [[UIScreen mainScreen] bounds].size.width;
    float height = [[UIScreen mainScreen] bounds].size.height;
    float perWidth = width * 1.0f / size;
    NSMutableArray* frames = [[NSMutableArray alloc] init];
    for (int i = 0; i < size; i++) {
        [frames addObject:[NSValue valueWithCGRect:CGRectMake( i * perWidth, 0, perWidth, height)]];
    }
    return frames;
}

- (void) setVisibleSize:(int)max{
    NSArray* frames = [MDDisplayStrategy frames:max];
    for (int i = 0; i < self.glViewControllers.count; i++) {
        MDGLKViewController* vc = [self.glViewControllers objectAtIndex:i];
        if (i < max) {
            NSValue* value = [frames objectAtIndex:i];
            CGRect frame = value.CGRectValue;
            [vc setPendingVisible:YES frame:frame];
        } else {
            [vc setPendingVisible:NO frame:vc.view.frame];
        }
    }
}

@end

#pragma mark MDNormalStrategy
@interface MDNormalStrategy:MDDisplayStrategy
@end

@implementation MDNormalStrategy
-(void) on{
    [self setVisibleSize:1];
}
@end

#pragma mark MDGlassStrategy
@interface MDGlassStrategy:MDDisplayStrategy
@end

@implementation MDGlassStrategy
-(void) on{
    [self setVisibleSize:2];
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
            strategy.glViewControllers = self.glViewControllers;
            strategy.bounds = self.bounds;
            break;
        case MDModeDisplayNormal:
        default:
            strategy = [[MDNormalStrategy alloc] init];
            strategy.glViewControllers = self.glViewControllers;
            strategy.bounds = self.bounds;
            break;
    }
    return strategy;
}
@end
