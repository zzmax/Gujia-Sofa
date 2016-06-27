//
//  ConfiguratingViewController.m
//  iSmartHome
//
//  Created by admin on 15/12/11.
//  Copyright © 2015年 zzmax. All rights reserved.
//
//  This view is to show the progress of the conifguration and the search of device

#import "ConfiguratingViewController.h"
#import "ConstraintMacros.h"
#import "THProgressView.h"
#import "UsersCreationViewController.h"
#import "SmartFirstConfig.h"
#import "GlobalSocket.h"


@interface ConfiguratingViewController ()<SmartFirstConfigDelegate>
{
    NSTimer *_timer;//progressBar
    NSTimer *_timeoutTimer;
    NSTimer *_searchTimer;
    SmartFirstConfig *_firstConfig;
    NSMutableArray * _allMacArray;
    GlobalSocket *_globalSocket;
}
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
//The label to show which step we are : Configurate the sofa or search the device
@property (weak, nonatomic) IBOutlet UILabel *progressDescription;

@property (weak, nonatomic) IBOutlet UIView *progressBarContainer;
@property (nonatomic) CGFloat progress;
@property (nonatomic, strong) THProgressView *aProgressView;
@end

@implementation ConfiguratingViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.navigationItem.title = @"配置";
    
    self.progressDescription.text = @"正在努力配置您的智能沙发";//"搜索设备"？
    self.progressDescription.textColor = [UIColor blackColor];
    self.progressDescription.textAlignment = NSTextAlignmentCenter;
//    PREPCONSTRAINTS(_progressDescription);
//    CENTER_VIEW_H(_progressDescription.superview,_progressDescription);
//    ALIGN_VIEW_TOP_CONSTANT(self.view, _progressDescription, 350);
//    CONSTRAIN_SIZE(_progressDescription, 30, 300);
    
    self.progressBarContainer.backgroundColor = NAVIGATION_COLOR;
//    self.progressBar.progressViewStyle = UIProgressViewStyleBar;
//    self.progressBar.trackTintColor = [UIColor whiteColor];
    PREPCONSTRAINTS(_progressBarContainer);
//    CENTER_VIEW_H(_progressBar.superview,_progressBar);
    ALIGN_VIEW_TOP_CONSTANT(self.view, _progressBarContainer, SCREEN_HEIGHT/3);
//    CONSTRAIN_SIZE(_progressBarContainer, 30, SCREEN_WIDTH - 60);
    CGRect aRect =  _progressBarContainer.frame;
    
//    _aProgressView.frame.origin = CGPointMake(10, SCREEN_HEIGHT/3);
    aRect.size = CGSizeMake(SCREEN_WIDTH - 60, 40);
    
//    aRect = CGRectMake(10, SCREEN_HEIGHT/3, SCREEN_WIDTH - 60, 30);
    _progressBarContainer.frame = aRect;
    self.progressBarContainer.layer.cornerRadius = 5;
    self.progressBarContainer.layer.masksToBounds = YES;
    
    int aMarginToMinus = 20;
    if (IS_IPHONE_PLUS) {
        aMarginToMinus = 26;
    }
    self.aProgressView = [[THProgressView alloc] initWithFrame:CGRectMake(4,
                                                                          CGRectGetMidY(_progressBarContainer.bounds) - 15,
                                                                          _progressBarContainer.bounds.size.width - aMarginToMinus,
                                                                          20)];
//    self.aProgressView.layer.
//    NSLog(@"%f",CGRectGetMidY(_progressBarContainer.bounds));
    _aProgressView.borderTintColor = [UIColor whiteColor];
    _aProgressView.progressTintColor = [UIColor blueColor];
    _aProgressView.progressBackgroundColor = [UIColor whiteColor];
    [self.progressBarContainer addSubview:_aProgressView];
    [self.progressBarContainer bringSubviewToFront:self.aProgressView];
//    PREPCONSTRAINTS(_aProgressView);
//    ALIGN_VIEW_LEFT(_progressBarContainer, _aProgressView);
//    CENTER_VIEW(self.progressBarContainer, _aProgressView);

    
    _cancelBtn.tintColor = [UIColor whiteColor];
    _cancelBtn.frame = BOTTOM_RECT;
    PREPCONSTRAINTS(_cancelBtn);
    ALIGN_VIEW_LEFT_CONSTANT(_cancelBtn.superview,_cancelBtn, 10);
    ALIGN_VIEW_RIGHT_CONSTANT(_cancelBtn.superview, _cancelBtn, -10);
    ALIGN_VIEW_BOTTOM_CONSTANT(self.view, _cancelBtn, -40);
    
    [self createTimeoutTimer];
    _allMacArray = [[NSMutableArray alloc]initWithCapacity:0];
    _firstConfig = [[SmartFirstConfig alloc]init];
    _firstConfig.fristConfigDelegate = self;
    
     [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getToNextVC) userInfo:nil repeats:NO ];
    
    //首次配置
//    [_firstConfig doSmartFirstConfig:self.staId sspwd:self.staPwd realCommandArr:nil andOperType:4];
    
//    [NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(getToNextVC) userInfo:nil repeats:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self deallocTimer];
}

-(void) getToNextVC
{
    [_timer invalidate];
        UsersCreationViewController *userCreationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UsersCreationViewController"];
        [self.navigationController pushViewController:userCreationVC animated:YES];
//    NavigationViewController *navigationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"];
//    [self.navigationController pushViewController:navigationVC animated:YES];

}

- (IBAction)cancelToConnectSofa:(id)aButton
{
    [self deallocTimer];
    [self popView:self.cancelBtn];
}


- (IBAction)popView:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateProgress
{
    self.progress += 0.20f;
    if (self.progress >= 1.0f) {
        if (self.progress - 1.0f <= 0.2000f) {
            self.progress = 1.01f;
        }
        else    self.progress = 0;
    }
    
    if (self.progress == 0) {
        [_aProgressView setProgress:self.progress animated:NO];
    }
    else
    [_aProgressView setProgress:self.progress animated:YES];
}

- (void)deallocTimer {
    [_timer invalidate];
    _timer = nil;
    [_timeoutTimer invalidate];
    _timeoutTimer = nil;
    [_searchTimer invalidate];
    _searchTimer = nil;
    [_firstConfig smartSocketClose];
    _firstConfig = nil;
}


/**
 *  第一次成功配置了沙发路由模块
 *
 *  @param reaMac  路由模块mac地址
 */
-(void)onSmartFirstConfigSuccess:(NSString *)reaMac
{
    [_timer invalidate];
    _timer = nil;
    [_timeoutTimer invalidate];
    _timeoutTimer = nil;
    _firstConfig.fristConfigDelegate = nil;
    [self successConfig];
    
}
-(void)onSmartFirstConfigFailure
{
    [_timer invalidate];
    _timer = nil;
    [_timeoutTimer invalidate];
    _timeoutTimer = nil;
    [_firstConfig smartSocketClose];
    [self failConfig];
}

-(void)successConfig{
    
//    [UserDef setValue:self.wifePad forKey:self.wifiName];
    [self startSearch];
    
}
-(void)failConfig{
    
    UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"消息" message:@"配置失败，是否重新配置?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alterView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self createTimeoutTimer];
        _firstConfig = [[SmartFirstConfig alloc]init];
        _firstConfig.fristConfigDelegate = self;
        [_firstConfig doSmartFirstConfig:self.staId sspwd:self.staPwd realCommandArr:nil andOperType:4];
    }else
    {
//        [OperationDeviceCallBack DestoryDelegate];
        [self deallocTimer];
        _firstConfig.fristConfigDelegate = nil;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

/**
 *  开始搜索设备
 */
-(void)startSearch
{
    self.progressDescription.text = @"Wi-Fi模块已配置，正在努力搜索设备";
    if (_timer) {
        [_timer invalidate];
        _timer=nil;
    }
    if (_timeoutTimer) {
        [_timeoutTimer invalidate];
        _timeoutTimer = nil;
    }
    if (_searchTimer) {
        [_searchTimer invalidate];
        _searchTimer = nil;
    }
    if (_firstConfig) {
        _firstConfig.fristConfigDelegate = nil;
        [_firstConfig smartSocketClose];
        _firstConfig = nil;
    }
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
        [_timer fire];
    }
    if (!_searchTimer) {
        //超时处理
        _searchTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(searchNewMacReusult) userInfo:nil repeats:NO];
    }
    [_allMacArray removeAllObjects];
    _firstConfig = [[SmartFirstConfig alloc]init];
    _firstConfig.fristConfigDelegate = self;
    [_firstConfig doSmartFirstConfig:nil sspwd:nil realCommandArr:nil andOperType:0];
    
}


- (void)createTimeoutTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    if (_timeoutTimer) {
        [_timeoutTimer invalidate];
        _timeoutTimer = nil;
    }
    _timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(onSmartFirstConfigFailure) userInfo:nil repeats:NO];
    if (!_timer) {
        //制定progress bar的滚动时间间隔
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
        [_timer fire];
    }
}

/**
 *  When we detect the device, we will enter into this function
 *
 *  @param allMacInfo the whole information about this device
 */
-(void)onSmartSearchSuccess:(NSDictionary *)allMacInfo
{
    NSString *codeName = [allMacInfo objectForKey:@"CodeName"];
    if ([codeName isEqualToString:@"SearchAck"]) {
        NSLog(@"========allMacInfo======%@",allMacInfo);
        BOOL isHave = NO;
        for (int i=0; i<_allMacArray.count; i++) {
            NSDictionary * allHaveInfo = _allMacArray[i];
            if ([MBNonEmptyString(allMacInfo[@"Mac"]) isEqualToString:MBNonEmptyString(allHaveInfo[@"Mac"])]) {
                isHave = YES;
                break;
            }
        }
        if (!isHave) {
            [_allMacArray addObject:allMacInfo];
        }
    }
}

- (void)searchNewMacReusult {
    if (_allMacArray.count==0) {
            if (_searchTimer) {
                [_searchTimer invalidate];
                _searchTimer = nil;
            }
            if (_timer) {
                [_timer invalidate];
                _timer = nil;
            }
            if (_timeoutTimer) {
                [_timeoutTimer invalidate];
                _timeoutTimer = nil;
            }
            if (_firstConfig) {
                [_firstConfig smartSocketClose];
                _firstConfig = nil;
            }

        self.progressDescription.text = @"未检测到设备";
    }
    else
    {
        self.progressDescription.text = @"已检测到设备，正在连接";
        /**
         *  连接Wi-Fi
         */
        NSString *hostipStr = [MBNonEmptyString(_allMacArray[0][@"Mip"]) componentsSeparatedByString:@"`"][1];
        NSString *portStr = [MBNonEmptyString(_allMacArray[0][@"cInfo"]) componentsSeparatedByString:@"`"][1];
        _globalSocket = [GlobalSocket sharedGlobalSocket];
        
        [_globalSocket setHost:hostipStr];
        [_globalSocket setPort:portStr];
        [_globalSocket initNetworkCommunication];

        if ([_globalSocket.message isEqualToString:@"连接成功"]) {
            self.progressDescription.text = @"连接成功";
            _searchTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(getToNextVC) userInfo:nil repeats:YES];
        }
        else
        {
            self.progressDescription.text = @"连接不成功";
            [self deallocTimer];
        }
    }
}

@end
