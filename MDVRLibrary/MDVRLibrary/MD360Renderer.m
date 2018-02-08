//
//  MD360Renderer.m
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/7.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "MD360Renderer.h"
#import "MDAbsObject3D.h"
#import "MD360Program.h"
#import "GLUtil.h"
#import "MD360Director.h"
#import "MDAbsPlugin.h"
#import "MDAbsLinePipe.h"

typedef NS_ENUM(NSInteger, MDTextureProcessStep) {
    MDTextureProcessStepNop,
    MDTextureProcessStepProcessing,
    MDTextureProcessStepProcessed,
};

@interface ProcessorData: NSObject<IMDTextureProcessCallback>
@property (nonatomic) BOOL inited;
@property (nonatomic) MDTextureProcessStep step;
@property (nonatomic) GLint textureResult;
@property (nonatomic, strong) void (^block)() ;
@end

@implementation ProcessorData
- (instancetype)init {
    self = [super init];
    if (self) {
        self.step = MDTextureProcessStepNop;
    }
    return self;
}

- (void)dealloc {
    self.block = nil;
}

-(void) processDone:(GLint)textureResult block:(void (^)())block {
    self.textureResult = textureResult;
    self.step = MDTextureProcessStepProcessed;
    self.block = block;
}

-(void) done {
    self.step = MDTextureProcessStepNop;
    if (self.block) {
        self.block();
    }
}
@end

@interface MD360Renderer()
@property (nonatomic,weak) MDDisplayStrategyManager* mDisplayStrategyManager;
@property (nonatomic,weak) MDProjectionStrategyManager* mProjectionStrategyManager;
@property (nonatomic,weak) MDPluginManager* mPluginManager;
@property (nonatomic,strong) MDAbsLinePipe* mMainLinePipe;
@property (nonatomic,strong) id<IMDTextureProcessor> mTextureProcessor;
@property (nonatomic,strong) ProcessorData* mProcessorData;
@property (nonatomic,weak) EAGLContext* context;
@end

@implementation MD360Renderer

+ (MD360RendererBuilder*) builder{
    return [[MD360RendererBuilder alloc]init];
}

- (void)dealloc {}

- (void) setup {
    //
    self.mMainLinePipe = [[MDBarrelDistortionLinePipe alloc] initWith:self.mDisplayStrategyManager];
}

- (void) rendererOnCreated:(EAGLContext*)context{
    
    NSArray* plugins = [self.mPluginManager getPlugins];
    for (MDAbsPlugin* plugin in plugins) {
        [plugin setup:context];
    }
    
    [GLUtil glCheck:@"rendererOnCreated"];
}

- (void) rendererOnChanged:(EAGLContext*)context width:(int)width height:(int)height{
    NSArray* plugins = [self.mPluginManager getPlugins];
    for (MDAbsPlugin* plugin in plugins) {
        [plugin resizeWidth:width height:height];
    }
    
    [GLUtil glCheck:@"rendererOnChanged"];
}

- (void) rendererOnDrawFrame:(EAGLContext*)context width:(int)width height:(int)height{
    // draw
    float scale = [GLUtil getScrrenScale];
    int widthPx = width * scale;
    int heightPx = height * scale;
    
    int size = [self.mDisplayStrategyManager getVisibleSize];
    int itemWidthPx = widthPx * 1.0 / size;
    
    if (self.mProcessorData.step == MDTextureProcessStepNop) {
        
        // take over
        [self.mMainLinePipe fireSetup:context];
        [self.mMainLinePipe takeOverTotalWidth:widthPx totalHeight:heightPx size:size];
        
        NSArray* plugins = [self.mPluginManager getPlugins];
        for (MDAbsPlugin* plugin in plugins) {
            [plugin beforeRenderer:context totalW:widthPx totalH:heightPx];
        }
        
        for (int i = 0; i < size; i++ ) {
            glViewport(itemWidthPx * i, 0, itemWidthPx, heightPx);
            glEnable(GL_SCISSOR_TEST);
            glScissor(itemWidthPx * i, 0, itemWidthPx, heightPx);
            
            for (MDAbsPlugin* plugin in plugins) {
                [plugin renderer:context index:i width:itemWidthPx height:heightPx];
            }
            
            glDisable(GL_SCISSOR_TEST);
        }
        GLint textureInput = [self.mMainLinePipe getTextureId];
        self.mProcessorData.textureResult = textureInput;
        if (self.mTextureProcessor != nil) {
            
            // if mTextureProcessor is not inited?
            if (!self.mProcessorData.inited) {
                if ([self.mTextureProcessor respondsToSelector:@selector(processInit:size:)]) {
                    [self.mTextureProcessor processInit:textureInput size:CGSizeMake(widthPx, heightPx)];
                }
                self.mProcessorData.inited = YES;
            }
            
            // process begin
            if ([self.mTextureProcessor respondsToSelector:@selector(processBegin:)]) {
                [self.mTextureProcessor processBegin:self.mProcessorData];
            }
            self.mProcessorData.step = MDTextureProcessStepProcessing;
        } else {
            self.mProcessorData.step = MDTextureProcessStepProcessed;
        }
        
    } else if(self.mProcessorData.step == MDTextureProcessStepProcessed) {
        // clear
        glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        [GLUtil glCheck:@"glClear"];
        
        [self.mMainLinePipe commitTotalWidth:widthPx totalHeight:heightPx size:size texture:self.mProcessorData.textureResult];
        [self.mProcessorData done];
    }
    
}

- (void) rendererOnDestroy:(EAGLContext*) context{
    NSArray* plugins = [self.mPluginManager getPlugins];
    for (MDAbsPlugin* plugin in plugins) {
        [plugin destroy];
    }
}

@end

@interface MD360RendererBuilder()
@property (nonatomic,weak) MDPluginManager* pluginManager;
@property (nonatomic,weak) MDDisplayStrategyManager* displayStrategyManager;
@property (nonatomic,weak) MDProjectionStrategyManager* projectionStrategyManager;
@property (nonatomic,weak) id<IMDTextureProcessor> textureProcessor;
@end

@implementation MD360RendererBuilder

- (void) setDisplayStrategyManager:(MDDisplayStrategyManager*) displayStrategyManager{
    _displayStrategyManager = displayStrategyManager;
}

- (void) setProjectionStrategyManager:(MDProjectionStrategyManager*) projectionStrategyManager{
    _projectionStrategyManager = projectionStrategyManager;
}

- (void) setPluginManager:(MDPluginManager*) pluginManager{
    _pluginManager = pluginManager;
}

- (void) setTextureProcessor:(id<IMDTextureProcessor>)textureProcessor {
    _textureProcessor = textureProcessor;
}

- (MD360Renderer*) build{
    MD360Renderer* renderer = [[MD360Renderer alloc]init];
    renderer.mPluginManager = self.pluginManager;
    renderer.mProjectionStrategyManager = self.projectionStrategyManager;
    renderer.mDisplayStrategyManager = self.displayStrategyManager;
    renderer.mTextureProcessor = self.textureProcessor;
    renderer.mProcessorData = [[ProcessorData alloc] init];
    [renderer setup];
    return renderer;
}

@end
