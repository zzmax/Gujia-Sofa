//
//  RootViewController.m
//  iSmartHome
//
//  Created by admin on 15/11/29.
//  Copyright © 2015年 zzmax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginNoteViewController.h"
#import "QRCodeScanViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
//#import <NetworkExtension/NetworkExtension.h>


@interface LoginNoteViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *startScanBtn;
//the first paragraph to show the explanation
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@end


@implementation LoginNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PREPCONSTRAINTS(self.firstLabel);
    ALIGN_VIEW_TOP_CONSTANT(self.view, self.firstLabel, SCREEN_HEIGHT/4);
    
    _startBtn.frame = BOTTOM_RECT;
    PREPCONSTRAINTS(_startBtn);
    ALIGN_VIEW_LEFT_CONSTANT(_startBtn.superview,_startBtn, 10);
    ALIGN_VIEW_RIGHT_CONSTANT(_startBtn.superview, _startBtn, -10);
    ALIGN_VIEW_BOTTOM_CONSTANT(self.view, _startBtn, -40);
    [_startBtn setTitle:@"扫描二维码登陆数据账户" forState:UIControlStateNormal];
    _startBtn.titleLabel.textColor = [UIColor whiteColor];
    [_startBtn setExclusiveTouch:YES];
    //    NSArray * networkInterfaces = [NEHotspotHelper supportedNetworkInterfaces];
//    NSLog(@"Networks %@",networkInterfaces);
//    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Test", @selector(action:));
    
//    NSString *wifiName = nil;
//    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
//    for (NSString *ifnam in ifs) {
//        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
//        NSLog(@"info:%@",ifnam);
//        NSLog(@"info:%@",info);
//        
//        if (info[@"SSID"]) {
//            wifiName = info[@"SSID"];
//        }
//    }
}

@end

