//
//  Utility.h
//  iSmartHome
//
//  Created by admin on 15/11/23.
//  Copyright © 2015年 zwwang. All rights reserved.
//
#import <UIKit/UIKit.h>
@import Foundation;

@interface Utility : NSObject

@property (nonatomic, strong, nullable) UIAlertController *anAlert;

- (void)setAlert: (nullable NSString *)aTitle message: (nullable NSString *)aMsg;
- (void)activeDismissableKeyboard: (nonnull UIViewController *) aViewController;
@end
