//
//  SofaHeatViewController.m
//  iSmartHome
//
//  Created by admin on 15/12/17.
//  Copyright © 2015年 zzmax. All rights reserved.
//
//  This view is to control the temperature of the sofa.

#import "SofaHeatViewController.h"
#import "ConstraintMacros.h"

@interface SofaHeatViewController ()

@property (nonatomic, retain) IBOutlet UIView *sofaHeatView;
@property (weak, nonatomic) IBOutlet UILabel  *tempLbl;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopHeatBtn;
@property (weak, nonatomic) IBOutlet UIImageView  *backgroundImg;
@property (weak, nonatomic) IBOutlet UIImageView  *sofaHeatImg;
@property (weak, nonatomic) IBOutlet UIImageView  *bigBlueCircleImg;

@end

@implementation SofaHeatViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // show the naviagtion bar
    self.navigationController.navigationBarHidden = NO;
    // set title
    self.navigationItem.title = @"座椅加热";
    self.view.backgroundColor = BACKGROUND_COLOR;
    [[_stopHeatBtn layer] setBorderWidth: 0];
    [[_stopHeatBtn layer] setBorderColor: BACKGROUND_COLOR.CGColor];
    _stopHeatBtn.frame = BOTTOM_RECT;
    PREPCONSTRAINTS(_stopHeatBtn);
    ALIGN_VIEW_LEFT_CONSTANT(_stopHeatBtn.superview,_stopHeatBtn, 10);
    ALIGN_VIEW_RIGHT_CONSTANT(_stopHeatBtn.superview, _stopHeatBtn, -10);
    ALIGN_VIEW_BOTTOM_CONSTANT(self.sofaHeatView, _stopHeatBtn, -20);
    
    PREPCONSTRAINTS(_sofaHeatImg);
    ALIGN_VIEW_TOP_CONSTANT(self.sofaHeatView, self.sofaHeatImg, SCREEN_HEIGHT * 0.48f);
    CENTER_VIEW_H(self.sofaHeatView, self.sofaHeatImg);
    
    PREPCONSTRAINTS(_plusBtn);
    CONSTRAIN_SIZE(_plusBtn, 80, 80);
    ALIGN_VIEW_TOP_CONSTANT(self.sofaHeatView, self.plusBtn, SCREEN_HEIGHT * 0.18f);
    CENTER_VIEW_H(self.sofaHeatView, self.plusBtn);
    
    PREPCONSTRAINTS(_minusBtn);
    CONSTRAIN_SIZE(_minusBtn, 80, 80);
    ALIGN_VIEW_TOP_CONSTANT(self.sofaHeatView, self.minusBtn, SCREEN_HEIGHT * 0.68f);
    CENTER_VIEW_H(self.sofaHeatView, self.minusBtn);
    
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
