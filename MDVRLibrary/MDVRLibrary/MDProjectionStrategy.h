//
//  MDProjectionStrategy.h
//  MDVRLibrary
//
//  Created by ashqal on 16/6/28.
//  Copyright © 2016年 asha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDModeStrategy.h"
#import "MDAbsObject3D.h"
#import "MD360Director.h"

@protocol IMDProjectionMode <NSObject>
@required
-(MDAbsObject3D*) getObject3D;
@end

@interface MDProjectionStrategyConfiguration : NSObject
@property (nonatomic,strong) id<MD360DirectorFactory> directorFactory;
@property (nonatomic,weak) MDSizeContext* sizeContext;
@end


@interface MDProjectionStrategyManager : MDModeManager<IMDProjectionMode>
- (instancetype)initWithDefault:(int)mode config:(MDProjectionStrategyConfiguration*) config;
- (NSArray*) getDirectors;
@end
