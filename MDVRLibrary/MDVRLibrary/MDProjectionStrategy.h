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

@protocol IMDProjectionMode <NSObject>
@required
-(MDAbsObject3D*) getObject3D;
@end

@interface MDProjectionStrategyManager : MDModeManager<IMDProjectionMode>

@end
