//
//  SetViewController.h
//  iSmartHome
//
//  Created by admin on 16/7/12.
//  Copyright © 2016年 zzmax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end
