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

@interface NavigationViewController()



@end


@implementation NavigationViewController

-(void)viewDidLoad
{
    self.view.backgroundColor = NAVIGATION_COLOR;
    self.navigationController.navigationBarHidden = YES;
    self.tableView.backgroundColor = NAVIGATION_COLOR;
    //set tableview width = screen width
    self.tableView.transform = CGAffineTransformMakeScale(SCREEN_WIDTH/self.tableView.bounds.size.width, 1);
    self.tableView.scrollEnabled = NO;
}

#pragma mark - table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"InfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    //initiate table data
    NSMutableArray *infoTitlesSectionArray = [[NSMutableArray alloc]initWithCapacity:3];
    NSMutableArray *infoTitlesSectionOne = [[NSMutableArray alloc]initWithCapacity:2];
    NSMutableArray *infoTitlesSectionTwo = [[NSMutableArray alloc]initWithCapacity:4];
    NSMutableArray *infoTitlesSectionThree = [[NSMutableArray alloc]initWithCapacity:3];
    
    //section 0
    [infoTitlesSectionOne addObject:@"顾家人"];
    [infoTitlesSectionOne addObject:@"管理我的设备"];
    //section 1
    [infoTitlesSectionTwo addObject:@"升降控制"];
    [infoTitlesSectionTwo addObject:@"座椅加热"];
    [infoTitlesSectionTwo addObject:@"健康检查"];
    [infoTitlesSectionTwo addObject:@"称重"];
    //section 2
    [infoTitlesSectionThree addObject:@"健康提醒"];
    [infoTitlesSectionThree addObject:@"健康使用说明"];
    [infoTitlesSectionThree addObject:@"设置"];
    //add to 2-dimension array
    [infoTitlesSectionArray addObject:infoTitlesSectionOne];
    [infoTitlesSectionArray addObject:infoTitlesSectionTwo];
    [infoTitlesSectionArray addObject:infoTitlesSectionThree];
    
    NSMutableArray *imageNamesSectionArray = [[NSMutableArray alloc]initWithCapacity:3];
    NSMutableArray *imageNamesSectionOne = [[NSMutableArray alloc]initWithCapacity:2];
    NSMutableArray *imageNamesSectionTwo = [[NSMutableArray alloc]initWithCapacity:4];
    NSMutableArray *imageNamesSectionThree = [[NSMutableArray alloc]initWithCapacity:3];
    //section 0
    [imageNamesSectionOne addObject:@"icon_gujiaren"];
    [imageNamesSectionOne addObject:@"icon_manage_device"];
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

//push the view
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            //GujiarenView
            //
            ////            Module1ViewController *module1VC = [[Module1ViewController alloc]init];
            ////            [self.navigationController pushViewController:module1VC animated:YES];
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
            //
            ////            Module1ViewController *module1VC = [[Module1ViewController alloc]init];
            ////            [self.navigationController pushViewController:module1VC animated:YES];
        }
        else if (indexPath.row == 2)
        {
            //HealthExamView
            //
            ////            Module1ViewController *module1VC = [[Module1ViewController alloc]init];
            ////            [self.navigationController pushViewController:module1VC animated:YES];
        }
        else if (indexPath.row == 3)
        {
            //WeightView
            //
            ////            Module1ViewController *module1VC = [[Module1ViewController alloc]init];
            ////            [self.navigationController pushViewController:module1VC animated:YES];
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0) {
            //HealthReminderView
            //
            ////            Module1ViewController *module1VC = [[Module1ViewController alloc]init];
            ////            [self.navigationController pushViewController:module1VC animated:YES];
        }
        else if (indexPath.row == 1)
        {
            //HelpView
            //
            ////            Module1ViewController *module1VC = [[Module1ViewController alloc]init];
            ////            [self.navigationController pushViewController:module1VC animated:YES];
        }
        else if (indexPath.row == 2)
        {
            //SetView
            //
            ////            Module1ViewController *module1VC = [[Module1ViewController alloc]init];
            ////            [self.navigationController pushViewController:module1VC animated:YES];
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
            return 2;
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
    return SCREEN_HEIGHT/12;
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
}

@end
