//
//  MDTouchHelper.m
//  MDVRLibrary
//
//  Created by ashqal on 16/5/15.
//  Copyright © 2016年 asha. All rights reserved.
//

#import "MDTouchHelper.h"

@interface MDTouchHelper(){
    CGPoint prevPoint;
}
@property (nonatomic,strong) UIPanGestureRecognizer* panGestureRecognizer;

@end

@implementation MDTouchHelper

static float sMDDamping = 0.2f;

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
}


- (void) registerTo:(UIView*) view{
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestures:)];
    self.panGestureRecognizer.minimumNumberOfTouches = 1;
    self.panGestureRecognizer.maximumNumberOfTouches = 1;
    [view addGestureRecognizer:self.panGestureRecognizer];
    
}

-(void)handlePanGestures:(UIPanGestureRecognizer *)paramSender{
    if (paramSender.state == UIGestureRecognizerStateBegan) {
        prevPoint = [paramSender locationInView:paramSender.view.superview];
    } else if (paramSender.state != UIGestureRecognizerStateEnded && paramSender.state != UIGestureRecognizerStateFailed) {
        CGPoint location = [paramSender locationInView:paramSender.view.superview];
        if([self.advanceGestureListener respondsToSelector:@selector(onDragDistanceX:distanceY:)]){
            float deltaX = (location.x - prevPoint.x) * sMDDamping;
            float deltaY = (location.y - prevPoint.y) * sMDDamping;
            [self.advanceGestureListener onDragDistanceX:deltaX distanceY:deltaY];
        }
        prevPoint = location;
    }
}

@end
