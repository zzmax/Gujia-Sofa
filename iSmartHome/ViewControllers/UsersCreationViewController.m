//
//  UsersCreationViewController.m
//  iSmartHome
//
//  Created by admin on 15/12/8.
//  Copyright © 2015年 zzmax. All rights reserved.
//
//  This view is for creating a user or changing a user currently used.

#import "UsersCreationViewController.h"
#import "ConstraintMacros.h"
#import "CoreDataHelper.h"
#import "CurrentUser.h"
#import "NavigationViewController.h"
#import "CurrentUser.h"

@interface UsersCreationViewController()
{
    CoreDataHelper *dataHelper;
    CurrentUser *currentUser;
    //This variable is to manage different size of screens
    CGFloat screenFactor;
}

@property (nonatomic,weak)IBOutlet UIButton *plusUser;
@end

@implementation UsersCreationViewController

//-(void) viewWillAppear:(BOOL)animated
//{
//    if (self.navTitle == nil) {
//        self.navTitle = @"创建用户";
//    }
//    self.navigationItem.title = self.navTitle;
////    self.navigationItem.titleView
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // show the naviagtion bar
    self.navigationController.navigationBarHidden = NO;
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    if (self.navTitle == nil) {
        self.navTitle = @"创建用户";
    }
    self.navigationItem.title = self.navTitle;
    //set title color
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.view bringSubviewToFront:self.plusUser];
    
    //set images
    if (IS_IPHONE_PLUS) {
        screenFactor = 1.1;
    }
    else if (!IS_IPHONE_6)
    {
        screenFactor = 0.83;
    }
    else
        screenFactor = 1;
    UIImage *image = [UIImage imageNamed: @"background_small_white_circle"];
    UIImageView *aView = [[UIImageView alloc]initWithImage:image];
    
    CGFloat widthScale = (90 * screenFactor)/image.size.width;
    CGFloat heightScale = (90 * screenFactor)/image.size.height;
    aView.transform = CGAffineTransformMakeScale(widthScale, heightScale);
    UILabel *aLabel = [[UILabel alloc]init];
    
    // Establish Core Data
    dataHelper = [[CoreDataHelper alloc] init];
    dataHelper.entityName = @"User";
    dataHelper.defaultSortAttribute = @"userName";
    [dataHelper setupCoreData];
    NSInteger numberofEntities = [dataHelper numberOfEntities];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSError *error;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                              inManagedObjectContext:dataHelper.context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [[NSArray alloc]init];
    
//    aTap.delegate = self;
    
    if (numberofEntities >= 1)
    {
        //on the right of centre
        [self.view addSubview:aView];
        PREPCONSTRAINTS(aView);
        CENTER_VIEW_H_CONSTANT(self.view, aView, 120 * screenFactor);
        CENTER_VIEW_V_CONSTANT(self.view, aView, 20);
        
        [fetchRequest setFetchLimit:1];
        fetchedObjects = [dataHelper.context executeFetchRequest:fetchRequest error:&error];
        User *fetchedUser = [fetchedObjects firstObject];
        
        [self.view addSubview:aLabel];
        PREPCONSTRAINTS(aLabel);
        CENTER_VIEW_H_CONSTANT(self.view, aLabel, 120 * screenFactor);
        CENTER_VIEW_V_CONSTANT(self.view, aLabel, 78 * screenFactor);
        aLabel.text =  fetchedUser.userName;
        
        //We will tag the view to distinguish the tap
        aView.tag = 201;
        aLabel.tag = 301;
        
        //add tap gesture recognizer to each image view
        UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(handleTap:)];
        [aView addGestureRecognizer:aTap];
        aView.userInteractionEnabled = YES;
    }
    if (numberofEntities >= 2) {
        //beneath the centre
        aView =[[UIImageView alloc]initWithImage:image];
        aView.transform = CGAffineTransformMakeScale(widthScale, heightScale);
        [self.view addSubview:aView];
        PREPCONSTRAINTS(aView);
        CENTER_VIEW_H(self.view, aView);
        CENTER_VIEW_V_CONSTANT(self.view, aView, 140 * screenFactor);
        
        aLabel = [[UILabel alloc]init];
        [fetchRequest setFetchLimit:2];
        fetchedObjects = [dataHelper.context executeFetchRequest:fetchRequest error:&error];
        User *fetchedUser = [fetchedObjects objectAtIndex:1];
        [self.view addSubview:aLabel];
        PREPCONSTRAINTS(aLabel);
        CENTER_VIEW_H(self.view, aLabel);
        CENTER_VIEW_V_CONSTANT(self.view, aLabel, 195 * screenFactor);
        aLabel.text =  fetchedUser.userName;
        
        aView.tag = 202;
        aLabel.tag = 302;
        
        UITapGestureRecognizer *secondTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        [aView addGestureRecognizer:secondTap];
        aView.userInteractionEnabled = YES;
    }
    if (numberofEntities >= 3) {
        //on the left
        aView =[[UIImageView alloc]initWithImage:image];
        aView.transform = CGAffineTransformMakeScale(widthScale, heightScale);
        [self.view addSubview:aView];
        PREPCONSTRAINTS(aView);
        CENTER_VIEW_H_CONSTANT(self.view, aView, -120 * screenFactor);
        CENTER_VIEW_V_CONSTANT(self.view, aView, 20);
        
        aLabel = [[UILabel alloc]init];
        [fetchRequest setFetchLimit:3];
        fetchedObjects = [dataHelper.context executeFetchRequest:fetchRequest error:&error];
        User *fetchedUser = [fetchedObjects objectAtIndex:2];
        [self.view addSubview:aLabel];
        PREPCONSTRAINTS(aLabel);
        CENTER_VIEW_H_CONSTANT(self.view, aLabel, -120 * screenFactor);
        CENTER_VIEW_V_CONSTANT(self.view, aLabel, 78 * screenFactor);
        aLabel.text =  fetchedUser.userName;
        
        aView.tag = 203;
        aLabel.tag = 303;
        
        UITapGestureRecognizer *thirdTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(handleTap:)];
        [aView addGestureRecognizer:thirdTap];
        aView.userInteractionEnabled = YES;
    }
    if (numberofEntities >= 4) {
        //on the top
        aView =[[UIImageView alloc]initWithImage:image];
        aView.transform = CGAffineTransformMakeScale(widthScale, heightScale);
        [self.view addSubview:aView];
        PREPCONSTRAINTS(aView);
        CENTER_VIEW_H(self.view, aView);
        CENTER_VIEW_V_CONSTANT(self.view, aView, -120 * screenFactor);
        
        aLabel = [[UILabel alloc]init];
        [fetchRequest setFetchLimit:4];
        fetchedObjects = [dataHelper.context executeFetchRequest:fetchRequest error:&error];
        User *fetchedUser = [fetchedObjects objectAtIndex:3];
        [self.view addSubview:aLabel];
        PREPCONSTRAINTS(aLabel);
        CENTER_VIEW_H(self.view, aLabel);
        CENTER_VIEW_V_CONSTANT(self.view, aLabel, -65 * screenFactor);
        aLabel.text =  fetchedUser.userName;
        
        aView.tag = 204;
        aLabel.tag = 304;
        
        UITapGestureRecognizer *fourthTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        [aView addGestureRecognizer:fourthTap];
        aView.userInteractionEnabled = YES;
    }
}

//The event handling method
- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    UIView *view = recognizer.view;
    UILabel *aLabel = [[UILabel alloc]init];
    
    switch (view.tag) {
        case 201:
            aLabel = (UILabel *)[self.view viewWithTag:301];
            break;
        case 202:
            aLabel = (UILabel *)[self.view viewWithTag:302];
            break;
        case 203:
            aLabel = (UILabel *)[self.view viewWithTag:303];
            break;
        case 204:
            aLabel = (UILabel *)[self.view viewWithTag:304];
            break;
        default:
            break;
    }
    //change current user to a normal user
    [dataHelper fetchItemsMatching:@"1" forAttribute:@"isCurrentUser" sortingBy:nil];
    if (dataHelper.fetchedResultsController.fetchedObjects.count > 1)
    {
        [NSException raise:@"系统错误" format:@"Too many current user : %lu", dataHelper.fetchedResultsController.fetchedObjects.count];
    }
    User *oldUser = dataHelper.fetchedResultsController.fetchedObjects.firstObject;
    oldUser.isCurrentUser = [NSNumber numberWithInteger:0];
    
    currentUser = [CurrentUser staticCurrentUser];
    
    // we fetch the tapped user and set to current user
    [dataHelper fetchItemsMatching:aLabel.text forAttribute:@"userName" sortingBy:nil];
    User *userWantChangeTo = dataHelper.fetchedResultsController.fetchedObjects.firstObject;
    [currentUser setCurrentUser:userWantChangeTo];
    userWantChangeTo.isCurrentUser = [NSNumber numberWithInteger:1];
    [dataHelper save];
    
    NavigationViewController *navigationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"];
    [self.navigationController pushViewController:navigationVC animated:YES];
}
@end
