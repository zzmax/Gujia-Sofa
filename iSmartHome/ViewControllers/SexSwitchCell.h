//
//  UITableViewCell+SexSwitchCell.h
//  iSmartHome
//
//  Created by admin on 15/12/3.
//  Copyright © 2015年 zzmax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SexSwitchCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *sex;
@property (nonatomic, strong) IBOutlet UISegmentedControl *sexControl;
@end
