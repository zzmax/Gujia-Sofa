//
//  SetViewController.m
//  iSmartHome
//
//  Created by admin on 16/7/12.
//  Copyright © 2016年 zzmax. All rights reserved.
//

#import "SetViewController.h"
#import "ConstraintMacros.h"
#import "WifiInfoViewController.h"

@interface SetViewController ()

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = NAVIGATION_COLOR;
    
    self.tableView.backgroundColor = NAVIGATION_COLOR;
   
    CGSize aSize = CGSizeMake(SCREEN_WIDTH, 200);
    CGRect aRect = self.tableView.frame;
    aRect.size = aSize;
    self.tableView.frame = aRect;
    self.tableView.scrollEnabled = YES;
    
    
    // set title
    self.navigationItem.title = @"设置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"InfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    //initiate table data
    NSMutableArray *infoTitlesSectionArray = [[NSMutableArray alloc]initWithCapacity:1];
    NSMutableArray *infoTitlesSectionOne = [[NSMutableArray alloc]initWithCapacity:2];
    
    //section 0
    [infoTitlesSectionOne addObject:@"设备管理"];
    [infoTitlesSectionOne addObject:@"版本"];
    
    //add to 2-dimension array
    [infoTitlesSectionArray addObject:infoTitlesSectionOne];
    
    NSArray *anArray = infoTitlesSectionArray[indexPath.section];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
   
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
            WifiInfoViewController *wifiInfoVC = [[WifiInfoViewController alloc] init];
            wifiInfoVC.navigationItem.title = @"沙发连接Wifi信息";
            [self.navigationController pushViewController:wifiInfoVC animated:YES];
            //            userChangeVC.navigationItem.title = @"家人健康信息";
            //            [self.navigationController pushViewController:userChangeVC animated:YES];
            //            UsersCreationViewController *userChangeVC = [[UsersCreationViewController alloc]init];
           
        }
        else if (indexPath.row == 1)
        {
            //DeviceControlView
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
//        case 1:
//            return 4;
//        case 2:
//            return 3;
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//set cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (SCREEN_HEIGHT < 500) {
        return SCREEN_HEIGHT / 13;
    }
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
    
    //    [tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
}


@end
