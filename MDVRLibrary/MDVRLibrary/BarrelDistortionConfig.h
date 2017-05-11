//
//  BarrelDistortionConfig.h
//  MDVRLibrary
//
//  Created by Asha on 2017/5/11.
//  Copyright © 2017年 asha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarrelDistortionConfig : NSObject

@property (nonatomic) double paramA;
@property (nonatomic) double paramB;
@property (nonatomic) double paramC;
@property (nonatomic) float scale;
@property (nonatomic) BOOL defaultEnabled;

@end
