//
//  MDInteractiveStrategy.h
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/11.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDModeStrategy.h"
#import "MDProjectionStrategy.h"

@protocol IMDInteractiveMode <NSObject>
@optional
-(void) handleDragDistX:(float)distX distY:(float)distY;
@end

@interface MDInteractiveStrategyManager : MDModeManager<IMDInteractiveMode>
@property(nonatomic,weak) MDProjectionStrategyManager* projectionStrategyManager;

@end
