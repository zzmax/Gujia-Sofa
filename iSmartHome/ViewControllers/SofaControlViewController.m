//
//  SofaControlViewController.m
//  iSmartHome
//
//  Created by admin on 15/12/15.
//  Copyright © 2015年 zzmax. All rights reserved.
//
//  This view is to control the height of the sofa.

#import "SofaControlViewController.h"
#import "ConstraintMacros.h"


@interface SofaControlViewController()

@property (nonatomic, retain) IBOutlet UIView *sofaControlView;
@property (weak, nonatomic) IBOutlet UIButton *liftBtn;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UIImageView  *backgroundImg;
@property (weak, nonatomic) IBOutlet UIImageView  *sofaImg;
@property (weak, nonatomic) IBOutlet UIImageView  *bigBlueCircleImg;
@end


@implementation SofaControlViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // show the naviagtion bar
    self.navigationController.navigationBarHidden = NO;
    // set title
    self.navigationItem.title = @"沙发控制";
    
    [[NSBundle mainBundle] loadNibNamed:@"SofaControlView" owner:self options:nil];
    self.sofaControlView.backgroundColor = BACKGROUND_COLOR;
    
    CGFloat widthScale = SCREEN_WIDTH/_backgroundImg.frame.size.width;
    CGFloat heightScale = (SCREEN_HEIGHT * 0.9) / _backgroundImg.frame.size.height;
    _backgroundImg.transform = CGAffineTransformMakeScale(widthScale, heightScale);
    PREPCONSTRAINTS(_backgroundImg);
    ALIGN_VIEW_TOP_CONSTANT(self.sofaControlView, self.backgroundImg, SCREEN_HEIGHT * 0.03f);//should adjust for iphone 6plus
    CENTER_VIEW_H(self.sofaControlView, self.backgroundImg);
    
    PREPCONSTRAINTS(_bigBlueCircleImg);
    CENTER_VIEW(self.sofaControlView, self.bigBlueCircleImg);
    widthScale = (SCREEN_WIDTH * 0.7 )/_bigBlueCircleImg.frame.size.width;
    heightScale = (SCREEN_WIDTH * 0.7 ) / _bigBlueCircleImg.frame.size.height;
    _bigBlueCircleImg.transform = CGAffineTransformMakeScale(widthScale, heightScale);
    
    PREPCONSTRAINTS(_sofaImg);
    ALIGN_VIEW_TOP_CONSTANT(self.sofaControlView, self.sofaImg, SCREEN_HEIGHT * 0.45f);
    CENTER_VIEW_H(self.sofaControlView, self.sofaImg);
    
    PREPCONSTRAINTS(_liftBtn);
    ALIGN_VIEW_TOP_CONSTANT(self.sofaControlView, self.liftBtn, SCREEN_HEIGHT * 0.19f);
    CENTER_VIEW_H(self.sofaControlView, self.liftBtn);
    
    PREPCONSTRAINTS(_downBtn);
    ALIGN_VIEW_TOP_CONSTANT(self.sofaControlView, self.downBtn, SCREEN_HEIGHT * 0.68f);
    CENTER_VIEW_H(self.sofaControlView, self.downBtn);
}
@end
