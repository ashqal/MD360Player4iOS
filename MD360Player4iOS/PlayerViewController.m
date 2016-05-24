//
//  PlayerViewController.m
//  MD360Player4IOS
//
//  Created by ashqal on 16/4/11.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "PlayerViewController.h"


@interface PlayerViewController(){
}
@property (weak, nonatomic) IBOutlet UIButton *mInteractiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *mDisplayBtn;
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
    
    [self syncDisplayLabel];
    [self syncInteractiveLabel];
}

- (void) initPlayer{}

- (IBAction)onCloseBtnClicked:(id)sender {
    [self onClosed];
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)onDisplayModeBtnClicked:(id)sender {
    [self.vrLibrary switchDisplayMode];
    [self syncDisplayLabel];
    
}

- (IBAction)onInteractiveModeBtnClicked:(id)sender {
    [self.vrLibrary switchInteractiveMode];
    [self syncInteractiveLabel];
}

-(void)syncDisplayLabel{
    int mode = [self.vrLibrary getDisplayMdoe];
    NSString* label;
    if (mode == MDModeDisplayNormal) {
        label = @"NORMAL";
    } else {
        label = @"GLASS";
    }
    [self.mDisplayBtn setTitle:label forState:UIControlStateNormal];
}


-(void)syncInteractiveLabel{
    int mode = [self.vrLibrary getInteractiveMdoe];
    NSString* label;
    if (mode == MDModeInteractiveTouch) {
        label = @"TOUCH";
    } else {
        label = @"MOTION";
    }
    [self.mInteractiveBtn setTitle:label forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
