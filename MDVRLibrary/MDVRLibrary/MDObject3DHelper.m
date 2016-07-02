//
//  MDObject3DHelper.m
//  MDVRLibrary
//
//  Created by ashqal on 16/7/2.
//  Copyright © 2016年 asha. All rights reserved.
//

#import "MDObject3DHelper.h"


@implementation MDObject3DHelper
+ (void) loadObj:(MDAbsObject3D*)obj{
    [obj executeLoad];
    [obj markChanged];
}
@end
