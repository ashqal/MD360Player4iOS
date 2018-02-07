//
//  CustomDirectorFactory.m
//  MD360Player4iOS
//
//  Created by Asha on 2018/2/7.
//  Copyright © 2018年 ashqal. All rights reserved.
//

#import "CustomDirectorFactory.h"

@implementation CustomDirectorFactory

- (MD360Director*) createDirector:(int) index{
    MD360Director* director = [[MD360Director alloc]init];
    switch (index) {
        case 1:
            [director setEyeX:-2.0f];
            [director setLookX:-2.0f];
            break;
        default:
            break;
    }
    return director;
}

@end
