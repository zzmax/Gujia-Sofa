//
//  SofaHeatViewController.m
//  iSmartHome
//
//  Created by admin on 15/12/17.
//  Copyright © 2015年 zzmax. All rights reserved.
//
//  This view is to control the temperature of the sofa.

#import "SofaHeatViewController.h"
#import "ConstraintMacros.h"
#import "GlobalSocket.h"

@interface SofaHeatViewController ()
{
    int   sendDataLength;
    bool  isElectricalBlanketOn;
    NSTimer *getMessageTimer;
    NSMutableArray *sofaHeatImgs;
    UIImage *image;
}

@property (nonatomic, retain) IBOutlet UIView *sofaHeatView;
@property (weak, nonatomic) IBOutlet UILabel  *tempLbl;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopHeatBtn;
@property (weak, nonatomic) IBOutlet UIImageView  *backgroundImg;
@property (weak, nonatomic) IBOutlet UIImageView  *sofaHeatImg;
@property (weak, nonatomic) IBOutlet UIImageView  *bigBlueCircleImg;

@property GlobalSocket *globalSocket;
@end

@implementation SofaHeatViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // set title
    self.navigationItem.title = @"座椅加热";
    self.view.backgroundColor = BACKGROUND_COLOR;
    [[_stopHeatBtn layer] setBorderWidth: 0];
    [[_stopHeatBtn layer] setBorderColor: BACKGROUND_COLOR.CGColor];
    _stopHeatBtn.frame = BOTTOM_RECT;
    PREPCONSTRAINTS(_stopHeatBtn);
    ALIGN_VIEW_LEFT_CONSTANT(_stopHeatBtn.superview,_stopHeatBtn, 10);
    ALIGN_VIEW_RIGHT_CONSTANT(_stopHeatBtn.superview, _stopHeatBtn, -10);
    ALIGN_VIEW_BOTTOM_CONSTANT(self.sofaHeatView, _stopHeatBtn, -20);
//
    
    CGFloat widthScale = SCREEN_WIDTH/_backgroundImg.frame.size.width;
    CGFloat heightScale = (SCREEN_HEIGHT * 0.9) / _backgroundImg.frame.size.height;
    _backgroundImg.transform = CGAffineTransformMakeScale(widthScale, heightScale);
    PREPCONSTRAINTS(_backgroundImg);
    CENTER_VIEW(self.sofaHeatView, self.backgroundImg);
    
    PREPCONSTRAINTS(_bigBlueCircleImg);
    CENTER_VIEW(self.sofaHeatView, self.bigBlueCircleImg);
    widthScale = (SCREEN_WIDTH * 0.7 )/_bigBlueCircleImg.frame.size.width;
    heightScale = (SCREEN_WIDTH * 0.7 ) / _bigBlueCircleImg.frame.size.height;
    _bigBlueCircleImg.transform = CGAffineTransformMakeScale(widthScale, heightScale);
//    PREPCONSTRAINTS(_sofaHeatImg);
//    ALIGN_VIEW_TOP_CONSTANT(self.sofaHeatView, self.sofaHeatImg, SCREEN_HEIGHT * 0.48f);
//    CENTER_VIEW_H(self.sofaHeatView, self.sofaHeatImg);
    
//    PREPCONSTRAINTS(_plusBtn);
//    CONSTRAIN_SIZE(_plusBtn, 80, 80);
//    ALIGN_VIEW_TOP_CONSTANT(self.sofaHeatView, self.plusBtn, SCREEN_HEIGHT * 0.18f);
//    CENTER_VIEW_H(self.sofaHeatView, self.plusBtn);
//    
//    PREPCONSTRAINTS(_minusBtn);
//    CONSTRAIN_SIZE(_minusBtn, 80, 80);
//    ALIGN_VIEW_TOP_CONSTANT(self.sofaHeatView, self.minusBtn, SCREEN_HEIGHT * 0.68f);
//    CENTER_VIEW_H(self.sofaHeatView, self.minusBtn);
    
    _globalSocket = [GlobalSocket sharedGlobalSocket];
    [self initControlMessage];
    [_stopHeatBtn setTitle:@"打开座椅加热" forState:UIControlStateNormal];
    isElectricalBlanketOn = NO;
    
    sofaHeatImgs = [[NSMutableArray alloc]initWithCapacity:3];
    [sofaHeatImgs addObject:@"icon_temp_signal_1"];
    [sofaHeatImgs addObject:@"icon_temp_signal_2"];
    [sofaHeatImgs addObject:@"icon_temp_signal_3"];
    image = [UIImage imageNamed: sofaHeatImgs[0]];
    widthScale = 100/image.size.width;
    heightScale = 100/image.size.height;
    _sofaHeatImg.image = image;
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
 *  This method is to intiate the message array that we will send to control part
 */
-(void)initControlMessage
{
    sendDataLength = 8;
}

/**
 *  Turn on the electrical blanket if it is off,
    or turn off the blanket if it is on.
 *
 *  @param sender
 */
- (IBAction)s3ORs4Down:(id)sender
{
    if (!isElectricalBlanketOn) {
        [_globalSocket initControlMessage];
        //    inputBuffer[4]=0x04;
        [_globalSocket setInputBuffer:4 and:0x04];
        [_globalSocket sendMessageDown:[_globalSocket getInputBuffer] length:sendDataLength];
        isElectricalBlanketOn = YES;
        [_stopHeatBtn setTitle:@"关闭座椅加热" forState:UIControlStateNormal];
        [self startGetTempMessageTimer];
    }
    else
    {
        [_globalSocket initControlMessage];
        //    inputBuffer[4]=0x08;
        [_globalSocket setInputBuffer:4 and:0x08];
        [_globalSocket sendMessageDown:[_globalSocket getInputBuffer] length:sendDataLength];
        isElectricalBlanketOn = NO;
        [_stopHeatBtn setTitle:@"打开座椅加热" forState:UIControlStateNormal];
        [self stopGetTempMessageTimer];
    }
}

- (IBAction)s3ORs4Up:(id)sender
{
    [_globalSocket initControlMessage];
    [_globalSocket sendMessageDown:[_globalSocket getInputBuffer] length:sendDataLength];
}


- (IBAction)s5Down:(id)sender
{
    [_globalSocket initControlMessage];
//    inputBuffer[4]=0x10;
    [_globalSocket setInputBuffer:4 and:0x10];
    [_globalSocket sendMessageDown:[_globalSocket getInputBuffer] length:sendDataLength];
}

- (IBAction)s5Up:(id)sender
{
    [_globalSocket initControlMessage];
    [_globalSocket sendMessageDown:[_globalSocket getInputBuffer] length:sendDataLength];
}

- (IBAction)s6Down:(id)sender
{
    [_globalSocket initControlMessage];
//    inputBuffer[4]=0x20;
    [_globalSocket setInputBuffer:4 and:0x20];
    [_globalSocket sendMessageDown:[_globalSocket getInputBuffer] length:sendDataLength];
}

- (IBAction)s6Up:(id)sender
{
    [_globalSocket initControlMessage];
    [_globalSocket sendMessageDown:[_globalSocket getInputBuffer] length:sendDataLength];
}

/**
 *  Set the timer for the message sender.
 Per 400ms we will send a message.
 */
-(void)startGetTempMessageTimer
{
    getMessageTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setTempLbl) userInfo:nil repeats:YES ];
    
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

-(void) setTempLbl
{
    CGFloat widthScale = 100/image.size.width;
    CGFloat heightScale = 100/image.size.height;
    [_tempLbl setText:_globalSocket.sofaTemp[0]];
    //identify the gear of blanket: 1, 2 or 3 to change the image of the sofa
    if ([_globalSocket.sofaTemp[1] isEqualToString:@"1"]) {
        image = [UIImage imageNamed: sofaHeatImgs[0]];
        _sofaHeatImg.image = image;
        _sofaHeatImg.transform = CGAffineTransformMakeScale(widthScale, heightScale);
    }
    else if([_globalSocket.sofaTemp[1] isEqualToString:@"2"])
    {
        image = [UIImage imageNamed: sofaHeatImgs[1]];
        _sofaHeatImg.image = image;
        _sofaHeatImg.transform = CGAffineTransformMakeScale(widthScale, heightScale);
    }
    else{
        image = [UIImage imageNamed: sofaHeatImgs[2]];
        _sofaHeatImg.image = image;
        _sofaHeatImg.transform = CGAffineTransformMakeScale(widthScale, heightScale);
    }
}

@end
