//
//  SingleCorePlotViewController.m
//  iSmartHome
//
//  Created by admin on 16/2/23.
//  Copyright © 2016年 zzmax. All rights reserved.
//

#import "SingleCorePlotViewController.h"

@interface SingleCorePlotViewController ()

@end

@implementation SingleCorePlotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     //initiate the number of plot to a month
    if (!self.dateCount) {
        self.dateCount = [[[CPDStockPriceStore sharedInstance] datesInMonth] count];
    }

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
}*/

#pragma mark - Chart behavior
- (void)initWithFrame:(CGRect)frame andTitle:(NSString *)title{
//    self = [super initWithFrame:frame];
    [self configureHostWith:frame];
    [self configureGraph:title];
    [self configurePlots];
    [self configureAxes];
//    return self;
}

-(void)configureHostWith:(CGRect)aParentSize
{
    // 1 - Set up view frame
    CGRect parentRect = aParentSize;
    // 2 - Create host view
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:parentRect];
    self.hostView.allowPinchScaling = NO;
    [self.view addSubview:self.hostView];
    [self.view clipsToBounds];
}

-(void)configureGraph :(NSString *)title{
    // 1 - Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTSlateTheme];
    [graph applyTheme:theme];
    
    graph.plotAreaFrame.borderLineStyle = nil;
    
    graph.fill = [CPTFill fillWithColor:[CPTColor appBackGroundColor]];
    graph.plotAreaFrame.fill = [CPTFill fillWithImage:[CPTImage imageNamed:@"chart_background"]];
    self.hostView.hostedGraph = graph;
    
    
    
    // 2 - Set graph title
    graph.title = title;
    if ([graph.title isEqualToString:@"血压值分布"]) {
        self.hostView.tag = 101;
    }
    else if ([graph.title isEqualToString:@"心率分布"]) {
        self.hostView.tag = 102;
    }
    else if ([graph.title isEqualToString:@"血氧分布"]) {
        self.hostView.tag = 102;
    }
    else if ([graph.title isEqualToString:@"体温分布"]) {
        self.hostView.tag = 101;
    }
    else if ([graph.title isEqualToString:@"体重分布"]) {
        self.hostView.tag = 102;
    }
    
    // 3 - Create and set text style
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor blackColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTopLeft;
    graph.titleDisplacement = CGPointMake(10.0f, -10.0f);
    // 4 - Set padding for plot area
    [graph.plotAreaFrame setPaddingLeft:5.0f];
    [graph.plotAreaFrame setPaddingTop:30.0f];
    [graph.plotAreaFrame setPaddingBottom:30.0f];
    // 5 - Enable user interactions for plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    
    [graph setPaddingBottom:5.0f];
}

-(void)configurePlots{
    
    // 1 - Get graph and plot space
    CPTGraph *graph = self.hostView.hostedGraph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    // 2 - Create the a plot
    if (self.hostView.tag == 101) {
        CPTScatterPlot *aaplPlot = [[CPTScatterPlot alloc] init];
        aaplPlot.dataSource = self;
        aaplPlot.identifier = CPDTickerSymbolAAPL;
        CPTColor *aaplColor = [CPTColor redColor];
        [graph addPlot:aaplPlot toPlotSpace:plotSpace];
        // 3 - Set up plot space
        [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:aaplPlot, nil]]; //, googPlot  msftPlot,
        CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
        [xRange expandRangeByFactor:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromCGFloat(1.1f)]];
        plotSpace.xRange = xRange;
        CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
        [yRange expandRangeByFactor:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromCGFloat(1.2f)]];
        plotSpace.yRange = yRange;
        // 4 - Create styles and symbols
        CPTMutableLineStyle *aaplLineStyle = [aaplPlot.dataLineStyle mutableCopy];
        aaplLineStyle.lineWidth = 2.5;
        aaplLineStyle.lineColor = aaplColor;
        aaplPlot.dataLineStyle = aaplLineStyle;
        CPTMutableLineStyle *aaplSymbolLineStyle = [CPTMutableLineStyle lineStyle];
        aaplSymbolLineStyle.lineColor = aaplColor;
        CPTPlotSymbol *aaplSymbol = [CPTPlotSymbol plotSymbol];
        aaplSymbol.fill = [CPTFill fillWithColor:aaplColor];
        aaplSymbol.lineStyle = aaplSymbolLineStyle;
        aaplSymbol.size = CGSizeMake(6.0f, 6.0f);
        aaplPlot.plotSymbol = aaplSymbol;
    }
    else if (self.hostView.tag == 102)
    {
        CPTScatterPlot *googPlot = [[CPTScatterPlot alloc] init];
        googPlot.dataSource = self;
        googPlot.identifier = CPDTickerSymbolGOOG;
        CPTColor *googColor = [CPTColor greenColor];
        [graph addPlot:googPlot toPlotSpace:plotSpace];
        [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:googPlot, nil]];
        CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
        [xRange expandRangeByFactor:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromCGFloat(1.1f)]];
        plotSpace.xRange = xRange;
        CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
        [yRange expandRangeByFactor:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromCGFloat(1.2f)]];
        plotSpace.yRange = yRange;
        
        CPTMutableLineStyle *googLineStyle = [googPlot.dataLineStyle mutableCopy];
        googLineStyle.lineWidth = 1.0;
        googLineStyle.lineColor = googColor;
        googPlot.dataLineStyle = googLineStyle;
        CPTMutableLineStyle *googSymbolLineStyle = [CPTMutableLineStyle lineStyle];
        googSymbolLineStyle.lineColor = googColor;
        CPTPlotSymbol *googSymbol = [CPTPlotSymbol plotSymbol];
        googSymbol.fill = [CPTFill fillWithColor:googColor];
        googSymbol.lineStyle = googSymbolLineStyle;
        googSymbol.size = CGSizeMake(6.0f, 6.0f);
        googPlot.plotSymbol = googSymbol;
    }
}

- (void) configureAxes
{
    // 1 - Create styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor blackColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0f;
    axisLineStyle.lineColor = [CPTColor blackColor];
    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
    axisTextStyle.color = [CPTColor blackColor];
    axisTextStyle.fontName = @"Helvetica-Bold";
    axisTextStyle.fontSize = 11.0f;
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor whiteColor];
    tickLineStyle.lineWidth = 1.0f;
    //    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    //    tickLineStyle.lineColor = [CPTColor blackColor];
    //    tickLineStyle.lineWidth = 1.0f;
    // 2 - Get axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
    // 3 - Configure x-axis
    CPTAxis *x = axisSet.xAxis;
    //    x.title = @"Day of Month";
    //    x.titleTextStyle = axisTitleStyle;
    //    x.titleOffset = 15.0f;
    x.axisLineStyle = axisLineStyle;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.labelTextStyle = axisTextStyle;
    x.majorTickLineStyle = axisLineStyle;
    x.majorTickLength = 4.0f;
    x.tickDirection = CPTSignNegative;
    axisSet.xAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];//set offset of axis X to 0
    
    //    CGFloat dateCount = [[[CPDStockPriceStore sharedInstance] datesInWeek] count];
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:self.dateCount];
    NSMutableSet *xLocations = [NSMutableSet setWithCapacity:self.dateCount];
    NSInteger i = 0;
    
    NSArray *dates;
    if (self.dateCount == [[[CPDStockPriceStore sharedInstance] datesInWeek] count]) {
        dates = [[CPDStockPriceStore sharedInstance] datesInWeek];
    }
    else if (self.dateCount == [[[CPDStockPriceStore sharedInstance] datesInMonth] count])
    {
        dates = [[CPDStockPriceStore sharedInstance] datesInMonth];
    }
    
    for (NSString *date in dates) {
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:date  textStyle:x.labelTextStyle];
        CGFloat location = i++;
        label.tickLocation = [NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromCGFloat(location)];
        label.offset = x.majorTickLength;
        if (label) {
            [xLabels addObject:label];
            [xLocations addObject:[NSNumber numberWithFloat:location]];
        }
    }
    x.axisLabels = xLabels;
    x.majorTickLocations = xLocations;
    // 4 - Configure y-axis
    CPTAxis *y = axisSet.yAxis;
    //    y.title = @"Price";
    //    y.titleTextStyle = axisTitleStyle;
    //    y.titleOffset = -40.0f;
    y.axisLineStyle = axisLineStyle;
    //    y.majorGridLineStyle = gridLineStyle;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    y.labelTextStyle = axisTextStyle;
    y.labelOffset = 16.0f;
    y.majorTickLineStyle = axisLineStyle;
    y.majorTickLength = 4.0f;
    y.minorTickLength = 2.0f;
    y.tickDirection = CPTSignPositive;
    NSInteger majorIncrement = 100;
    NSInteger minorIncrement = 50;
    CGFloat yMax = 700.0f;  // should determine dynamically based on max price
    NSMutableSet *yLabels = [NSMutableSet set];
    NSMutableSet *yMajorLocations = [NSMutableSet set];
    NSMutableSet *yMinorLocations = [NSMutableSet set];
    for (NSInteger j = minorIncrement; j <= yMax; j += minorIncrement) {
        NSUInteger mod = j % majorIncrement;
        if (mod == 0) {
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%li", (long)j] textStyle:y.labelTextStyle];
            NSDecimal location = CPTDecimalFromInteger(j);
            label.tickLocation = [NSDecimalNumber decimalNumberWithDecimal:location];
            label.offset = -y.majorTickLength - y.labelOffset;
            if (label) {
                [yLabels addObject:label];
            }
            [yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
        } else {
            [yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
        }
    }
    y.axisLabels = yLabels;
    y.majorTickLocations = yMajorLocations;
    y.minorTickLocations = yMinorLocations;
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return self.dateCount;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    NSInteger valueCount = self.dateCount;
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            if (index < valueCount) {
                return [NSNumber numberWithUnsignedInteger:index];
            }
            break;
            
        case CPTScatterPlotFieldY:
            if ([plot.identifier isEqual:CPDTickerSymbolAAPL] == YES) {
                return [[[CPDStockPriceStore sharedInstance] monthlyPrices:CPDTickerSymbolAAPL] objectAtIndex:index];
            } else if ([plot.identifier isEqual:CPDTickerSymbolGOOG] == YES) {
                return [[[CPDStockPriceStore sharedInstance] monthlyPrices:CPDTickerSymbolGOOG] objectAtIndex:index];
            } else if ([plot.identifier isEqual:CPDTickerSymbolMSFT] == YES) {
                return [[[CPDStockPriceStore sharedInstance] monthlyPrices:CPDTickerSymbolMSFT] objectAtIndex:index];
            }
            break;
    }
    return [NSDecimalNumber zero];
}

@end
