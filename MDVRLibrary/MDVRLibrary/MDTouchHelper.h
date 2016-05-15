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

/*
#pragma mark MDTouchDelegate
@protocol MDTouchDelegate <NSObject>
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
@end
 */

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




