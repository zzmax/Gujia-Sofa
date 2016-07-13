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
#import "Utility.h"
#import "UserInfoRegisterViewController.h"

@interface UsersCreationViewController()
{
    CoreDataHelper *dataHelper;
    CurrentUser *currentUser;
    //This variable is to manage different size of screens
    CGFloat screenFactor;
    Utility *utility;
    NSArray *fetchedUsers;
}

@property (nonatomic,weak)IBOutlet UIButton *plusUser;
@end

@implementation UsersCreationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // show the naviagtion bar
    self.navigationController.navigationBarHidden = NO;
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    if (self.navTitle == nil) {
        self.navTitle = @"创建用户";
    }
    [self.navigationItem setTitle: self.navTitle];
    self.navigationItem.titleView.hidden = NO;
    
    //set title color
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    [self.view bringSubviewToFront:self.plusUser];
    
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
    
    utility = [[Utility alloc]init];
    
    
//    UIImage *image = [UIImage imageNamed: @"background_small_white_circle"];
//    UIImageView *aView = [[UIImageView alloc]initWithImage:image];
//    
//    CGFloat widthScale = (90 * screenFactor)/image.size.width;
//    CGFloat heightScale = (90 * screenFactor)/image.size.height;
//    aView.transform = CGAffineTransformMakeScale(widthScale, heightScale);
//    UILabel *aLabel = [[UILabel alloc]init];
    
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
    fetchedUsers = [dataHelper.context executeFetchRequest:fetchRequest error:&error];
    
//    aTap.delegate = self;
    if (numberofEntities == 0) {
        //add icon for adding user
        //on the top
        [self setAddUserButtonforPlace:-120 and:-120];
    }
    if (numberofEntities >= 1)
    {
        //on the left top
        [self setUserImageViewforPlace:-120 and:-120 andForUser:1];
        [self setUserNameLabelViewforPlace:-120 and:-65 andForUser:1];
        
        if (numberofEntities == 1) {
            //add icon for adding user
            //on the top
            [self setAddUserButtonforPlace:0 and:-120];
        }
   }
    if (numberofEntities >= 2) {
        //on the top
        [self setUserImageViewforPlace:0 and:-120 andForUser:2];
        [self setUserNameLabelViewforPlace:0 and:-65 andForUser:2];
        
        if (numberofEntities == 2) {
            //add icon for adding user
            //on the top right
            [self setAddUserButtonforPlace:120 and:-120];
        }
    }
    if (numberofEntities >= 3) {
        //on the top right
        [self setUserImageViewforPlace:120 and:-120 andForUser:3];
        [self setUserNameLabelViewforPlace:120 and:-65 andForUser:3];
        
        if (numberofEntities == 3) {
            //add icon for adding user
            //on the left
            [self setAddUserButtonforPlace:-120 and:20];
        }
    }
    if (numberofEntities >= 4) {
        //on the left
        [self setUserImageViewforPlace:-120 and:20 andForUser:4];
        [self setUserNameLabelViewforPlace:-120 and:78 andForUser:4];
        
        if (numberofEntities == 4) {
            //add icon for adding user
            //on the center
            [self setAddUserButtonforPlace:0 and:20];
        }
    }
    if (numberofEntities >= 5) {
        //on the center
        [self setUserImageViewforPlace:0 and:20 andForUser:5];
        [self setUserNameLabelViewforPlace:0 and:78 andForUser:5];
        
        if (numberofEntities == 5) {
            //add icon for adding user
            //on the right
            [self setAddUserButtonforPlace:120 and:20];
        }
    }
    if (numberofEntities >= 6) {
        //on the right
        [self setUserImageViewforPlace:120 and:20 andForUser:6];
        [self setUserNameLabelViewforPlace:120 and:78 andForUser:6];
        
        if (numberofEntities == 6) {
            //add icon for adding user
            //on the bottom left
            [self setAddUserButtonforPlace:-120 and:160];
        }
    }
    if (numberofEntities >= 7) {
        //on the bottom left
        [self setUserImageViewforPlace:-120 and:160 andForUser:7];
        [self setUserNameLabelViewforPlace:-120 and:215 andForUser:7];
        
        if (numberofEntities == 7) {
            //add icon for adding user
            //on the bottom
            [self setAddUserButtonforPlace:0 and:160];
        }
    }
    if (numberofEntities >= 8) {
        //beneath the centre
        [self setUserImageViewforPlace:0 and:160 andForUser:8];
        [self setUserNameLabelViewforPlace:0 and:215 andForUser:8];
        
        if (numberofEntities == 8) {
            //add icon for adding user
            //on the bottom right
            [self setAddUserButtonforPlace:120 and:160];
        }
    }
    if (numberofEntities >= 9) {
        //on the bottom right
        [self setUserImageViewforPlace:120 and:160 andForUser:9];
        [self setUserNameLabelViewforPlace:120 and:215 andForUser:9];
    }
}

-(UIImageView *)setUserImageViewforPlace:(int)HCoord and:(int)VCoord andForUser:(int) userOrder{
    UIImageView *aView = [[UIImageView alloc]init];

    
    User *fetchedUser;
    UIImage *anImage;
    switch (userOrder) {
        case 0:
            //We will tag the view to distinguish the tap
            aView.tag = 200;
            break;
        case 1:
            fetchedUser = [fetchedUsers firstObject];
            //We will tag the view to distinguish the tap
            aView.tag = 201;
            break;
        case 2:
            fetchedUser = [fetchedUsers objectAtIndex:1];
            aView.tag = 202;
            break;
        case 3:
            fetchedUser = [fetchedUsers objectAtIndex:2];
            aView.tag = 203;
            break;
        case 4:
            fetchedUser = [fetchedUsers objectAtIndex:3];
            aView.tag = 204;
            break;
        case 5:
            fetchedUser = [fetchedUsers objectAtIndex:4];
            aView.tag = 205;
            break;
        case 6:
            fetchedUser = [fetchedUsers objectAtIndex:5];
            aView.tag = 206;
            break;
        case 7:
            fetchedUser = [fetchedUsers objectAtIndex:6];
            aView.tag = 207;
            break;
        case 8:
            fetchedUser = [fetchedUsers objectAtIndex:7];
            aView.tag = 208;
            break;
        case 9:
            fetchedUser = [fetchedUsers objectAtIndex:8];
            aView.tag = 209;
            break;
        default:
            break;
    }
    
//    if(aView.tag != 200)
//    {
        anImage = [utility loadPhotoForUser:fetchedUser.userName];
        aView.image = anImage;
        CGFloat widthScale = (90 * screenFactor)/anImage.size.width;
        CGFloat heightScale = (90 * screenFactor)/anImage.size.height;
        aView.transform = CGAffineTransformMakeScale(widthScale, heightScale);
        //set image to a circle
        aView.layer.cornerRadius = aView.image.size.width/2;
        aView.layer.masksToBounds = YES;
        aView.layer.borderWidth = 3.0f;
        aView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.view addSubview:aView];
        PREPCONSTRAINTS(aView);
        
        CENTER_VIEW_H_CONSTANT(self.view, aView, HCoord * screenFactor);
        CENTER_VIEW_V_CONSTANT(self.view, aView, VCoord * screenFactor);
        
        //add tap gesture recognizer to each image view
        UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(handleTap:)];
        [aView addGestureRecognizer:aTap];
        aView.userInteractionEnabled = YES;
        return aView;
  
    
    
}

-(UILabel *)setUserNameLabelViewforPlace:(int)HCoord and:(int)VCoord andForUser:(int)userOrder{
    UILabel *aLabel = [[UILabel alloc]init];
    UIImageView *aView = [[UIImageView alloc]init];
    User *fetchedUser;
    switch (userOrder) {
        case 1:
            fetchedUser = [fetchedUsers firstObject];
            aLabel.tag = 301;
            aView = (UIImageView *)[self.view viewWithTag:201];
            break;
        case 2:
            fetchedUser = [fetchedUsers objectAtIndex:1];
            aLabel.tag = 302;
            aView = (UIImageView *)[self.view viewWithTag:202];
            break;
        case 3:
            fetchedUser = [fetchedUsers objectAtIndex:2];
            aLabel.tag = 303;
            aView = (UIImageView *)[self.view viewWithTag:203];
            break;
        case 4:
            fetchedUser = [fetchedUsers objectAtIndex:3];
            aLabel.tag = 304;
            aView = (UIImageView *)[self.view viewWithTag:204];
            break;
        case 5:
            fetchedUser = [fetchedUsers objectAtIndex:4];
            aLabel.tag = 305;
            aView = (UIImageView *)[self.view viewWithTag:205];
            break;
        case 6:
            fetchedUser = [fetchedUsers objectAtIndex:5];
            aLabel.tag = 306;
            aView = (UIImageView *)[self.view viewWithTag:206];
            break;
        case 7:
            fetchedUser = [fetchedUsers objectAtIndex:6];
            aLabel.tag = 307;
            aView = (UIImageView *)[self.view viewWithTag:207];
            break;
        case 8:
            fetchedUser = [fetchedUsers objectAtIndex:7];
            aLabel.tag = 308;
            aView = (UIImageView *)[self.view viewWithTag:208];
            break;
        case 9:
            fetchedUser = [fetchedUsers objectAtIndex:8];
            aLabel.tag = 309;
            aView = (UIImageView *)[self.view viewWithTag:209];
            break;
        default:
            break;
    }

    [self.view addSubview:aLabel];
    
    PREPCONSTRAINTS(aLabel);
    CENTER_VIEW_H_CONSTANT(self.view, aLabel, HCoord * screenFactor);
//    CENTER_VIEW_V_CONSTANT(self.view, aLabel, VCoord * screenFactor);
    int constant = 0;
    if (aView.image.size.height > 100) {
        constant = -325;// 750/2 - 90/2
    }
    ALIGN_VIEW1_TOP_TO_VIEW2_BOTTOM_CONSTANT(self.view, aLabel, aView, constant);
    aLabel.text =  fetchedUser.userName;

    return aLabel;
}

-(UIButton *)setAddUserButtonforPlace:(int)HCoord and:(int)VCoord{

    UIButton *addUserBtn = [[UIButton alloc] init];
    UIImage *anImage;
    
    //We will tag the view to distinguish the tap
    addUserBtn.tag = 200;
    [self.view addSubview:addUserBtn];

    PREPCONSTRAINTS(addUserBtn);
    CENTER_VIEW_H_CONSTANT(self.view, addUserBtn, HCoord * screenFactor);
    CENTER_VIEW_V_CONSTANT(self.view, addUserBtn, VCoord * screenFactor);
    CONSTRAIN_SIZE(addUserBtn, 90 * screenFactor, 90 * screenFactor);
    
    anImage = [UIImage imageNamed: @"button_add_user"];
    [addUserBtn setImage:anImage forState:UIControlStateNormal];
    
    addUserBtn.layer.cornerRadius = 45;
    addUserBtn.layer.masksToBounds = YES;
//    addUserBtn.layer.borderWidth = 3.0f;
    addUserBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    //add tap gesture recognizer to each image view
    UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(handleTap:)];
    [addUserBtn addGestureRecognizer:aTap];
    addUserBtn.userInteractionEnabled = YES;
    return addUserBtn;
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
        case 205:
            aLabel = (UILabel *)[self.view viewWithTag:305];
            break;
        case 206:
            aLabel = (UILabel *)[self.view viewWithTag:306];
            break;
        case 207:
            aLabel = (UILabel *)[self.view viewWithTag:307];
            break;
        case 208:
            aLabel = (UILabel *)[self.view viewWithTag:308];
            break;
        case 209:
            aLabel = (UILabel *)[self.view viewWithTag:309];
            break;
        default:
            break;
    }
    if (view.tag == 200) {
        //add user
        UserInfoRegisterViewController *addUserVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInfoRegisterViewController"];
        [self.navigationController pushViewController:addUserVC animated:YES];
    }
    else
    {
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
}
@end
