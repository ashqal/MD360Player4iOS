//
//  MDAbsLinePipe.h
//  MDVRLibrary
//
//  Created by Asha on 2017/7/2.
//  Copyright © 2017年 asha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDDisplayStrategy.h"

@interface MDAbsLinePipe : NSObject
-(void) fireSetup:(EAGLContext*) context;
-(void) setup:(EAGLContext*) context;
-(void) takeOverTotalWidth:(int)w totalHeight:(int)h size:(int)size;
-(void) commitTotalWidth:(int)w totalHeight:(int)h size:(int)size texture:(GLint)texture;
-(GLint) getTextureId;
@end

@interface MDBarrelDistortionLinePipe : MDAbsLinePipe
-(instancetype)initWith:(MDDisplayStrategyManager*) displayManager;
@end
