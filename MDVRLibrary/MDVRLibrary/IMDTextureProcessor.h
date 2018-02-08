//
//  MDTextureProcessor.h
//  MDVRLibrary
//
//  Created by Asha on 2018/2/7.
//  Copyright © 2018年 asha. All rights reserved.
//

#ifndef IMDTextureProcessor_h
#define IMDTextureProcessor_h

// @property(nonatomic, copy) void(^newFrameAvailableBlock)(void);

@protocol IMDTextureProcessCallback <NSObject>
-(void) processDone:(GLint) textureResult block:(void (^)()) block;
@end

@protocol IMDTextureProcessor <NSObject>
@required
-(void) processInit:(GLint)textureInput size:(CGSize)size;
-(void) processBegin:(id<IMDTextureProcessCallback>) callback;
@end

#endif /* IMDTextureProcessor_h */
