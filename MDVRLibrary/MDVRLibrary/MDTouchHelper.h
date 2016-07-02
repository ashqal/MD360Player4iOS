//
//  MDTouchHelper.h
//  MDVRLibrary
//
//  Created by ashqal on 16/5/15.
//  Copyright © 2016年 asha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#pragma mark IAdvanceGestureListener
@protocol IAdvanceGestureListener <NSObject>
- (void) onDragDistanceX:(float)distanceX distanceY:(float)distanceY;
- (void) onPinch:(float)scale;
@end

@interface MDTouchHelper : NSObject
- (void) registerTo:(UIView*) view;
@property (nonatomic) bool pinchEnabled;
@property (nonatomic,weak) id<IAdvanceGestureListener> advanceGestureListener;
@end




