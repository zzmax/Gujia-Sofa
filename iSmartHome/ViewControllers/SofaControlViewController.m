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

@interface SofaControlView : UIView

@end

@interface SofaControlViewController()

@property (nonatomic, retain) IBOutlet UIView *sofaControlView;

@end


@implementation SofaControlViewController

- (void)viewDidLoad
{
    [[NSBundle mainBundle] loadNibNamed:@"SofaControlView" owner:self options:nil];
}
@end
