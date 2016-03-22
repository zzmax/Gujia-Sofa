//
//  SofaControlViewController.m
//  iSmartHome
//
//  Created by admin on 15/12/15.
//  Copyright © 2015年 zzmax. All rights reserved.
//
//  This view is to control the height of the sofa.

#import "SofaControlViewController.h"
#import "GCDAsyncSocket.h"
#import "ConstraintMacros.h"
#import "Utility.h"
#import "GlobalSocket.h"


@interface SofaControlViewController()
{
    UInt8 inputBuffer[INPUTBUFFERSIZE];
    int   sendDataLength;
}
@property Utility *utility;
@property GlobalSocket *globalSocket;


//@property NSTimeInterval socketTimeOut;
//@property (strong, nonatomic) NSTimer *sendMessageTimer;


@property (nonatomic, retain) IBOutlet UIView *sofaControlView;
@property (weak, nonatomic) IBOutlet UIButton *liftBtn;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UIImageView  *backgroundImg;
@property (weak, nonatomic) IBOutlet UIImageView  *sofaImg;
@property (weak, nonatomic) IBOutlet UIImageView  *bigBlueCircleImg;
@end


@implementation SofaControlViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Initiate the utility object
    _utility = [[Utility alloc] init];
    [self.utility activeDismissableKeyboard:self];
    
    // set title
    self.navigationItem.title = @"沙发控制";
    
    [[NSBundle mainBundle] loadNibNamed:@"SofaControlView" owner:self options:nil];
    self.sofaControlView.backgroundColor = BACKGROUND_COLOR;
    
    CGFloat widthScale = (SCREEN_WIDTH * 0.7 ) / _bigBlueCircleImg.frame.size.width;
    CGFloat heightScale = (SCREEN_WIDTH * 0.7 ) / _bigBlueCircleImg.frame.size.height;
    PREPCONSTRAINTS(_bigBlueCircleImg);
    _bigBlueCircleImg.transform = CGAffineTransformMakeScale(widthScale, heightScale);

    //Change the size of images if the screen is small
    if (!IS_IPHONE_PLUS && !IS_IPHONE_6)
    {
        widthScale = 80 / _liftBtn.frame.size.width;
        heightScale = 80 / _liftBtn.frame.size.height;
        _liftBtn.transform = CGAffineTransformMakeScale(widthScale, heightScale);
        _downBtn.transform = CGAffineTransformMakeScale(widthScale, heightScale);
    }
    
    PREPCONSTRAINTS(_liftBtn);
    if (IS_IPHONE_PLUS || IS_IPHONE_6)
    {
        ALIGN_VIEW1_TOP_TO_VIEW2_TOP_CONSTANT(self.sofaControlView, self.bigBlueCircleImg, self.liftBtn, SCREEN_HEIGHT/9);
    }
    else    ALIGN_VIEW1_TOP_TO_VIEW2_TOP_CONSTANT(self.sofaControlView, self.bigBlueCircleImg, self.liftBtn, SCREEN_HEIGHT/13);
    CENTER_VIEW_H(self.sofaControlView, self.liftBtn);
    
    PREPCONSTRAINTS(_downBtn);
    if (IS_IPHONE_PLUS || IS_IPHONE_6)
    {
        ALIGN_VIEW1_BOTTOM_TO_VIEW2_BOTTOM_CONSTANT(self.sofaControlView, self.downBtn, self.bigBlueCircleImg, SCREEN_HEIGHT/9);
    }
   else    ALIGN_VIEW1_BOTTOM_TO_VIEW2_BOTTOM_CONSTANT(self.sofaControlView, self.downBtn, self.bigBlueCircleImg, SCREEN_HEIGHT/13);
    CENTER_VIEW_H(self.sofaControlView, self.downBtn);

    _globalSocket = [GlobalSocket sharedGlobalSocket];
    [self initControlMessage];
    
}

#pragma mark - sofa control part
/**
 *  This method is to intiate the message array that we will send to control part
 */
-(void)initControlMessage
{
    sendDataLength=8;
    inputBuffer[0]=0x21;    //message ID
    inputBuffer[1]=0x02;    //?
    inputBuffer[2]=0x03;    //?
    inputBuffer[3]=0x01;    //data that control the sofa
    inputBuffer[4]=0x00;
    inputBuffer[5]=0x00;
    inputBuffer[6]=0x0d;
    inputBuffer[7]=0x0a;
}

/**
 *  Button to control sofa go up is down.
 *
 *  @param sender : upBtn.
 */
- (IBAction)s1Down:(id)sender
{
    _globalSocket.btnS1 = YES;
    [_globalSocket startSendMessageTimer];
}

/**
 *  Button to control sofa go up is up.
 *
 *  @param sender : upBtn.
 */
- (IBAction)s1Up:(id)sender
{
    _globalSocket.btnS1 = false;
    [_globalSocket stopSendMessgeTimer];
    
    [_globalSocket initControlMessage];
    [_globalSocket sendMessageDown:inputBuffer length:sendDataLength];
}

/**
 *  Button to control sofa go down is down.
 *
 *  @param sender : downBtn.
 */
- (IBAction)s2Down:(id)sender
{
    _globalSocket.btnS2 = true;
    [_globalSocket startSendMessageTimer];
}

/**
 *  Button to control sofa go down is up.
 *
 *  @param sender : downBtn.
 */
- (IBAction)s2Up:(id)sender
{
    _globalSocket.btnS2 = false;
    [_globalSocket stopSendMessgeTimer];
    
    [_globalSocket initControlMessage];
    [_globalSocket sendMessageDown:inputBuffer length:sendDataLength];
}

#pragma mark - Screen set
/**
 *  cancel the first responder of the keyborad until we active next textField
 *
 *  @param textField
 *
 *  @return
 */- (BOOL)textFieldShouldReturn: (UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
