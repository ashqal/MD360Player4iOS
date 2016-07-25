//
//  MDProjectionStrategy.m
//  MDVRLibrary
//
//  Created by ashqal on 16/6/28.
//  Copyright © 2016年 asha. All rights reserved.
//

#import "MDProjectionStrategy.h"
#import "MD360Director.h"
#import "MDVRLibrary.h"
#import "MDVRHeader.h"
#import "MDObject3DHelper.h"

#pragma mark MDProjectionStrategyConfiguration
@implementation MDProjectionStrategyConfiguration

@end

@interface MDProjectionStrategyManager()
@property (nonatomic,strong) NSMutableArray* directors;
@property (nonatomic,strong) MDProjectionStrategyConfiguration* configuration;
@end

#pragma mark AbsProjectionMode
@interface AbsProjectionMode : NSObject<IMDModeStrategy,IMDProjectionMode>

@end

@implementation AbsProjectionMode

- (MDAbsObject3D*) getObject3D{
    return nil;
}

- (id<MD360DirectorFactory>) hijackDirectorFactory{
    return nil;
}

@end

#pragma mark SphereProjection
@interface SphereProjection : AbsProjectionMode
@property (nonatomic,strong) MDAbsObject3D* object3D;
@end

@implementation SphereProjection

- (void) on{
    self.object3D = [[MDSphere3D alloc]init];
    [MDObject3DHelper loadObj:self.object3D];
}

- (MDAbsObject3D*) getObject3D{
    return self.object3D;
}

@end

#pragma mark StereoSphereProjection
@interface StereoSphereProjection : AbsProjectionMode<MD360DirectorFactory>
@property (nonatomic,strong) MDStereoSphere3D* object3D;
@end

@implementation StereoSphereProjection


- (void) on{
    self.object3D = [[MDStereoSphere3D alloc]init];
    [MDObject3DHelper loadObj:self.object3D];
}


- (MDAbsObject3D*) getObject3D{
    return self.object3D;
}

- (id<MD360DirectorFactory>) hijackDirectorFactory{
    // hijack by self
    return self;
}

- (MD360Director*) createDirector:(int) index{
    MD360Director* director = [[MD360Director alloc]init];
    [director setup];
    return director;
}

@end


#pragma mark DomeProjection
@interface DomeProjection : AbsProjectionMode{
    float mDegree;
    BOOL mIsUpper;
}
@property (nonatomic,strong) MDAbsObject3D* object3D;
@property (nonatomic,weak) MDSizeContext* sizeContext;
@end

@implementation DomeProjection

- (instancetype)initWithSizeContext:(MDSizeContext*) sizeContext degree:(float)degree isUpper:(BOOL)isUpper{
    self = [super init];
    if (self) {
        self.sizeContext = sizeContext;
        self->mDegree = degree;
        self->mIsUpper = isUpper;
    }
    return self;
}

- (void) on{
    self.object3D = [[MDDome3D alloc]initWithSizeContext:self.sizeContext degree:self->mDegree isUpper:self->mIsUpper];
    [MDObject3DHelper loadObj:self.object3D];
}

- (MDAbsObject3D*) getObject3D{
    return self.object3D;
}

@end


#pragma mark PlaneProjection

@interface MDOrthogonalDirector : MD360Director

@property (nonatomic,weak) MDPlaneScaleCalculator* calculator;

@end

@implementation MDOrthogonalDirector

- (void) updateTouch:(float)distX distY:(int)distY{
    // nop
}

- (void) updateSensorMatrix:(GLKMatrix4)sensor{
    // nop
}

- (void) updateProjectionNearScale:(float)scale{
    // nop
}

- (void) updateProjection{
    [self.calculator setViewportRatio:[self getRatio]];
    [self.calculator calculate];
    
    float left = - [self.calculator getViewportWidth];
    float right = [self.calculator getViewportWidth];
    float bottom = - [self.calculator getViewportHeight];
    float top = [self.calculator getViewportHeight];
    float far = 500;
    
    // NSLog(@"updateProjection: %f %f %f %f:",left,right,bottom,top);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(left, right, bottom, top, [self getNear], far);
    [self setProjection:projectionMatrix];
    
}

@end

@interface MDOrthogonalDirectorFactory:NSObject<MD360DirectorFactory>

@property (nonatomic,weak) MDPlaneScaleCalculator* calculator;

@end

@implementation MDOrthogonalDirectorFactory

- (MD360Director*) createDirector:(int) index{
    MDOrthogonalDirector* director = [[MDOrthogonalDirector alloc]init];
    director.calculator = self.calculator;
    [director setup];
    return director;
}

- (instancetype)initWith:(MDPlaneScaleCalculator*) calculator{
    self = [super init];
    if (self) {
        self.calculator = calculator;
    }
    return self;
}

@end

@interface PlaneProjection : AbsProjectionMode
@property (nonatomic,strong) MDAbsObject3D* object3D;
@property (nonatomic,strong) MDPlaneScaleCalculator* calculator;
@end

@implementation PlaneProjection

- (void) on{
    self.object3D = [[MDPlane alloc]initWithCalculator:self.calculator];
    [MDObject3DHelper loadObj:self.object3D];
}

- (MDAbsObject3D*) getObject3D{
    return self.object3D;
}

- (id<MD360DirectorFactory>) hijackDirectorFactory{
    // hijack by self
    return [[MDOrthogonalDirectorFactory alloc] initWith:self.calculator];
}

+ (PlaneProjection*) create:(MDModeProjection) projection sizeContext:(MDSizeContext*) sizeContext{
    MDPlaneScaleCalculator* cal = [[MDPlaneScaleCalculator alloc] initWithScale:projection sizeContext:sizeContext];
    PlaneProjection* planeProjection = [PlaneProjection alloc];
    planeProjection.calculator = cal;
    return planeProjection;
}

@end


#pragma mark MDProjectionStrategyManager
@implementation MDProjectionStrategyManager

- (instancetype)initWithDefault:(int)mode config:(MDProjectionStrategyConfiguration*)config{
    self = [super initWithDefault:mode];
    if (self) {
        self.directors = [[NSMutableArray alloc] init];
        self.configuration = config;
    }
    return self;
}

- (id) createStrategy:(int)mode{
    switch (mode) {
        case MDModeProjectionDome180:
            return [[DomeProjection alloc] initWithSizeContext:self.configuration.sizeContext degree:180 isUpper:NO];
        case MDModeProjectionDome230:
            return [[DomeProjection alloc] initWithSizeContext:self.configuration.sizeContext degree:230 isUpper:NO];
        case MDModeProjectionDome180Upper:
            return [[DomeProjection alloc] initWithSizeContext:self.configuration.sizeContext degree:180 isUpper:YES];
        case MDModeProjectionDome230Upper:
            return [[DomeProjection alloc] initWithSizeContext:self.configuration.sizeContext degree:230 isUpper:YES];
        case MDModeProjectionStereoSphere:
            return [[StereoSphereProjection alloc] init];
        case MDModeProjectionPlaneFit:
        case MDModeProjectionPlaneCrop:
        case MDModeProjectionPlaneFull:
            return [PlaneProjection create:mode sizeContext:self.configuration.sizeContext];
        case MDModeProjectionSphere: default:
            return [[SphereProjection alloc] init];
    }
    return nil;
}

- (void) on{
    [super on];
    
    [self.directors removeAllObjects];
    id<MD360DirectorFactory> factory = self.configuration.directorFactory;
    id<MD360DirectorFactory> hijack = [self.mStrategy hijackDirectorFactory];
    factory = hijack != nil ? hijack : factory;

    for (int i = 0; i < MULTI_SCREEN_SIZE; i++) {
        if ([factory respondsToSelector:@selector(createDirector:)]) {
            MD360Director* director = [factory createDirector:i];
            [self.directors addObject:director];
        }
    }
}

- (NSArray*) createModes{
    return [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:MDModeProjectionSphere], [NSNumber numberWithInt:MDModeProjectionDome180],[NSNumber numberWithInt:MDModeProjectionDome230], [NSNumber numberWithInt:MDModeProjectionDome180Upper],[NSNumber numberWithInt:MDModeProjectionDome230Upper],[NSNumber numberWithInt:MDModeProjectionStereoSphere],[NSNumber numberWithInt:MDModeProjectionPlaneFit],[NSNumber numberWithInt:MDModeProjectionPlaneCrop],[NSNumber numberWithInt:MDModeProjectionPlaneFull],nil];
}

- (MDAbsObject3D*) getObject3D{
    return [self.mStrategy getObject3D];
}

- (NSArray*) getDirectors{
    return self.directors;
}

@end
