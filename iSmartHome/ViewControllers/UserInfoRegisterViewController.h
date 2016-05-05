//
//  UserInfoRegisterViewController.h
//  iSmartHome
//
//  Created by admin on 15/12/1.
//  Copyright © 2015年 zzmax. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UserInfoRegisterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (strong,nonatomic)NSString *navTitle;

@end
