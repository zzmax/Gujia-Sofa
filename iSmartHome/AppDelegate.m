//
//  AppDelegate.m
//  iSmartHome
//
//  Created by zwwang on 15/10/26.
//  Copyright © 2015年 zwwang. All rights reserved.
//

#import "AppDelegate.h"
#import "Nav1ViewController.h"
#import "Nav2ViewController.h"
#import "LoginNoteViewController.h"
#import "Utility.h"
#import "CoreDataHelper.h"
#import "WifiInfo.h"
#import "User.h"
#import "UsersCreationViewController.h"
#import "CurrentUser.h"
#import "NavigationViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize registerUser = _registerUser;

-(NSDate *)stringToDate:(NSString *)inputString
{
    NSDateFormatter *inputFormatterDate = [[NSDateFormatter alloc]init];
    [inputFormatterDate setDateFormat:@"yyyy-MM-dd"];
    NSDate *outputString = [inputFormatterDate dateFromString:inputString];
    return outputString;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //launch with notification
     [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self setRootViewController];
   
    
    // Override point for customization after application launch.
    
//    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
//    
//    self.registerUser=(User *)object;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
//    [self saveContext];
}

// This code block is invoked when application is in foreground (active-mode)
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
   // NSInteger period = [[notification.userInfo objectForKey:@"period"] integerValue]; //1
   // NSTimeInterval t= 10 * period;
    
//    NSDictionary *userInfo = [notification userInfo];
//    NSInteger t = [userInfo objectForKey:@"period"];
//    
//    notification.fireDate =[NSDate dateWithTimeIntervalSinceNow:t]; //2
//    [[UIApplication sharedApplication] scheduleLocalNotification:notification]; //3
    
    
    UIAlertController  *anAlert = [UIAlertController alertControllerWithTitle:notification.alertTitle
                                                   message:notification.alertBody
                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [anAlert addAction:defaultAction];
    [self.window.rootViewController presentViewController:anAlert animated:YES completion:nil]; // NSLog(@"didReceiveLocalNotification");
    
}

//set interface portrait
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

/**
 *  choose which view controller as the root view controller
 */
-(void)setRootViewController{

    if ([self findDataInDataBase:@"WifiInfo" andDefaultSortAttr:@"ssid"]== 0) {
        LoginNoteViewController *loginNoteVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginNoteViewController"];
        
        Nav1ViewController *nav = [[Nav1ViewController alloc]initWithRootViewController:loginNoteVC];
        nav.navigationBarHidden = NO;
        self.window.rootViewController = nav;
        
    }
    else if([self findDataInDataBase:@"User" andDefaultSortAttr:@"userName"]== 0 || [self findCurrentUserInDataBase] == 0){
        UsersCreationViewController *userCreationVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"UsersCreationViewController"];
        
        Nav1ViewController *nav = [[Nav1ViewController alloc]initWithRootViewController:userCreationVC];
        nav.navigationBarHidden = NO;
        self.window.rootViewController = nav;
    }
    else
    {
        NavigationViewController *navVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NavigationViewController"];
        
        Nav2ViewController *nav = [[Nav2ViewController alloc]initWithRootViewController:navVC];
        nav.navigationBarHidden = NO;
        self.window.rootViewController = nav;

    }
}

-(void)changeRootViewController:(UIViewController *)aVC
{
    Nav1ViewController *nav = [[Nav1ViewController alloc]initWithRootViewController:aVC];
    nav.navigationBarHidden = NO;

    if (!self.window.rootViewController) {
        self.window.rootViewController = nav;
        return;
    }
    
    UIView *snapShot = [self.window snapshotViewAfterScreenUpdates:YES];
    
    [nav.view addSubview:snapShot];
    
    self.window.rootViewController = nav;
    
    [UIView animateWithDuration:0.5 animations:^{
        snapShot.layer.opacity = 0;
        snapShot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
    } completion:^(BOOL finished) {
        [snapShot removeFromSuperview];
    }];
}

-(int)findDataInDataBase:(NSString *)anEntityName andDefaultSortAttr:(NSString *)anAttr {
    // Establish Core Data
    CoreDataHelper * dataHelper = [[CoreDataHelper alloc] init];
    dataHelper.entityName = anEntityName;
    dataHelper.defaultSortAttribute = anAttr;
    // Setup data
    [dataHelper setupCoreData];
    
    // Test listing all FailedBankInfos from the store
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSError *error;
    NSEntityDescription *entity = [NSEntityDescription entityForName:anEntityName
                                              inManagedObjectContext:dataHelper.context];
    [fetchRequest setEntity:entity];
     NSArray *fetchedObjects = [dataHelper.context executeFetchRequest:fetchRequest error:&error];
    return (int)fetchedObjects.count;
}

-(int)findCurrentUserInDataBase{
    // Establish Core Data
    CoreDataHelper * dataHelper = [[CoreDataHelper alloc] init];
    dataHelper.entityName = @"User";
    dataHelper.defaultSortAttribute = @"userName";
    // Setup data
    [dataHelper setupCoreData];
    
    [dataHelper fetchItemsMatching:@"1" forAttribute:@"isCurrentUser" sortingBy:nil];
    User *aUser = dataHelper.fetchedResultsController.fetchedObjects.firstObject;
    if (!aUser) {
        return 0;
    }
    else
    {
        CurrentUser *_currentUser = [CurrentUser staticCurrentUser];
        [_currentUser setCurrentUser:aUser];
    }
    return 1;
}

#pragma mark - Core Data stack
//
//@synthesize managedObjectContext = _managedObjectContext;
//@synthesize managedObjectModel = _managedObjectModel;
//@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
//
//- (NSURL *)applicationDocumentsDirectory
//{
//    // The directory the application uses to store the Core Data store file. This code uses a directory named "sjtu.iSmartHome" in the application's documents directory.
//    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//}
//
//- (NSManagedObjectModel *)managedObjectModel
//{
//    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
//    if (_managedObjectModel != nil) {
//        return _managedObjectModel;
//    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iSmartHome" withExtension:@"momd"];
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    return _managedObjectModel;
//}
//
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
//{
//    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
//    if (_persistentStoreCoordinator != nil)
//    {
//        return _persistentStoreCoordinator;
//    }
//    
//    // Create the coordinator and store
//    
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"iSmartHome.sqlite"];
//    NSError *error = nil;
//    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
//    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
//    {
//        // Report any error we got.
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
//        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
//        dict[NSUnderlyingErrorKey] = error;
//        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
//        // Replace this with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    
//    return _persistentStoreCoordinator;
//}


//- (NSManagedObjectContext *)managedObjectContext
//{
//    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
//    if (_managedObjectContext != nil) {
//        return _managedObjectContext;
//    }
//    
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (!coordinator) {
//        return nil;
//    }
//    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
//    return _managedObjectContext;
//}
//
//#pragma mark - Core Data Saving support
//
//- (void)saveContext
//{
//    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//    if (managedObjectContext != nil) {
//        NSError *error = nil;
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//            // Replace this implementation with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }
//}

@end
