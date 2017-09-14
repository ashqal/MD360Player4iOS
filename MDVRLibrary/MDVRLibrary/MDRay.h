//
//  MDRay.h
//  MDVRLibrary
//
//  Created by Asha on 2017/5/11.
//  Copyright © 2017年 asha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDVector3D.h"

@interface MDRay : NSObject

@property (nonatomic, strong) MDVector3D* orig;
@property (nonatomic, strong) MDVector3D* dir;

@end
