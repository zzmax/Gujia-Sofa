//
//  Utility.m
//  iSmartHome
//
//  Created by admin on 15/11/23.
//  Copyright © 2015年 zwwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utility.h"

@implementation Utility


-(void)activeDismissableKeyboard : (UIViewController *)aViewController
{
    for (UIView *view in aViewController.view.subviews)
    {
        if ([view isKindOfClass:[UITextField class]])
        {
            UITextField *aTextField = (UITextField *)view;
            aTextField.delegate = aViewController;
            
            aTextField.returnKeyType = UIReturnKeyDone;
            aTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            
            aTextField.borderStyle = UITextBorderStyleRoundedRect;
            aTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            aTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            
            //            aTextField.font = [UIFont fontWithName:@"Futura" size:12.0f];
            //            aTextField.placeholder = @"Placeholder";
        }
    }
}
@end

