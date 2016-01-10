//
//  HealthExamResultViewController.m
//  iSmartHome
//
//  Created by admin on 15/12/22.
//  Copyright © 2015年 zzmax. All rights reserved.
//

#import "HealthExamResultViewController.h"
#import "ConstraintMacros.h"
#import "GlobalSocket.h"

@interface HealthExamResultViewController ()
{
    int   sendDataLength;
    NSTimer *getMessageTimer;
}

@property (weak, nonatomic) IBOutlet UILabel  *bloodPressureLbl;
@property (weak, nonatomic) IBOutlet UILabel  *heartRateLbl;
@property (weak, nonatomic) IBOutlet UILabel  *bloodO2Lbl;
@property (weak, nonatomic) IBOutlet UILabel  *bodyTempLbl;

@property GlobalSocket *globalSocket;

@end

@implementation HealthExamResultViewController

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
    sendDataLength = 8;
    [self initAcquireSensorDataMessage];
    
    [self startGetTempMessageTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopGetTempMessageTimer];
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
-(void)initAcquireSensorDataMessage
{
//    sendDataLength = 8;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    for (int i = 0; i < 3; i++) {
        sendDataLength = 8;
        [dic setObject:[NSNumber numberWithInt:i] forKey:@"key"];
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(sendMessageToSensors:) userInfo:dic repeats:NO ];
    }
}

- (IBAction)temperatureTestDown:(id)sender
{
    [_globalSocket initAcquireSensorDataMessage];
    //acquire bodyTemp data
    [_globalSocket setInputBuffer:3 and:0x02];
    [_globalSocket setInputBuffer:4 and:0x01];
    [_globalSocket sendMessageDown:[_globalSocket getInputBuffer] length:sendDataLength];
}

- (IBAction)temperatureTestUp:(id)sender
{
    [_globalSocket initAcquireSensorDataMessage];
    //    inputBuffer[3]=0x02;
    [_globalSocket sendMessageDown:[_globalSocket getInputBuffer] length:sendDataLength];
}

- (IBAction)pulseTestDown:(id)sender
{
    [_globalSocket initAcquireSensorDataMessage];
    //acquire heartRate data
    [_globalSocket setInputBuffer:3 and:0x02];
    [_globalSocket setInputBuffer:4 and:0x02];
    [_globalSocket sendMessageDown:[_globalSocket getInputBuffer] length:sendDataLength];
}

- (IBAction)pulseTestUp:(id)sender
{
    [_globalSocket initAcquireSensorDataMessage];
    //    inputBuffer[3]=0x02;
    [_globalSocket sendMessageDown:[_globalSocket getInputBuffer] length:sendDataLength];
}

- (IBAction)bloodPressureTestDown:(id)sender
{
    [_globalSocket initAcquireSensorDataMessage];
    //acquire bloodPressure data
    [_globalSocket setInputBuffer:3 and:0x02];
    [_globalSocket setInputBuffer:4 and:0x04];
    [_globalSocket sendMessageDown:[_globalSocket getInputBuffer] length:sendDataLength];
}

- (IBAction)bloodPressureTestUp:(id)sender
{
    [_globalSocket initAcquireSensorDataMessage];
    //    inputBuffer[3]=0x02;
    [_globalSocket sendMessageDown:[_globalSocket getInputBuffer] length:sendDataLength];
}


- (void)sendMessageToSensors: (NSTimer *)aTimer
{
    NSDictionary *dict = [aTimer userInfo];
    
    int i = [[dict objectForKey:@"key"] intValue];
    switch (i) {
        case 0:
            [_globalSocket initAcquireSensorDataMessage];
            //acquire bodyTemp data
            [_globalSocket setInputBuffer:3 and:0x02];
            [_globalSocket setInputBuffer:4 and:0x01];
            [_globalSocket sendMessageDown:[_globalSocket getInputBuffer] length:sendDataLength];
            break;
        case 1:
            [_globalSocket initAcquireSensorDataMessage];
            //acquire bloodPressure data
            [_globalSocket setInputBuffer:3 and:0x02];
            [_globalSocket setInputBuffer:4 and:0x04];
            [_globalSocket sendMessageDown:[_globalSocket getInputBuffer] length:sendDataLength];
            break;
        case 2:
            [_globalSocket initAcquireSensorDataMessage];
            //acquire bloodPressure data
            [_globalSocket setInputBuffer:3 and:0x02];
            [_globalSocket setInputBuffer:4 and:0x04];
            [_globalSocket sendMessageDown:[_globalSocket getInputBuffer] length:sendDataLength];
            break;
        default:
            break;
    }
}
/**
 *  Set the timer for the message sender.
 Per 400ms we will send a message.
 */
-(void)startGetTempMessageTimer
{
    getMessageTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setLbls) userInfo:nil repeats:YES ];
    
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

-(void) setLbls
{
    [_bloodPressureLbl setText:_globalSocket.bloodPressure];
    [_heartRateLbl setText:_globalSocket.heartRate];
    [_bloodO2Lbl setText:_globalSocket.bloodO2];
    [_bodyTempLbl setText:_globalSocket.bodyTemp];
}


@end