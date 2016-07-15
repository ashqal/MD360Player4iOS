//
//  MDIJKHelper.m
//  MDVRLibrary
//
//  Created by ashqal on 16/7/16.
//  Copyright © 2016年 asha. All rights reserved.
//

#import "MDVRHeader.h"

@implementation MDIJKAdapter

+ (MDVideoFrameAdapter*) wrap:(id)ijk_sdl_view{
    
    MDIJKAdapter* adapter = [[MDIJKAdapter alloc] init];
    
    id<MDIJKSDLGLView> setter = (id<MDIJKSDLGLView>)ijk_sdl_view;
    if ([setter respondsToSelector:@selector(setFrameCallback:)]) {
        [setter setFrameCallback:adapter];
    }
    
    return adapter;
}
@end
