//
//  MD360Surface.h
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/7.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MD360Surface : NSObject

@property (nonatomic,readonly) int mWidth;
@property (nonatomic,readonly) int mHeight;

- (void) createSurface;
- (void) releaseSurface;
- (void) resize:(int)width height:(int)height;
@end
