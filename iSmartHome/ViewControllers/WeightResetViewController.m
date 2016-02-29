//
//  WeightResetViewController.m
//  iSmartHome
//
//  Created by admin on 15/12/23.
//  Copyright © 2015年 zzmax. All rights reserved.
//

#import "WeightResetViewController.h"
#import "WeightResultViewController.h"
#import "ConstraintMacros.h"
#import "GlobalSocket.h"

@interface WeightResetViewController ()
{
    int   sendDataLength;
    NSTimer *getMessageTimer;
}

@property (nonatomic, retain) IBOutlet UIView *weightResetView;
@property (weak, nonatomic) IBOutlet UIButton *weightResetBtn;
@property (weak, nonatomic) IBOutlet UIImageView  *bigBlueCircleImg;

@property GlobalSocket *globalSocket;
@end

@implementation WeightResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // set title
    self.navigationItem.title = @"健康检测";
    self.view.backgroundColor = BACKGROUND_COLOR;
    [[_weightResetBtn layer] setBorderWidth: 0];
    [[_weightResetBtn layer] setBorderColor: BACKGROUND_COLOR.CGColor];
    _weightResetBtn.frame = BOTTOM_RECT;
    PREPCONSTRAINTS(_weightResetBtn);
    ALIGN_VIEW_LEFT_CONSTANT(_weightResetBtn.superview,_weightResetBtn, 10);
    ALIGN_VIEW_RIGHT_CONSTANT(_weightResetBtn.superview, _weightResetBtn, -10);
    ALIGN_VIEW_BOTTOM_CONSTANT(self.weightResetView, _weightResetBtn, -20);
    
    CGFloat widthScale = (SCREEN_WIDTH * 0.7 )/_bigBlueCircleImg.frame.size.width;
    CGFloat heightScale = (SCREEN_WIDTH * 0.7 ) / _bigBlueCircleImg.frame.size.height;
    _bigBlueCircleImg.transform = CGAffineTransformMakeScale(widthScale, heightScale);
    
    //set data
    _globalSocket = [GlobalSocket sharedGlobalSocket]; 
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
 *  When we clicked the button to reset weight, we send a message to sensor for resetting
 *
 *  @param sender :button
 */
- (IBAction)resetWeightDown:(id)sender
{
    [_weightResetBtn setTitle:@"清零中..." forState:UIControlStateNormal];
    [self startSendMessageTimer];
    //After 3s, stop sending message
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(stopSendMessgeTimer) userInfo:nil repeats:NO ];
}

/**
 *  This method is to send a message to sensors to acquire data.
 */
-(void)sendMEssageToResetWeight
{
    sendDataLength = 8;
    [_globalSocket initAcquireSensorDataMessage];
    //set the buffer to the value of reset weight command
    [_globalSocket setInputBuffer:2 and:0x05];
    [_globalSocket setInputBuffer:3 and:0x01];
    [_globalSocket setInputBuffer:4 and:0x01];
    [_globalSocket setInputBuffer:5 and:0x10];
    
    [_globalSocket sendMessageDown:[_globalSocket getInputBuffer] length:sendDataLength];
}

/**
 *  Set the timer for the message sender.
 Per 400ms we will send a message.
 */
-(void)startSendMessageTimer
{
    getMessageTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(sendMEssageToResetWeight) userInfo:nil repeats:YES ];
    
}

/**
 *  Stop the timer 400ms and stop sending the message.
 */
-(void)stopSendMessgeTimer
{
    if (getMessageTimer != nil)
    {
        [getMessageTimer invalidate];
    }
    if ([_globalSocket.weight intValue] == 0) {
        [_weightResetBtn setTitle:@"清零成功" forState:UIControlStateNormal];
        //After 1s, push to the view of weigh the body
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(pushToWeighView) userInfo:nil repeats:NO ];
    }
}

- (void)pushToWeighView
{
    WeightResultViewController *weightResultVC = [[WeightResultViewController alloc]init];
    [self.navigationController pushViewController:weightResultVC animated:YES];
}
@end
