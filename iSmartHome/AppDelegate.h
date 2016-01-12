//
//  AppDelegate.h
//  iSmartHome
//
//  Created by zwwang on 15/10/26.
//  Copyright © 2015年 zwwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "User.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property (strong, nonatomic) UINavigationController *navController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//
@property (nonatomic,strong ) User *registerUser;
//
-(NSDate *)stringToDate:(NSString *)inputString;
//
//- (void)saveContext;
//- (NSURL *)applicationDocumentsDirectory;


@end

