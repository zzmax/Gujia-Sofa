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

@interface UsersCreationViewController()
{
    CoreDataHelper *dataHelper;
    //This variable is to manage different size of screens
    CGFloat screenFactor;
}

@property (nonatomic,weak)IBOutlet UIButton *plusUser;
@end

@implementation UsersCreationViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // show the naviagtion bar
//    self.navigationController.navigationBarHidden = NO;
    
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
    UILabel *aLable = [[UILabel alloc]init];
    
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
        
        [self.view addSubview:aLable];
        PREPCONSTRAINTS(aLable);
        CENTER_VIEW_H_CONSTANT(self.view, aLable, 120 * screenFactor);
        CENTER_VIEW_V_CONSTANT(self.view, aLable, 78 * screenFactor);
        aLable.text =  fetchedUser.userName;
    }
    if (numberofEntities >= 2) {
        //beneath the centre
        aView =[[UIImageView alloc]initWithImage:image];
        aView.transform = CGAffineTransformMakeScale(widthScale, heightScale);
        [self.view addSubview:aView];
        PREPCONSTRAINTS(aView);
        CENTER_VIEW_H(self.view, aView);
        CENTER_VIEW_V_CONSTANT(self.view, aView, 140 * screenFactor);
        
        aLable = [[UILabel alloc]init];
        [fetchRequest setFetchLimit:2];
        fetchedObjects = [dataHelper.context executeFetchRequest:fetchRequest error:&error];
        User *fetchedUser = [fetchedObjects objectAtIndex:1];
        [self.view addSubview:aLable];
        PREPCONSTRAINTS(aLable);
        CENTER_VIEW_H(self.view, aLable);
        CENTER_VIEW_V_CONSTANT(self.view, aLable, 195 * screenFactor);
        aLable.text =  fetchedUser.userName;
    }
    if (numberofEntities >= 3) {
        //on the left
        aView =[[UIImageView alloc]initWithImage:image];
        aView.transform = CGAffineTransformMakeScale(widthScale, heightScale);
        [self.view addSubview:aView];
        PREPCONSTRAINTS(aView);
        CENTER_VIEW_H_CONSTANT(self.view, aView, -120 * screenFactor);
        CENTER_VIEW_V_CONSTANT(self.view, aView, 20);
        
        aLable = [[UILabel alloc]init];
        [fetchRequest setFetchLimit:3];
        fetchedObjects = [dataHelper.context executeFetchRequest:fetchRequest error:&error];
        User *fetchedUser = [fetchedObjects objectAtIndex:2];
        [self.view addSubview:aLable];
        PREPCONSTRAINTS(aLable);
        CENTER_VIEW_H_CONSTANT(self.view, aLable, -120 * screenFactor);
        CENTER_VIEW_V_CONSTANT(self.view, aLable, 78 * screenFactor);
        aLable.text =  fetchedUser.userName;
    }
    if (numberofEntities >= 4) {
        //on the top
        aView =[[UIImageView alloc]initWithImage:image];
        aView.transform = CGAffineTransformMakeScale(widthScale, heightScale);
        [self.view addSubview:aView];
        PREPCONSTRAINTS(aView);
        CENTER_VIEW_H(self.view, aView);
        CENTER_VIEW_V_CONSTANT(self.view, aView, -120 * screenFactor);
        
        aLable = [[UILabel alloc]init];
        [fetchRequest setFetchLimit:4];
        fetchedObjects = [dataHelper.context executeFetchRequest:fetchRequest error:&error];
        User *fetchedUser = [fetchedObjects objectAtIndex:3];
        [self.view addSubview:aLable];
        PREPCONSTRAINTS(aLable);
        CENTER_VIEW_H(self.view, aLable);
        CENTER_VIEW_V_CONSTANT(self.view, aLable, -65 * screenFactor);
        aLable.text =  fetchedUser.userName;
    }
}
@end
