//
//  SingleCorePlotViewController.h
//  iSmartHome
//
//  Created by admin on 16/2/23.
//  Copyright © 2016年 zzmax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "CPDStockPriceStore.h"
#import "CPDConstants.h"
#import "ConstraintMacros.h"

@interface SingleCorePlotViewController : UIViewController<CPTPlotDataSource, UIActionSheetDelegate>
-(void)initWithFrame:(CGRect)frame andTitle:(NSString *)title;
@property (nonatomic) CPTGraphHostingView *hostView;
@property (nonatomic) NSUInteger dateCount;

@end
