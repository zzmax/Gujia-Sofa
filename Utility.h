//
//  Utility.h
//  iSmartHome
//
//  Created by admin on 15/11/23.
//  Copyright © 2015年 zwwang. All rights reserved.
//
#import <UIKit/UIKit.h>
@import Foundation;

@protocol UtilityDelegate <NSObject>
@optional
-(void)deleteUserAction:(NSInteger)deleteOrNot;
@end

@interface Utility : NSObject

@property   (nonatomic , weak, nullable) id<UtilityDelegate> utilityDelegateDelegate;

@property (nonatomic, strong, nullable) UIAlertController *anAlert;

- (void)setAlert: (nullable NSString *)aTitle message: (nullable NSString *)aMsg;
- (void)activeDismissableKeyboard: (nullable UIViewController *) aViewController;
- (nullable UIImage*)loadPhotoForUser:(nonnull NSString *)aName;

@end
