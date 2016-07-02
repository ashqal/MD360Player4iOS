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
@property(nonatomic,strong) NSArray* mModes;

@end


@implementation MDModeManager

- (instancetype)initWithDefault:(int)mode{
    self = [super init];
    if (self) {
        _mMode = mode;
        self.mModes = [self createModes];
    }
    return self;
}

- (void) prepare{
    [self initMode:self.mMode];
}

- (void) initMode:(int)mode{
    [self off];
    self.mStrategy = [self createStrategy:self.mMode];
    [self on];
}

-(void) on{
    if ([self.mStrategy respondsToSelector:@selector(on)]) {
        [self.mStrategy on];
    }
}

-(void) off{
    if ([self.mStrategy respondsToSelector:@selector(off)]) {
        [self.mStrategy off];
    }
}

- (void) switchMode:(int)mode{
    if (self.mMode == mode) return;
    _mMode = mode;
    [self initMode:self.mMode];
}

- (void) switchMode{
    NSUInteger index = [self.mModes indexOfObject:[NSNumber numberWithInt:self.mMode]];
    index ++;
    NSNumber* nextMode = [self.mModes objectAtIndex:(index % self.mModes.count)];
    [self switchMode:[nextMode intValue]];
}


#pragma mark abstract
- (id) createStrategy:(int)mode{ return nil; }
- (NSArray*) createModes{ return nil; }
@end


