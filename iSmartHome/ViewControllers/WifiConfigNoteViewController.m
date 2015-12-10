//
//  WifiConfigNoteViewController.m
//  iSmartHome
//
//  Created by admin on 15/12/6.
//  Copyright © 2015年 zzmax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "WifiConfigNoteViewController.h"

@interface WifiConfigNoteViewController ()
@property (weak, nonatomic) IBOutlet UIButton *configBtn;
//Some useful methodes we can share
@property Utility *utility;

@end


@implementation WifiConfigNoteViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    [[_configBtn layer] setBorderWidth: 0];
    [[_configBtn layer] setBorderColor: BACKGROUND_COLOR.CGColor];
    _configBtn.frame = BOTTOM_RECT;
    PREPCONSTRAINTS(_configBtn);
    ALIGN_VIEW_LEFT_CONSTANT(_configBtn.superview,_configBtn, 10);
    ALIGN_VIEW_RIGHT_CONSTANT(_configBtn.superview, _configBtn, -10);
    ALIGN_VIEW_BOTTOM_CONSTANT(self.view, _configBtn, -40);
}

- (IBAction)popView:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

