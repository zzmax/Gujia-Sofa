//
//  NavigationViewController.m
//  iSmartHome
//
//  Created by admin on 15/12/15.
//  Copyright © 2015年 zzmax. All rights reserved.
//
//  This view is a table view which contains the whole fonctionnalities of this application.

#import "NavigationViewController.h"
#import "ConstraintMacros.h"
#import "SofaControlViewController.h"
#import "SofaHeatViewController.h"
#import "HealthExamResultViewController.h"
#import "WeightResultViewController.h"
#import "UsersCreationViewController.h"
#import "CurrentUser.h"
#import "UserInfoRegisterViewController.h"
#import "HealthConditionTrendencyViewController.h"
#import "HealthReminderViewController.h"
#import "SetViewController.h"
#import "Utility.h"
#import "Nav1ViewController.h"
#import "AppDelegate.h"

@interface NavigationViewController()
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
@property CurrentUser *currentUser;
@property Utility *utility;

@end


@implementation NavigationViewController

-(void)viewDidLoad
{
    self.view.backgroundColor = NAVIGATION_COLOR;
    
    self.tableView.backgroundColor = NAVIGATION_COLOR;
    //set tableview width = screen width
//    self.tableView.transform = CGAffineTransformMakeScale(SCREEN_WIDTH/self.tableView.bounds.size.width, 1);
    
    
    CGSize aSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 3 / 4);
    CGRect aRect = self.tableView.frame;
    aRect.size = aSize;
    self.tableView.frame = aRect;
    self.tableView.scrollEnabled = YES;
    
    
//    if (SCREEN_HEIGHT <= 500) {
//        ALIGN_VIEW_BOTTOM(self.view, self.tableView);
//    }
    
    //add a tap gesture recognizer to change the view to the user photo
    UITapGestureRecognizer *photoTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushViewToModifyUserInfo:)];
    photoTapRecognizer.delegate = self;
    self.userPhoto.userInteractionEnabled = YES;
    [self.userPhoto addGestureRecognizer:photoTapRecognizer];
    
   
    _currentUser = [CurrentUser staticCurrentUser];
    _userNameLbl.text = _currentUser.userName;
    _utility = [[Utility alloc]init];
    
    
    //set image to a circle
    self.userPhoto.layer.cornerRadius = self.userPhoto.frame.size.width/2;
    self.userPhoto.layer.masksToBounds = YES;
    self.userPhoto.layer.borderWidth = 3.0f;
    self.userPhoto.layer.borderColor = [UIColor whiteColor].CGColor;

}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    //set back button to white color
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //set title to white color
    [self.navigationController.navigationBar
     setTitleTextAttributes: @{NSForegroundColorAttributeName : [UIColor whiteColor]}];
   
    _userPhoto.image = [_utility loadPhotoForUser:_currentUser.userName];
}

#pragma mark - table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"InfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    //initiate table data
    NSMutableArray *infoTitlesSectionArray = [[NSMutableArray alloc]initWithCapacity:3];
    NSMutableArray *infoTitlesSectionOne = [[NSMutableArray alloc]initWithCapacity:1];
    NSMutableArray *infoTitlesSectionTwo = [[NSMutableArray alloc]initWithCapacity:4];
    NSMutableArray *infoTitlesSectionThree = [[NSMutableArray alloc]initWithCapacity:3];
    
    //section 0
    [infoTitlesSectionOne addObject:@"顾家人"];
//    [infoTitlesSectionOne addObject:@"管理我的设备"];
    //section 1
    [infoTitlesSectionTwo addObject:@"升降控制"];
    [infoTitlesSectionTwo addObject:@"座椅加热"];
    [infoTitlesSectionTwo addObject:@"健康检查"];
    [infoTitlesSectionTwo addObject:@"称重"];
    //section 2
    [infoTitlesSectionThree addObject:@"健康提醒"];
    [infoTitlesSectionThree addObject:@"健康结果趋势"];
    [infoTitlesSectionThree addObject:@"设置"];
    //add to 2-dimension array
    [infoTitlesSectionArray addObject:infoTitlesSectionOne];
    [infoTitlesSectionArray addObject:infoTitlesSectionTwo];
    [infoTitlesSectionArray addObject:infoTitlesSectionThree];
    
    NSMutableArray *imageNamesSectionArray = [[NSMutableArray alloc]initWithCapacity:3];
    NSMutableArray *imageNamesSectionOne = [[NSMutableArray alloc]initWithCapacity:1];
    NSMutableArray *imageNamesSectionTwo = [[NSMutableArray alloc]initWithCapacity:4];
    NSMutableArray *imageNamesSectionThree = [[NSMutableArray alloc]initWithCapacity:3];
    //section 0
    [imageNamesSectionOne addObject:@"icon_gujiaren"];
//    [imageNamesSectionOne addObject:@"icon_manage_device"];
    //section 1
    [imageNamesSectionTwo addObject:@"icon_sofa_control"];
    [imageNamesSectionTwo addObject:@"icon_sofa_heat"];
    [imageNamesSectionTwo addObject:@"icon_health_exam"];
    [imageNamesSectionTwo addObject:@"icon_weight"];
    //section 2
    [imageNamesSectionThree addObject:@"icon_health_reminder"];
    [imageNamesSectionThree addObject:@"icon_help"];
    [imageNamesSectionThree addObject:@"icon_option"];
    //add to the 2-dimension array
    [imageNamesSectionArray addObject:imageNamesSectionOne];
    [imageNamesSectionArray addObject:imageNamesSectionTwo];
    [imageNamesSectionArray addObject:imageNamesSectionThree];
    
    NSArray *anArray = imageNamesSectionArray[indexPath.section];
    UIImage *image = [UIImage imageNamed: anArray[indexPath.row]];
    CGFloat widthScale = 25/image.size.width;
    CGFloat heightScale = 25/image.size.height;
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.imageView.image = image;
    //change the size of the imageview in cell to (25,25)
    cell.imageView.transform = CGAffineTransformMakeScale(widthScale, heightScale);
    //get the array of the section
    anArray = infoTitlesSectionArray[indexPath.section];
    //get the value in the array
    cell.textLabel.text = anArray[indexPath.row];
    cell.backgroundColor = NAVIGATION_COLOR;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.clipsToBounds = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //set the selection color to blue
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:0 green:0.47843f blue:1.0f alpha:0.85f];
    [cell setSelectedBackgroundView:bgColorView];
    
    
    return cell;
}

/**
 *  push the view from tableView
 *
 *  @param tableView : the Navigation table
 *  @param indexPath : index in Navigation table
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            //     GujiarenView
            //     Change user
            UsersCreationViewController *userChangeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UsersCreationViewController"];
            userChangeVC.navTitle = @"家人健康信息";
            [self.navigationController pushViewController:userChangeVC animated:YES];
            
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [app changeRootViewController:userChangeVC];
        }
        else
        {
            //DeviceControlView
            //
            ////            Module1ViewController *module1VC = [[Module1ViewController alloc]init];
            ////            [self.navigationController pushViewController:module1VC animated:YES];
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            //SofaControlView
            SofaControlViewController *sofaConttrolVC = [[SofaControlViewController alloc] init];
            [self.navigationController pushViewController:sofaConttrolVC animated:YES];
        }
        else if (indexPath.row == 1)
        {
            //SofaHeatView
            SofaHeatViewController *sofaHeatVC = [[SofaHeatViewController alloc]init];
            [self.navigationController pushViewController:sofaHeatVC animated:YES];
            //animation
//            SofaHeatViewController *nextView = [[SofaHeatViewController alloc] init];
//            [UIView animateWithDuration:0.75
//                             animations:^{
//                                 [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//                                 [self.navigationController pushViewController:nextView animated:NO];
//                                 [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
//                             }];
//
            
        }
        else if (indexPath.row == 2)
        {
            //HealthExamView
            HealthExamResultViewController *healthExamResultVC = [[HealthExamResultViewController alloc]init];
            [self.navigationController pushViewController:healthExamResultVC animated:YES];
        }
        else if (indexPath.row == 3)
        {
            //WeightResultView
            //
            WeightResultViewController *weightResultVC = [[WeightResultViewController alloc]init];
            [self.navigationController pushViewController:weightResultVC animated:YES];
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0) {
            //HealthReminderView
            HealthReminderViewController *healthReminderVC = [[HealthReminderViewController alloc]init];
            [self.navigationController pushViewController:healthReminderVC animated:YES];
        }
        else if (indexPath.row == 1)
        {
            //HealthConditionTrendencyView
            //
            HealthConditionTrendencyViewController *healthConditionTrendencyVC = [[HealthConditionTrendencyViewController alloc]init];
            [self.navigationController pushViewController:healthConditionTrendencyVC animated:YES];
        }
        else if (indexPath.row == 2)
        {
            //SetView
            //
            SetViewController *setVC = [[SetViewController alloc]init];
            [self.navigationController pushViewController:setVC animated:YES];
        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return 10.0f;
    }
    else return 1.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *v = (UITableViewHeaderFooterView *)view;
    //set the color of section
    v.backgroundView.backgroundColor = BACKGROUND_COLOR;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 4;
        case 2:
            return 3;
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

//set cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (SCREEN_HEIGHT < 500) {
        return SCREEN_HEIGHT / 13;
    }
    return SCREEN_HEIGHT / 12;
}

//set the inset of the separator to zero
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
//    [tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)pushViewToModifyUserInfo:(UITapGestureRecognizer*)sender
{
    UserInfoRegisterViewController *userInfoRegisterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInfoRegisterViewController"];
    userInfoRegisterVC.navTitle = @"修改用户信息";
    [self.navigationController pushViewController:userInfoRegisterVC animated:YES];
}

@end
