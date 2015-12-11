//
//  WifiConfigViewController.m
//  iSmartHome
//
//  Created by admin on 15/12/10.
//  Copyright © 2015年 zzmax. All rights reserved.
//

#import "WifiConfigViewController.h"
#import "ConstraintMacros.h"

@interface WifiConfigViewController ()
@property (weak, nonatomic) IBOutlet UITextField *routerTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *wifiIcon;
@property (weak, nonatomic) IBOutlet UIButton *codeIcon;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@end

@implementation WifiConfigViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    
    PREPCONSTRAINTS(_routerTF);
    ALIGN_VIEW_LEFT_CONSTANT(_routerTF.superview,_routerTF, 10);
    ALIGN_VIEW_RIGHT_CONSTANT(_routerTF.superview, _routerTF, -10);
    ALIGN_VIEW_TOP_CONSTANT(self.view, _routerTF, 100);
    CONSTRAIN_HEIGHT(_routerTF,50);
    
    PREPCONSTRAINTS(_codeTF);
    ALIGN_VIEW_LEFT_CONSTANT(_codeTF.superview,_codeTF, 10);
    ALIGN_VIEW_RIGHT_CONSTANT(_startBtn.superview, _codeTF, -10);
    ALIGN_VIEW_TOP_CONSTANT(self.view, _codeTF, 180);
    CONSTRAIN_HEIGHT(_codeTF,50);
    
    _startBtn.frame = BOTTOM_RECT;
    PREPCONSTRAINTS(_startBtn);
    ALIGN_VIEW_LEFT_CONSTANT(_startBtn.superview,_startBtn, 10);
    ALIGN_VIEW_RIGHT_CONSTANT(_startBtn.superview, _startBtn, -10);
    ALIGN_VIEW_TOP_CONSTANT(self.view, _startBtn, 300);
    
    PREPCONSTRAINTS(_wifiIcon);
    CONSTRAIN_SIZE(_wifiIcon, 35, 35);
    ALIGN_VIEW_TOP_CONSTANT(self.view, _wifiIcon, 110);
    ALIGN_VIEW_LEFT_CONSTANT(_wifiIcon.superview,_wifiIcon, 30);
    
    PREPCONSTRAINTS(_codeIcon);
    CONSTRAIN_SIZE(_codeIcon, 35, 35);
    ALIGN_VIEW_TOP_CONSTANT(self.view, _codeIcon, 190);
    ALIGN_VIEW_LEFT_CONSTANT(_codeIcon.superview,_codeIcon, 30);

    
//    self.navigationController
}
@end
