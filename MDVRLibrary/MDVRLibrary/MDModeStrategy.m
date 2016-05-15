//
//  MDModeStrategy.m
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/11.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "MDModeStrategy.h"

@interface MDModeManager(){

}
@end
@implementation MDModeManager

- (instancetype)initWithDefault:(int)mode
{
    self = [super init];
    if (self) {
        _mMode = mode;
    }
    return self;
}

- (void) prepare{
    [self initMode:self.mMode];
}

- (void) initMode:(int)mode{
    if (self.mStrategy != nil) {
        [self.mStrategy off];
    }
    self.mStrategy = [self createStrategy:self.mMode];
    [self on];
}

-(void) on{
    [self.mStrategy on];
}

-(void) off{
    [self.mStrategy off];
}

- (void) switchMode:(int)mode{
    if (self.mMode == mode) return;
    _mMode = mode;
    [self initMode:self.mMode];
}

#pragma mark abstract
- (void) switchMode{}
- (id<IMDModeStrategy>) createStrategy:(int)mode{ return nil; }
@end


