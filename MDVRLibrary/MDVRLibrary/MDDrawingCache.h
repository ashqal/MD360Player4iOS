//
//  MDDrawingCache.h
//  MDVRLibrary
//
//  Created by Asha on 2017/7/2.
//  Copyright © 2017年 asha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface MDDrawingCache : NSObject
-(void) bindTotalWidth:(int)w totalHeight:(int)h;
-(void) unbind;
-(GLuint) getTextureOutput;
@end
