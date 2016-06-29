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

@interface MDProjectionStrategyManager : MDModeManager<IMDProjectionMode>
@property (nonatomic,strong) id<MD360DirectorFactory> directorFactory;
- (NSArray*) getDirectors;
@end
