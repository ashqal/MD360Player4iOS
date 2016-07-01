//
//  PlayerViewController.m
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/11.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "PlayerViewController.h"
#import "ActionSheetPicker.h"

@interface PickerHelper : NSObject{
    NSInteger prevIndex;
}

typedef void(^PickerDoneBlock)(int key);

@property (nonatomic,strong) NSDictionary* dictionary;
@property (nonatomic,strong) PickerDoneBlock doneBlock;
@end

@implementation PickerHelper

- (void) setData:(NSDictionary*) dictionary button:(UIButton*) button defaultKey:(int) key{
    self.dictionary = dictionary;
    prevIndex = [self keyToIndex:key];
    NSString* value = [self.dictionary objectForKey:[NSNumber numberWithInteger:key]];
    [button setTitle:value forState:UIControlStateNormal];
    [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)action:(id) sender{
    NSArray* values = [self.dictionary allValues];
    [self pick:values defaultIndex:prevIndex sender:sender];
}

- (int)indexToKey:(NSInteger) index{
    NSArray* keys = [self.dictionary allKeys];
    NSNumber* number = [keys objectAtIndex:index];
    return [number intValue];
}

- (NSInteger)keyToIndex:(NSInteger) key{
    NSArray* keys = [self.dictionary allKeys];
    return [keys indexOfObject:[NSNumber numberWithInteger:key]];
}

- (void) pick:(NSArray*)data defaultIndex:(long)index sender:(id)sender{
    [ActionSheetStringPicker showPickerWithTitle:@""
                                            rows:data
                                initialSelection:index
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           //NSLog(@"Picker: %@, Index: %ld, value: %@",picker, selectedIndex, selectedValue);
                                           prevIndex = selectedIndex;
                                           UIButton* button = sender;
                                           [button setTitle:selectedValue forState:UIControlStateNormal];
                                           
                                           if (self.doneBlock) {
                                               self.doneBlock([self indexToKey:selectedIndex]);
                                           }
                                       }
                                    cancelBlock:^(ActionSheetStringPicker *picker) {
                                    }
                                         origin:sender];
}

@end

@interface PlayerViewController(){
}
@property (weak, nonatomic) IBOutlet UIButton *mInteractiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *mDisplayBtn;
@property (weak, nonatomic) IBOutlet UIButton *mProjectionBtn;
@property (nonatomic, strong) PickerHelper* mInteractivePicker;
@property (nonatomic, strong) PickerHelper* mDisplayPicker;
@property (nonatomic, strong) PickerHelper* mProjectionPicker;

@end
@implementation PlayerViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
}

- (void)dealloc{
}

- (void) onClosed{
}

- (void) initParams:(NSURL*)url{
    self.mURL = url;
    [self initPlayer];
    
    
    NSDictionary* interactiveDic = [[NSDictionary alloc]initWithObjectsAndKeys:
                                    @"TOUCH",[NSNumber numberWithInt:MDModeInteractiveTouch],
                                    @"MOTION",[NSNumber numberWithInt:MDModeInteractiveMotion],
                                    @"M&T",[NSNumber numberWithInt:MDModeInteractiveMotionWithTouch],
                                    nil];
    
    NSDictionary* displayDic = [[NSDictionary alloc]initWithObjectsAndKeys:
                                    @"NORMAL",[NSNumber numberWithInt:MDModeDisplayNormal],
                                    @"GLASS",[NSNumber numberWithInt:MDModeDisplayGlass],
                                    nil];

    NSDictionary* projectionDic = [[NSDictionary alloc]initWithObjectsAndKeys:
                                   @"SPHERE",[NSNumber numberWithInt:MDModeProjectionSphere],
                                   @"DOME180",[NSNumber numberWithInt:MDModeProjectionDome180],
                                   @"DOME230",[NSNumber numberWithInt:MDModeProjectionDome230],
                                   @"DOME180_UPPER",[NSNumber numberWithInt:MDModeProjectionDome180Upper],
                                   @"DOME230_UPPER",[NSNumber numberWithInt:MDModeProjectionDome230Upper],
                                   @"STEREO",[NSNumber numberWithInt:MDModeProjectionStereoSphere],
                                   @"PLANE_FIT",[NSNumber numberWithInt:MDModeProjectionPlaneFit],
                                   @"PLANE_CROP",[NSNumber numberWithInt:MDModeProjectionPlaneCrop],
                                   @"PLANE_FULL",[NSNumber numberWithInt:MDModeProjectionPlaneFull],
                                nil];
    
    __block MDVRLibrary *blockVRLib = self.vrLibrary;
    
    self.mInteractivePicker = [[PickerHelper alloc] init];
    [self.mInteractivePicker setData:interactiveDic button:self.mInteractiveBtn defaultKey:[self.vrLibrary getInteractiveMdoe]];
    [self.mInteractivePicker setDoneBlock:^(int key){
        [blockVRLib switchInteractiveMode:key];
    }];
    
    self.mDisplayPicker = [[PickerHelper alloc] init];
    [self.mDisplayPicker setData:displayDic button:self.mDisplayBtn defaultKey:[self.vrLibrary getDisplayMdoe]];
    [self.mDisplayPicker setDoneBlock:^(int key){
        [blockVRLib switchDisplayMode:key];
    }];
    
    self.mProjectionPicker = [[PickerHelper alloc] init];
    [self.mProjectionPicker setData:projectionDic button:self.mProjectionBtn defaultKey:[self.vrLibrary getProjectionMode]];
    [self.mProjectionPicker setDoneBlock:^(int key){
        [blockVRLib switchProjectionMode:key];
    }];
}

- (void) initPlayer{}

- (IBAction)onCloseBtnClicked:(id)sender {
    [self onClosed];
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
