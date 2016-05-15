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
    float prevScale;
    float currentScale;
}
@property (nonatomic,strong) UIPanGestureRecognizer* panGestureRecognizer;
@property (nonatomic,strong) UIPinchGestureRecognizer* pinchGestureRecognizer;

@end

@implementation MDTouchHelper

static float sMDDamping = 0.2f;
static float sScaleMin = 1.0f;
static float sScaleMax = 4.0f;

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    currentScale = prevScale = sScaleMin;
}


- (void) registerTo:(UIView*) view{
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestures:)];
    self.panGestureRecognizer.minimumNumberOfTouches = 1;
    self.panGestureRecognizer.maximumNumberOfTouches = 1;
    [view addGestureRecognizer:self.panGestureRecognizer];
    
    if (self.pinchEnabled) {
        self.pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinches:)];
        [view addGestureRecognizer:self.pinchGestureRecognizer];
    }
}

-(void)handlePanGestures:(UIPanGestureRecognizer *)paramSender{
    if (paramSender.state == UIGestureRecognizerStateBegan) {
        prevPoint = [paramSender locationInView:paramSender.view.superview];
    } else if (paramSender.state != UIGestureRecognizerStateEnded && paramSender.state != UIGestureRecognizerStateFailed) {
        CGPoint location = [paramSender locationInView:paramSender.view.superview];
        if([self.advanceGestureListener respondsToSelector:@selector(onDragDistanceX:distanceY:)]){
            float deltaX = (location.x - prevPoint.x) * sMDDamping;
            float deltaY = (location.y - prevPoint.y) * sMDDamping;
            [self.advanceGestureListener onDragDistanceX:deltaX/currentScale distanceY:deltaY/currentScale];
        }
        prevPoint = location;
    }
}

-(void)handlePinches:(UIPinchGestureRecognizer *)paramSender{
    if (paramSender.state != UIGestureRecognizerStateEnded && paramSender.state != UIGestureRecognizerStateFailed) {
        if (paramSender.scale != NAN && paramSender.scale != 0.0) {
            float scale = paramSender.scale - 1;
            if (scale < 0) scale *= (sScaleMax - sScaleMin);
            currentScale = scale + prevScale;
            currentScale = [self validateScale:currentScale];
            if ([self.advanceGestureListener respondsToSelector:@selector(onPinch:)]) {
                [self.advanceGestureListener onPinch:currentScale];
            }
        }
    } else if(paramSender.state == UIGestureRecognizerStateEnded){
        prevScale = currentScale;
    }
}

-(float)validateScale:(float)scale{
    if (scale < sScaleMin) scale = sScaleMin;
    else if (scale > sScaleMax) scale = sScaleMax;
    return scale;
}

@end
