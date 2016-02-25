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


@interface ConfiguratingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
//The label to show which step we are : Configurate the sofa or search the device
@property (weak, nonatomic) IBOutlet UILabel *progressDescription;

@property (weak, nonatomic) IBOutlet UIView *progressBarContainer;
@property (nonatomic) CGFloat progress;
@property (nonatomic, strong) NSTimer *timer;
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
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.timer invalidate];
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
@end
