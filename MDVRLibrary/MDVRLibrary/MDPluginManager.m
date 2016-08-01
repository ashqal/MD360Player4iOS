//
//  MDPluginManager.m
//  MDVRLibrary
//
//  Created by ashqal on 16/7/31.
//  Copyright © 2016年 asha. All rights reserved.
//

#import "MDAbsPlugin.h"

@interface MDPluginManager()

@property (nonatomic,strong) NSMutableArray* plugins;

@end

@implementation MDPluginManager

- (instancetype)init{
    self = [super init];
    if (self) {
        self.plugins = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void) add:(MDAbsPlugin*) plugin{
    [self.plugins addObject:plugin];
}

- (NSArray*) getPlugins{
    return self.plugins;
}

@end
