//
//  MD360Surface.h
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/7.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MD360Texture : NSObject

@property (nonatomic,readonly) int mWidth;
@property (nonatomic,readonly) int mHeight;

- (void) createTexture;
- (void) releaseTexture;
- (void) resize:(int)width height:(int)height;
@end
