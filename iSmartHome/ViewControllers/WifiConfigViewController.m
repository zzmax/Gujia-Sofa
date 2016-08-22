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
#import "SmartFirstConfig.h"

@interface WifiConfigViewController ()<SmartFirstConfigDelegate>
{
    NSDictionary *_wifiInfo;
    SmartFirstConfig * _searchMacTool;
    NSMutableArray * _allMacArray;
}
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
    [_codeTF becomeFirstResponder];
    
    //set tool bar to dismiss the keyboard of _routerTF
    UIToolbar *textFieldToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    textFieldToolbar.barStyle = UIBarStyleBlackOpaque;
    [textFieldToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace,nil);
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn = SYSBARBUTTON(UIBarButtonSystemItemDone, @selector(doneButtonPressed:));
    [barItems addObject:doneBtn];
    [textFieldToolbar setItems:barItems animated:YES];
    _routerTF.inputAccessoryView = textFieldToolbar;
    
//
    PREPCONSTRAINTS(_routerTF);
    ALIGN_VIEW_TOP_CONSTANT(self.view, _routerTF, 64 + SCREEN_HEIGHT / 12);
    CONSTRAIN_WIDTH(_routerTF,SCREEN_WIDTH - 40);
//
    PREPCONSTRAINTS(_codeTF);
    CONSTRAIN_WIDTH(_codeTF,SCREEN_WIDTH - 40);
    ALIGN_VIEW1_TOP_TO_VIEW2_BOTTOM_CONSTANT(self.view, _codeTF, _routerTF, 25);
    
    _startBtn.frame = BOTTOM_RECT;
    PREPCONSTRAINTS(_startBtn);
    ALIGN_VIEW_LEFT_CONSTANT(_startBtn.superview,_startBtn, 10);
    ALIGN_VIEW_RIGHT_CONSTANT(_startBtn.superview, _startBtn, -10);
    ALIGN_VIEW_TOP_CONSTANT(self.view, _startBtn, 300);
    
//    self.navigationController.navigationItem.backBarButtonItem = nil;
    _globalSocket = [GlobalSocket sharedGlobalSocket];
    _wifiInfo = [_globalSocket getWifiInfo];
//    _allMacArray = [[NSMutableArray alloc]initWithCapacity:0];
//    [_allMacArray removeAllObjects];
//    _searchMacTool = [[SmartFirstConfig alloc]init];
//    _searchMacTool.fristConfigDelegate = self;
//    [_searchMacTool doSmartFirstConfig:nil sspwd:nil realCommandArr:nil andOperType:0];
    if (!_wifiInfo) {
        [self.utility setAlert:@"手机未连接Wi-Fi" message:@"请检查手机网络！"];
        [self presentViewController:self.utility.anAlert animated:YES completion:nil];

    }
    else self.routerTF.text = MBNonEmptyString(_wifiInfo[@"SSID"]);
}

- (IBAction)popView:(id) sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    
//    [_globalSocket setHost:_routerTF.text];
//    [_globalSocket initNetworkCommunication];
//    
//    
//    if ([_globalSocket.message isEqualToString:@"连接成功"]) {
//        [_startBtn setTitle:@"连接成功" forState:UIControlStateNormal];
//        After 1s, push to the view of weigh the body
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(pushToConfigratingView) userInfo:nil repeats:NO ];
//    }
}

- (void)pushToConfigratingView
{
    ConfiguratingViewController *configratingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ConfiguratingViewController"];

    configratingVC.wifiInfo = _wifiInfo;
    configratingVC.wifiPad = MBNonEmptyString(self.codeTF.text);
    configratingVC.staPwd = MBNonEmptyString(self.codeTF.text);
    configratingVC.staId = MBNonEmptyString(_wifiInfo[@"SSID"]);
    configratingVC.wifiName = MBNonEmptyString(self.routerTF.text);
    configratingVC.isConfigurateDeviceMode = YES;
    [self.navigationController pushViewController:configratingVC animated:YES];
}

//cancel the first responder of the keyborad until we active next textField
//dismiss the keyboard
- (BOOL)textFieldShouldReturn: (UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)doneButtonPressed: (id)sender
{
    [_routerTF resignFirstResponder];
}
@end
