//
//  HeightPickerView.m
//  iSmartHome
//
//  Created by admin on 15/12/8.
//  Copyright © 2015年 zzmax. All rights reserved.
//

#import "HeightPickerView.h"
#import "ConstraintMacros.h"

@interface HeightPickerView()


@end

@implementation HeightPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    self.heightPickerArray = [[NSMutableArray alloc] init];
    for (int weight = 150; weight<=200; weight++) {
        NSString *weightString = [NSString stringWithFormat:@"%d%",weight];
        [self.heightPickerArray addObject:weightString];
    }
    
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    // two columns(one for number, one for unit)
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.heightPickerArray.count;
    }
    else return 1; // arbitrary and large
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 120.0f;
}


-(void)heightpickerView:(UIPickerView*)heightPickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    self.height = [self.heightPickerArray objectAtIndex:row];
//    if (component == 0) {
//        return  [self.heightPickerArray objectAtIndex:row];
//    }
//    else return @"Kg";
}


#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    self.height = [self.heightPickerArray objectAtIndex:row];
//    if (component == 0) {
//        return  [self.heightPickerArray objectAtIndex:row];
//    }
//    else return @"Kg";
}


@end
