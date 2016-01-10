//
//  ConfiguratingViewController.m
//  iSmartHome
//
//  Created by admin on 15/12/11.
//  Copyright © 2015年 zzmax. All rights reserved.
//
//  This view is to show the progress of the conifguration and the search of device

#import "ConfiguratingViewController.h"
#import "ConstraintMacros.h"

@interface ConfiguratingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
//The label to show which step we are : Configurate the sofa or search the device
@property (weak, nonatomic) IBOutlet UILabel *progressDescription;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@end

@implementation ConfiguratingViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.navigationItem.title = @"配置";
    
    self.progressDescription.text = @"正在努力配置您的智能沙发";//"搜索设备"？
    self.progressDescription.textColor = [UIColor blackColor];
    self.progressDescription.textAlignment = NSTextAlignmentCenter;
    PREPCONSTRAINTS(_progressDescription);
    CENTER_VIEW_H(_progressDescription.superview,_progressDescription);
    ALIGN_VIEW_TOP_CONSTANT(self.view, _progressDescription, 350);
    CONSTRAIN_SIZE(_progressDescription, 30, 300);
    
    self.progressBar.backgroundColor = NAVIGATION_COLOR;
    self.progressBar.progressViewStyle = UIProgressViewStyleBar;
    self.progressBar.trackTintColor = [UIColor whiteColor];
    PREPCONSTRAINTS(_progressBar);
    CENTER_VIEW_H(_progressBar.superview,_progressBar);
    ALIGN_VIEW_TOP_CONSTANT(self.view, _progressBar, 300);
    CONSTRAIN_SIZE(_progressBar, 10, 320);
    
    _cancelBtn.tintColor = [UIColor whiteColor];
    _cancelBtn.frame = BOTTOM_RECT;
    PREPCONSTRAINTS(_cancelBtn);
    ALIGN_VIEW_LEFT_CONSTANT(_cancelBtn.superview,_cancelBtn, 10);
    ALIGN_VIEW_RIGHT_CONSTANT(_cancelBtn.superview, _cancelBtn, -10);
    ALIGN_VIEW_BOTTOM_CONSTANT(self.view, _cancelBtn, -40);
    
   
}

- (IBAction)popView:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
