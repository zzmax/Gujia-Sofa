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

- (void)setAlert: (NSString *)aTitle message: (NSString *)aMsg
{
    
    _anAlert = [UIAlertController alertControllerWithTitle:aTitle
                                                            message:aMsg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                            if ([aTitle isEqualToString:@"删除用户"])
                                            {
                                                if ([self.utilityDelegateDelegate respondsToSelector:@selector(deleteUserAction:)]) {
                                                    [self.utilityDelegateDelegate deleteUserAction:1];
                                                }
                                            }
                                            if ([aTitle isEqualToString:@"Wifi信息缺失"]
                                                || [aTitle isEqualToString:@"重新配置WiFi"])
                                            {
                                                if ([self.utilityDelegateDelegate respondsToSelector:@selector(reconfigurateWifi:)]) {
                                                    [self.utilityDelegateDelegate reconfigurateWifi:1];
                                                }
                                            }
                                        }];
        
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 if ([aTitle isEqualToString:@"删除用户"])
                                                                 {
                                                                     if ([self.utilityDelegateDelegate respondsToSelector:@selector(deleteUserAction:)])
                                                                     {
                                                                         [self.utilityDelegateDelegate deleteUserAction:0];
                                                                     }
                                                                 }
                                                                 if ([aTitle isEqualToString:@"Wifi信息缺失"]
                                                                     || [aTitle isEqualToString:@"重新配置WiFi"])
                                                                 {
                                                                     if ([self.utilityDelegateDelegate respondsToSelector:@selector(reconfigurateWifi:)]) {
                                                                         [self.utilityDelegateDelegate reconfigurateWifi:0];
                                                                     }
                                                                 }
                                                             }];

    
    [_anAlert addAction:confirmAction];
    [_anAlert addAction:cancelAction];

}


- (UIImage*)loadPhotoForUser:(NSString *)aName
{
    if (!aName) {
        return [UIImage imageNamed: @"background_small_white_circle"];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSMutableString *appendString = [NSMutableString string];
    [appendString appendString:aName];
    [appendString appendString:@".png"];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithString: appendString] ];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    if (!image) {
        return [UIImage imageNamed: @"background_small_white_circle"];
    }
    return image;
}
@end

