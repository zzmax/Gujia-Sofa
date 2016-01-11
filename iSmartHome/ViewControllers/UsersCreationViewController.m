//
//  UsersCreationViewController.m
//  iSmartHome
//
//  Created by admin on 15/12/8.
//  Copyright © 2015年 zzmax. All rights reserved.
//
//  This view is for creating a user or changing a user currently used.

#import "UsersCreationViewController.h"
#import "ConstraintMacros.h"

@interface UsersCreationViewController()

@end

@implementation UsersCreationViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // show the naviagtion bar
//    self.navigationController.navigationBarHidden = NO;
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    if (self.navTitle == nil) {
        self.navTitle = @"创建用户";
    }
    self.navigationItem.title = self.navTitle;
    //set title color
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}
@end
