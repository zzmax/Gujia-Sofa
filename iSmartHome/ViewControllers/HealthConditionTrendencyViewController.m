//
//  HealthConditionTrendencyViewController.m
//  iSmartHome
//
//  Created by admin on 16/1/13.
//  Copyright © 2016年 zzmax. All rights reserved.
//
//  This view shows the health condition trendency by graph in a single page.

#import "HealthConditionTrendencyViewController.h"
#import "CorePlot-CocoaTouch.h"
#import "CPDStockPriceStore.h"
#import "CPDConstants.h"
#import "ConstraintMacros.h"
#import "SingleCorePlotViewController.h"

@interface HealthConditionTrendencyViewController ()
//@property (nonatomic, strong) SingleCorePlotViewController *curHostView;
@property (nonatomic, strong) SingleCorePlotViewController *hostVC;
@property (nonatomic, strong) SingleCorePlotViewController *hostVC2;

@property (weak, nonatomic) IBOutlet UIButton *weekBtn;
@property (weak, nonatomic) IBOutlet UIButton *monthBtn;
@property (weak, nonatomic) IBOutlet UIButton *yearBtn;
//These views contain the charts seperately
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;

@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

-(void)initPlot;

@end

@implementation HealthConditionTrendencyViewController

//@synthesize curHostView = curHostView_;
@synthesize hostVC = hostVC_;
@synthesize hostVC2 = hostVC2_;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    // set title
    self.navigationItem.title = @"健康结果趋势";
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.firstView.backgroundColor = BACKGROUND_COLOR;
    self.secondView.backgroundColor = BACKGROUND_COLOR;
    
    // Init Page Control
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = 3;
    [self.pageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pageControl];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // The plot is initialized here, since the view bounds have not transformed for landscape until now
    [self initHostViewController];
    [self initPlot];
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

#pragma mark - Chart behavior
-(void)initPlot {
    //make graph clear
    [self.hostVC2.view removeFromSuperview];
    [self.hostVC.view removeFromSuperview];
    
    CGRect parentRect = self.view.bounds;
//    CGSize navibarSize = self.navigationController.navigationBar.bounds.size;
    // 1 - Set up view frame
    parentRect = CGRectMake(parentRect.origin.x,
                            parentRect.origin.y,//+ navibarSize.height + 80
                            parentRect.size.width,
                            (parentRect.size.height / 3));
    
    if (self.pageControl.currentPage == 0) {
        // 2 - Create host view
        [self.hostVC initWithFrame:parentRect andTitle:@"血压值分布"];
        [self.hostVC2 initWithFrame:parentRect andTitle:@"心率分布"];

    }
    else if (self.pageControl.currentPage == 1)
    {
        // 2 - Create host view
        [self.hostVC initWithFrame:parentRect andTitle:@"血氧分布"];
        [self.hostVC2 initWithFrame:parentRect andTitle:@"体温分布"];
    }
    else
    {
        // 2 - Create host view
        [self.hostVC initWithFrame:parentRect andTitle:@"体重分布"];
    }
    
    [self.firstView addSubview:self.hostVC.view];
    self.hostVC.view.tag = 101;
    
    if (self.pageControl.currentPage != 2) {
        self.hostVC2.view.tag = 102;
        [self.secondView addSubview:self.hostVC2.view];
    }
    
     [self.view clipsToBounds];
}

-(void) initHostViewController
{
    self.hostVC = [(SingleCorePlotViewController *)[SingleCorePlotViewController alloc] init];
    self.hostVC2 = [(SingleCorePlotViewController *) [SingleCorePlotViewController alloc] init];
}

#pragma mark - change the number of plot to show
/**
 *  When we clicked the button to
 *
 *  @param sender :weekButton
 */
- (IBAction)setXAxisToWeek:(id)sender
{
    self.hostVC.dateCount = [[[CPDStockPriceStore sharedInstance] datesInWeek] count];
    self.hostVC2.dateCount = [[[CPDStockPriceStore sharedInstance] datesInWeek] count];
    [self initPlot];
    [self.weekBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.monthBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.yearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)setXAxisToMonth:(id)sender
{
    self.hostVC.dateCount = [[[CPDStockPriceStore sharedInstance] datesInMonth] count];
    self.hostVC2.dateCount = [[[CPDStockPriceStore sharedInstance] datesInMonth] count];
    [self initPlot];
    [self.weekBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.monthBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.yearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)setXAxisToYear:(id)sender
{
    self.hostVC.dateCount = [[[CPDStockPriceStore sharedInstance] datesInMonth] count];
    self.hostVC2.dateCount = [[[CPDStockPriceStore sharedInstance] datesInMonth] count];
    [self initPlot];
    [self.weekBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.monthBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.yearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

# pragma mark - paging
- (IBAction)pageChange:(id)sender {
    [self.pageControl  setCurrentPage:((UIPageControl *)sender).currentPage];
    [self initPlot];
//    NSLog(@"%li", (long)self.pageControl.currentPage);
}


@end
