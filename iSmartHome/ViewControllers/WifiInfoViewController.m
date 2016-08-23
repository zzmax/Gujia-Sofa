//
//  WifiInfoViewController.m
//  iSmartHome
//
//  Created by admin on 16/7/12.
//  Copyright © 2016年 zzmax. All rights reserved.
//

#import "WifiInfoViewController.h"
#import "ConstraintMacros.h"
#import "Utility.h"
#import "CoreDataHelper.h"
#import "GlobalSocket.h"
#import "ConfiguratingViewController.h"
#import "AppDelegate.h"

@interface WifiInfoViewController ()<UtilityDelegate>
{
    CoreDataHelper *dataHelper;
    GlobalSocket *globalSocket;
    Utility *utility;
    NSArray *infoTitles;
    NSArray *wifiInfos;//info to show in table
    NSArray *fetchedWifiInfo;
    UITextField *cellTF;
}
@property (weak, nonatomic) IBOutlet UIButton *reconfigBtn;

@end

@implementation WifiInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Establish Core Data
    dataHelper = [[CoreDataHelper alloc] init];
    dataHelper.entityName = @"WifiInfo";
    dataHelper.defaultSortAttribute = @"ssid";
    // Setup data
    [dataHelper setupCoreData];
    
    //initiate connection to wifi
    globalSocket = [GlobalSocket sharedGlobalSocket];
    
    //initiate variable
    utility = [[Utility alloc]init];
    utility.utilityDelegateDelegate = self;

    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = NAVIGATION_COLOR;
    
    self.tableView.backgroundColor = NAVIGATION_COLOR;
    
    CGSize aSize = CGSizeMake(SCREEN_WIDTH, 350);
    CGRect aRect = self.tableView.frame;
    aRect.size = aSize;
    self.tableView.frame = aRect;
    self.tableView.scrollEnabled = NO;

    
    //set back button
//    UIBarButtonItem *newBackButton =
//    [[UIBarButtonItem alloc] initWithCustomView:[utility transformAnImageAndReturnAView:@"icon_back" width:40 heigt:40]];
//    [[self navigationItem] setLeftBarButtonItem:newBackButton];

    //initiate table data
    infoTitles = [NSArray arrayWithObjects:@"Wifi名称：",@"沙发MAC地址：", @"IP：", @"端口：", @"上次连接状态：",nil];
    
    //initiate table data
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSError *error;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WifiInfo"
                                              inManagedObjectContext:dataHelper.context];
    [fetchRequest setEntity:entity];
    fetchedWifiInfo = [dataHelper.context executeFetchRequest:fetchRequest error:&error];
    if (!fetchedWifiInfo) {
        [utility setAlert:@"Wifi信息缺失" message:@"重新连接？"];
        [self presentViewController:utility.anAlert animated:YES completion:nil];
    }
    else
    {
        
        for (WifiInfo *res in fetchedWifiInfo) {
            wifiInfos = [NSArray arrayWithObjects:res.ssid, res.mac, res.ip, res.port.stringValue, res.state.intValue == 1? @"连接成功":@"连接不成功",nil];
        }
    }
    
    _reconfigBtn.frame = BOTTOM_RECT;
    PREPCONSTRAINTS(_reconfigBtn);
    ALIGN_VIEW_LEFT_CONSTANT(_reconfigBtn.superview,_reconfigBtn, 10);
    ALIGN_VIEW_RIGHT_CONSTANT(_reconfigBtn.superview, _reconfigBtn, -10);
    ALIGN_VIEW_BOTTOM_CONSTANT(self.view, _reconfigBtn, -20);
    
    [_reconfigBtn setTitle:@"重新配置沙发" forState:UIControlStateNormal];
    _reconfigBtn.titleLabel.textColor = [UIColor blackColor];
    
    [_reconfigBtn setExclusiveTouch:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    // set title
    self.navigationItem.title = @"沙发连接Wifi信息";
    [self reloadInputViews];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)reconfigurateWifi:(NSInteger)reconfigOrNot
{
    if (reconfigOrNot == 1) {
        [globalSocket setHost:@""];
        [globalSocket disconnect];
        [dataHelper fetchItemsMatching:[wifiInfos objectAtIndex:0] forAttribute:@"ssid" sortingBy:nil];
        if ([dataHelper deleteObject:dataHelper.fetchedResultsController.fetchedObjects.firstObject])
        {
            ConfiguratingViewController *configVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ConfiguratingViewController"];
            configVC.isConfigurateDeviceMode = NO;
            [self.navigationController pushViewController:configVC animated:YES];
            
            
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [app changeRootViewController:configVC];
        
        }

    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)startReconfigWifi: (UIButton *)sender
{    
    [utility setAlert:@"重新配置WiFi" message:@"这将删除已经连接的Wi-Fi信息，确认重新连接？"];
    [self presentViewController:utility.anAlert animated:YES completion:nil];
}

#pragma mark - table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"InfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    //set textField for wifiinfo
    cellTF = [[UITextField alloc] init];
    cellTF.frame = CGRectMake(SCREEN_WIDTH * 5/12 - 10, 15, SCREEN_WIDTH * 7/12, 28);
//    _birthdayTF.inputView = datePicker;
    cellTF.inputAccessoryView = nil;
    cellTF.textColor = [UIColor whiteColor];
    cellTF.textAlignment = NSTextAlignmentRight;
    cellTF.text = [wifiInfos objectAtIndex: indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cellTF.userInteractionEnabled = NO;
    [cell.contentView addSubview:cellTF];

    
    //get the value in the array
    cell.textLabel.text = [infoTitles objectAtIndex: indexPath.row];
    
    cell.backgroundColor = NAVIGATION_COLOR;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.clipsToBounds = YES;
//    cell.accessoryType = UITableViewCellAccessoryDetailButton;


    
    return cell;
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
    return [infoTitles count];
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
