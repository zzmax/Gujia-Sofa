//
//  WifiConfigViewController.m
//  iSmartHome
//
//  Created by admin on 15/12/10.
//  Copyright © 2015年 zzmax. All rights reserved.
//

#import "WifiConfigViewController.h"
#import "ConfiguratingViewController.h"
#import "ConstraintMacros.h"
#import "Utility.h"
#import "GlobalSocket.h"

@interface WifiConfigViewController ()
@property (weak, nonatomic) IBOutlet UITextField *routerTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *wifiIcon;
@property (weak, nonatomic) IBOutlet UIButton *codeIcon;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@property Utility *utility;
@property GlobalSocket *globalSocket;
@end

@implementation WifiConfigViewController

-(void)viewWillAppear:(BOOL)animated
{
    [_startBtn setTitle:@"配置" forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    //Initiate the utility object
    _utility = [[Utility alloc] init];
    [self.utility activeDismissableKeyboard:self];
    
    //set the keyboard of routerTextField to UIKeyboardTypeDecimalPad
    [_routerTF setKeyboardType:UIKeyboardTypeDecimalPad];
    [_routerTF becomeFirstResponder];
    
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

//    self.navigationController.navigationItem.backBarButtonItem = nil;
    
   
}

/**
 *  Connect to the server
 *
 *  @param sender : Cnnection button
 */
- (IBAction)connectionBtn:(id)sender
{
    
    _globalSocket = [GlobalSocket sharedGlobalSocket];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"IP地址输入错误！"
                                                                   message:@"This is an alert."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    if (!_routerTF.text)
    {
        alert.message = @"IP地址不能为空。";
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (_routerTF.text.length < 7 || _routerTF.text.length > 15)
    {
        alert.message = @"请输入正确形式的IP地址。";
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    [_globalSocket setHost:_routerTF.text];
    [_globalSocket initNetworkCommunication];
    
    
    if ([_globalSocket.message isEqualToString:@"连接成功"]) {
        [_startBtn setTitle:@"连接成功" forState:UIControlStateNormal];
//        After 1s, push to the view of weigh the body
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(pushToConfigratingView) userInfo:nil repeats:NO ];
    }
}

- (void)pushToConfigratingView
{
    ConfiguratingViewController *configratingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ConfiguratingViewController"];
    [self.navigationController pushViewController:configratingVC animated:YES];
}

//cancel the first responder of the keyborad until we active next textField
//dismiss the keyboard
- (BOOL)textFieldShouldReturn: (UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
