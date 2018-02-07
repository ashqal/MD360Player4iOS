//
//  TextureProcessConfig.h
//  MDVRLibrary
//
//  Created by Asha on 2018/2/7.
//  Copyright © 2018年 asha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "IMDTextureProcessor.h"

@interface TextureProcessConfig : NSObject
@property (nonatomic,weak) EAGLSharegroup* sharegroup;
@property (nonatomic,strong) id <IMDTextureProcessor> processor;
@end
