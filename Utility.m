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
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [_anAlert addAction:defaultAction];
}

- (UIImage*)loadPhotoForUser:(NSString *)aName
{
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

