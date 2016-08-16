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
@property (weak, nonatomic) IBOutlet UIImageView  *bigBlueCircleImg;
@property (weak, nonatomic) IBOutlet UIButton *weightResetBtn;

@property GlobalSocket *globalSocket;
@end

@implementation WeightResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // set title
    self.navigationItem.title = @"健康检测";
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    CGFloat widthScale = (SCREEN_WIDTH * 0.7 )/_bigBlueCircleImg.frame.size.width;
    CGFloat heightScale = (SCREEN_WIDTH * 0.7 ) / _bigBlueCircleImg.frame.size.height;
    _bigBlueCircleImg.transform = CGAffineTransformMakeScale(widthScale, heightScale);
    
    [[_weightResetBtn layer] setBorderWidth: 0];
    [[_weightResetBtn layer] setBorderColor: BACKGROUND_COLOR.CGColor];
    _weightResetBtn.frame = BOTTOM_RECT;
    PREPCONSTRAINTS(_weightResetBtn);
    ALIGN_VIEW_LEFT_CONSTANT(_weightResetBtn.superview,_weightResetBtn, 10);
    ALIGN_VIEW_RIGHT_CONSTANT(_weightResetBtn.superview, _weightResetBtn, -10);
    ALIGN_VIEW_BOTTOM_CONSTANT(self.view, _weightResetBtn, -20);
    
    
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

#pragma mark - sofa control part
/**
 *  When we clicked the button to reset weight, we send a message to sensor for resetting
 *
 *  @param sender :button
 */
- (IBAction)resetWeightDown:(id)sender
{
    [_weightResetBtn setTitle:@"清零中..." forState:UIControlStateNormal];
    [_globalSocket addObserver:self forKeyPath:@"weight" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self startSendMessageTimer];
    //After 3s, stop sending message
//    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(stopSendMessgeTimer) userInfo:nil repeats:NO ];
}

/**
 *  This method is to send a message to sensors to acquire data.
 */
-(void)sendMEssageToResetWeight
{
    [_globalSocket sendMessageDown:@"F1F10300037E"];
}

/**
 *  Set the timer for the message sender.
 Per 500ms we will send a message.
 */
-(void)startSendMessageTimer
{
    getMessageTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(sendMEssageToResetWeight) userInfo:nil repeats:YES ];
    
}

/**
 *  Stop the timer 500ms and stop sending the message.
 */
-(void)stopSendMessgeTimer
{
    if (getMessageTimer != nil)
    {
        [getMessageTimer invalidate];
    }
    [_globalSocket sendMessageDown:@"F1F101020000037E"];//松手检测
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"weight"]) {
        if ([_globalSocket.weight intValue] == 0) {
            [_weightResetBtn setTitle:@"清零成功" forState:UIControlStateNormal];
            [_globalSocket removeObserver:self forKeyPath:@"weight"];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(resetBtnTitle) userInfo:nil repeats:NO ];
            [self stopSendMessgeTimer];
        }
        
    }
}

-(void)resetBtnTitle
{
    [_weightResetBtn setTitle:@"清零" forState:UIControlStateNormal];
}

@end
