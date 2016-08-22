//
//  ConfiguratingViewController.h
//  iSmartHome
//
//  Created by admin on 15/12/11.
//  Copyright © 2015年 zzmax. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ConfiguratingViewController : UIViewController
@property(nonatomic,strong)NSDictionary *wifiInfo;
@property(nonatomic,strong)NSString *wifiName;
@property(nonatomic,strong)NSString *wifiPad;

@property(nonatomic,strong)NSString *staId;
@property(nonatomic,strong)NSString *staPwd;
//YES for configurating router, NO for search device
@property(nonatomic)BOOL isConfigurateDeviceMode;

@end
