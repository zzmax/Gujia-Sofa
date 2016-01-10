//
//  WeightResultViewController.m
//  iSmartHome
//
//  Created by admin on 15/12/23.
//  Copyright © 2015年 zzmax. All rights reserved.
//

#import "WeightResultViewController.h"
#import "ConstraintMacros.h"
#import "GlobalSocket.h"

@interface WeightResultViewController ()
{
    NSTimer *getMessageTimer;
}

@property (weak, nonatomic) IBOutlet UILabel  *weightLbl;

@property GlobalSocket *globalSocket;
@end

@implementation WeightResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // show the naviagtion bar
    self.navigationController.navigationBarHidden = NO;
    // set title
    self.navigationItem.title = @"健康检测";
    self.view.backgroundColor = BACKGROUND_COLOR;
    //set data
    _globalSocket = [GlobalSocket sharedGlobalSocket];
//    [self initAcquireSensorDataMessage];
    
    [self startGetTempMessageTimer];
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

#pragma mark - sofa control part
/**
 *  This method is to send a message to sensors to acquire data.
 */
//-(void)initAcquireSensorDataMessage
//{
//    sendDataLength = 8;
//}

/**
 *  Set the timer for the message sender.
 Per 400ms we will send a message.
 */
-(void)startGetTempMessageTimer
{
    getMessageTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setLbl) userInfo:nil repeats:YES ];
    
}

/**
 *  Stop the timer 400ms and stop sending the message.
 */
-(void)stopGetTempMessageTimer
{
    if (getMessageTimer != nil)
    {
        [getMessageTimer invalidate];
    }
}

-(void) setLbl
{
    [_weightLbl setText:_globalSocket.weight];
}

@end
