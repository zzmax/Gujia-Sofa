//
//  RootViewController.m
//  iSmartHome
//
//  Created by admin on 15/11/29.
//  Copyright © 2015年 zzmax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RootViewController.h"
#import "QRCodeScanViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
//#import <NetworkExtension/NetworkExtension.h>


@interface RootViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startScanBtn;
//the first paragraph to show the explanation
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@end


@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PREPCONSTRAINTS(self.firstLabel);
    ALIGN_VIEW_TOP_CONSTANT(self.view, self.firstLabel, SCREEN_HEIGHT/4);
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

