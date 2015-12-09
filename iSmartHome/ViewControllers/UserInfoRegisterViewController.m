//
//  UserInfoRegisterViewController.m
//  iSmartHome
//
//  Created by admin on 15/12/1.
//  Copyright © 2015年 zzmax. All rights reserved.
//
//  This view is to complete the basic infos of the user

#import <Foundation/Foundation.h>
#import "UserInfoRegisterViewController.h"
#import "ConstraintMacros.h"
#import "CustomPickerView.h"


@interface UserInfoRegisterViewController()

@property (strong, nonatomic)UITextField *birthdayTF;
@property (strong, nonatomic)UITextField *heightTF;
@property (strong, nonatomic)UITextField *weightTF;
@property (strong, nonatomic)NSMutableArray *heightPickerArray;
@property (strong, nonatomic)NSMutableArray *weightPickerArray;
- (IBAction)popView:(id)sender;
@end

@implementation UserInfoRegisterViewController {
    NSArray *infoTitles;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = NAVIGATION_COLOR;
    self.tableView.backgroundColor = NAVIGATION_COLOR;
    //initiate table data
    infoTitles = [NSArray arrayWithObjects:@"性别", @"生日", @"身高", @"体重",nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)popView:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"InfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
        //set tool bar to dismiss datepicker
        UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        pickerToolbar.barStyle = UIBarStyleBlackOpaque;
        [pickerToolbar sizeToFit];
        
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        
        UIBarButtonItem *flexSpace = SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace,nil);
        [barItems addObject:flexSpace];
        
        UIBarButtonItem *doneBtn = SYSBARBUTTON(UIBarButtonSystemItemDone, @selector(doneButtonPressed:));
        [barItems addObject:doneBtn];
        [pickerToolbar setItems:barItems animated:YES];
       
        //sex select line in table view
        if (indexPath.row == 0)
        {
            // set the sex (male, female)
            UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"男性",@"女性"]];
            segmentedControl.frame = CGRectMake(130, 7, 200, 28);
            [cell.contentView addSubview:segmentedControl];
            
            // add an action so we can change our model if the view changes
            [segmentedControl addTarget:self action:@selector(didChangeSegmentedControl:) forControlEvents:UIControlEventValueChanged];
            
            // use a tag so we can retrieve the segmentedControl later
            segmentedControl.tag = 42;
            [[UISegmentedControl appearance] setTitleTextAttributes:[
                                                                     NSDictionary dictionaryWithObjectsAndKeys:
                                                                                [UIColor blackColor],NSForegroundColorAttributeName,
                                                                                nil                                                                   ]
                                            forState: UIControlStateNormal];
            
            [[UISegmentedControl appearance] setTitleTextAttributes:[
                                                                     NSDictionary dictionaryWithObjectsAndKeys:
                                                                                     [UIColor blackColor],
                                                                                      NSForegroundColorAttributeName,
                                                                                     nil
                                                                     ]
                                            forState: UIControlStateSelected];
            
          [UISegmentedControl appearance].backgroundColor = [UIColor colorWithRed:0.85882f green:0.85882f blue:0.85882f alpha:0.5f];//set backgroundcolor to lightgray color

        }
        //birthday choose line
        else if (indexPath.row == 1)
        {
            
            UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
            datePicker.datePickerMode = UIDatePickerModeDate;
            [datePicker setDate:[NSDate date]];
            [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
            
            //set textField for birthday
            _birthdayTF = [[UITextField alloc] init];
            _birthdayTF.frame = CGRectMake(210, 7, 130, 28);
            _birthdayTF.inputView = datePicker;
            _birthdayTF.inputAccessoryView = pickerToolbar;
            _birthdayTF.textColor = [UIColor whiteColor];
            [self updateTextField:(id)_birthdayTF];
            [cell.contentView addSubview:_birthdayTF];
        }
        //height line
        else if(indexPath.row == 2)
        {
            UIPickerView *heightPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
            _heightPickerArray = [[NSMutableArray alloc] init];
            
            for (int height = 150; height<=200; height++) {
                NSString *heightString = [NSString stringWithFormat:@"%d%",height];
                [_heightPickerArray addObject:heightString];
            }
            
            heightPicker.delegate = self;
            heightPicker.dataSource = self;
            heightPicker.showsSelectionIndicator = YES;
            heightPicker.tag = 100;
            
            //set textField for height
            _heightTF = [[UITextField alloc] init];
            _heightTF.frame = CGRectMake(275, 7, 80, 28);
            _heightTF.inputView = heightPicker;
            _heightTF.inputAccessoryView = pickerToolbar;
            _heightTF.textColor = [UIColor whiteColor];
            [self pickerView:heightPicker didSelectRow:20 inComponent:0];
            //Set the default value to 170cm
            [heightPicker selectRow:20 inComponent:0 animated:YES];
            [cell.contentView addSubview:_heightTF];
        }
        //weight line
        else if(indexPath.row == 3)
        {
            UIPickerView *weightPicker = [[UIPickerView alloc] init];
            _weightPickerArray = [[NSMutableArray alloc] init];
            
            for (int weight = 40; weight <= 140; weight++) {
                NSString *weightString = [NSString stringWithFormat:@"%d%", weight];
                [_weightPickerArray addObject:weightString];
            }
            weightPicker.delegate = self;
            weightPicker.dataSource = self;
            weightPicker.showsSelectionIndicator = YES;
            weightPicker.tag = 101;
            
            //set textField for _weightTF
            _weightTF = [[UITextField alloc] init];
            _weightTF.frame = CGRectMake(275, 7, 80, 28);
            _weightTF.inputView = weightPicker;
            _weightTF.inputAccessoryView = pickerToolbar;
            _weightTF.textColor = [UIColor whiteColor];
            [self pickerView:_weightTF didSelectRow:20 inComponent:0];
            //Set the default value to 60kg
            [weightPicker selectRow:20 inComponent:0 animated:YES];
            [cell.contentView addSubview:_weightTF];
            
        }
    }
    

    // either if the cell could be dequeued or you created a new cell,
    // segmentedControl will contain a valid instance
    UISegmentedControl *segmentedControl = (UISegmentedControl *)[cell.contentView viewWithTag:42];
    segmentedControl.selectedSegmentIndex = indexPath.row;
    cell.textLabel.text = [infoTitles objectAtIndex:indexPath.row];
    cell.backgroundColor = NAVIGATION_COLOR;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.clipsToBounds = YES;
    //disable cell selected effect
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [infoTitles count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

#pragma mark - actionDetect
//detect action of the sex change
- (IBAction)didChangeSegmentedControl:(UISegmentedControl *)sender
{
    // transform the origin of the cell to the frame of the tableView
    CGPoint senderOriginInTableView = [self.tableView convertPoint:CGPointZero fromView:sender];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:senderOriginInTableView];
    NSAssert(indexPath, @"must have a valid indexPath");
    NSLog(@"test");
}

#pragma mark - datePicker
-(void)updateTextField:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    self.birthdayTF.text = [dateFormatter stringFromDate:[(UIDatePicker*)self.birthdayTF.inputView date]];
}

-(void)doneButtonPressed:(id)sender
{
    [self.birthdayTF resignFirstResponder];
    [self.heightTF resignFirstResponder];
    [self.weightTF resignFirstResponder];
}

#pragma mark - heightPicker
#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 100) {
        return _heightPickerArray.count;
    }
    else return _weightPickerArray.count;
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 100) {
        [_heightTF setText: [NSString stringWithFormat:@"%@%@",[_heightPickerArray objectAtIndex:row],@" cm"]];
    }
    else
    {
        [_weightTF setText: [NSString stringWithFormat:@"%@%@",[_weightPickerArray objectAtIndex:row],@" kg"]];

    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow: (NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 100) {
        return [_heightPickerArray objectAtIndex:row];
    }
    else
    {
       return [_weightPickerArray objectAtIndex:row];
    }
}




@end