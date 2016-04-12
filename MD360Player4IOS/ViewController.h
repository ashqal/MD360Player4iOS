//
//  ViewController.h
//  MD360Player4IOS
//
//  Created by ashqal on 16/3/27.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *mUrlTextView;

- (IBAction)onNetworkButton:(id)sender;

- (IBAction)onLocalButton:(id)sender;


@end

