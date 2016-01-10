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
#import "AppDelegate.h"


@interface UserInfoRegisterViewController()

@property (strong, nonatomic)NSArray *infoTitles;
@property (strong, nonatomic)UITextField *birthdayTF;
@property (strong, nonatomic)UITextField *heightTF;
@property (strong, nonatomic)UITextField *weightTF;
@property (strong, nonatomic)NSMutableArray *heightPickerArray;
@property (strong, nonatomic)NSMutableArray *weightPickerArray;

@property (strong, nonatomic) NSNumber *sex;//variable for data

@property (weak, nonatomic) IBOutlet UIButton *startBtn;
- (IBAction)popView:(id)sender;

@end

@implementation UserInfoRegisterViewController {
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = NAVIGATION_COLOR;
    self.tableView.backgroundColor = NAVIGATION_COLOR;
     self.tableView.scrollEnabled = NO;
    //initiate table data
    _infoTitles = [NSArray arrayWithObjects:@"",@"性别", @"生日", @"身高", @"体重",nil];
    
    _startBtn.frame = BOTTOM_RECT;
    PREPCONSTRAINTS(_startBtn);
    ALIGN_VIEW_LEFT_CONSTANT(_startBtn.superview,_startBtn, 10);
    ALIGN_VIEW_RIGHT_CONSTANT(_startBtn.superview, _startBtn, -10);
    ALIGN_VIEW_BOTTOM_CONSTANT(self.view, _startBtn, -40);
    [_startBtn setTitle:@"开始使用" forState:UIControlStateNormal];
    _startBtn.titleLabel.textColor = [UIColor blackColor];
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
       
        if (indexPath.row == 0) {
            [cell.contentView addSubview: [[UILabel alloc] initWithFrame:CGRectZero]];
        }
        //sex select line in table view
        if (indexPath.row == 1)
        {
            // set the sex (male, female)
            UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"男性",@"女性"]];
            segmentedControl.frame = CGRectMake(150, 7, 200, 28);
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
        else if (indexPath.row == 2)
        {
            
            UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
            datePicker.datePickerMode = UIDatePickerModeDate;
            [datePicker setDate:[NSDate date]];
            [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
            
            //set textField for birthday
            _birthdayTF = [[UITextField alloc] init];
            _birthdayTF.frame = CGRectMake(220, 7, 130, 28);
            _birthdayTF.inputView = datePicker;
            _birthdayTF.inputAccessoryView = pickerToolbar;
            _birthdayTF.textColor = [UIColor whiteColor];
            _birthdayTF.textAlignment = UITextAlignmentRight;
            [self updateTextField:(id)_birthdayTF];
            [cell.contentView addSubview:_birthdayTF];
        }
        //height line
        else if(indexPath.row == 3)
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
            _heightTF.frame = CGRectMake(265, 7, 80, 28);
            _heightTF.inputView = heightPicker;
            _heightTF.inputAccessoryView = pickerToolbar;
            _heightTF.textColor = [UIColor whiteColor];
            _heightTF.textAlignment = UITextAlignmentRight;
            [self pickerView:heightPicker didSelectRow:20 inComponent:0];
            //Set the default value to 170cm
            [heightPicker selectRow:20 inComponent:0 animated:YES];
            [cell.contentView addSubview:_heightTF];
        }
        //weight line
        else if(indexPath.row == 4)
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
            _weightTF.frame = CGRectMake(265, 7, 80, 28);
            _weightTF.inputView = weightPicker;
            _weightTF.inputAccessoryView = pickerToolbar;
            _weightTF.textColor = [UIColor whiteColor];
            _weightTF.textAlignment = UITextAlignmentRight;
            [self pickerView:_weightTF didSelectRow:20 inComponent:0];
            //Set the default value to 60kg
            [weightPicker selectRow:20 inComponent:0 animated:YES];
            [cell.contentView addSubview:_weightTF];
            
        }
    }
    
    // either if the cell could be dequeued or you created a new cell,
    // segmentedControl will contain a valid instance
    UISegmentedControl *segmentedControl = (UISegmentedControl *)[cell.contentView viewWithTag:42];
    segmentedControl.selectedSegmentIndex = 0;
    cell.textLabel.text = [_infoTitles objectAtIndex: indexPath.row];
    cell.backgroundColor = NAVIGATION_COLOR;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.clipsToBounds = YES;
    //disable cell selected effect
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_infoTitles count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 120.0f;
    }
    return 44.0f;
}

//set the inset of the separator to zero
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - actionDetect
//detect action of the sex change
- (IBAction)didChangeSegmentedControl:(UISegmentedControl *)sender
{
    // transform the origin of the cell to the frame of the tableView
    CGPoint senderOriginInTableView = [self.tableView convertPoint:CGPointZero fromView:sender];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:senderOriginInTableView];
    NSAssert(indexPath, @"must have a valid indexPath");
    //if changed, we change the value of sex
//    if(sender.state == )
//    {
//        _sex = NSnumb;
//    }
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

#pragma mark - save data 
- (void)registerLandingAccount:(UIButton *)sender
{
    NSError __autoreleasing *error;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
//    appDelegate.registerUser.username = self.userName.text;
    
//    if (self.code1.text ==  self.code2.text)
//    {
//        appDelegate.registerUser.password = self.code1.text;
//    }
    
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    
    User *newUser = (User *)newManagedObject;
    newUser.name = appDelegate.registerUser.name;
    newUser.password = appDelegate.registerUser.password ;
    newUser.sex =appDelegate.registerUser.sex ;
//    newUser.birthday =appDelegate.registerUser.birthday ;
    newUser.birthday = (NSString *)_birthdayTF.text;
    newUser.height = _heightTF.text;
    newUser.weight = _weightTF.text;
//    newUser.height = appDelegate.registerUser.height;
//    newUser.weight = appDelegate.registerUser.weight ;
//    newUser.username = appDelegate.registerUser.username ;
    
    BOOL success;
    
    if (!(success = [context save:&error]))
    {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        abort();
    }
}

//NSString *name;
//@property (nullable, nonatomic, retain) NSString *password;
//@property (nullable, nonatomic, retain) NSNumber *sex;
//@property (nullable, nonatomic, retain) NSDate *birthday;
//@property (nullable, nonatomic, retain) NSNumber *height;
//@property (nullable, nonatomic, retain) NSNumber *weight;
//@property (nullable, nonatomic, retain) NSString *username;


@end