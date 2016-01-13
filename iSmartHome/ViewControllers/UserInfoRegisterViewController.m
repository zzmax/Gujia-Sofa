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
#import "CoreDataHelper.h"
#import "CurrentUser.h"


@interface UserInfoRegisterViewController()
{
    CoreDataHelper *dataHelper;
}

@property (strong, nonatomic)NSArray *infoTitles;
@property (strong, nonatomic)UIImageView *userPhoto;
@property (strong, nonatomic)UITextField *userNameTF;
@property (strong, nonatomic)UITextField *birthdayTF;
@property (strong, nonatomic)UITextField *heightTF;
@property (strong, nonatomic)UITextField *weightTF;
@property (strong, nonatomic)NSMutableArray *heightPickerArray;
@property (strong, nonatomic)NSMutableArray *weightPickerArray;

@property (strong, nonatomic) NSNumber *sex;//variable for data

@property (weak, nonatomic) IBOutlet UIButton *startBtn;
- (IBAction)popView:(id)sender;

@property CurrentUser *currentUser;
@end

@implementation UserInfoRegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Establish Core Data
    dataHelper = [[CoreDataHelper alloc] init];
    dataHelper.entityName = @"User";
    dataHelper.defaultSortAttribute = @"userName";
    // Setup
    [dataHelper setupCoreData];
    
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
    
    _currentUser = [CurrentUser staticCurrentUser];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.userNameTF becomeFirstResponder];
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
       
        //set userName and it's photo
        if (indexPath.row == 0) {
             UIImage *image = [UIImage imageNamed: @"background_small_white_circle"];
            CGFloat widthScale = 90/image.size.width;
            CGFloat heightScale = 90/image.size.height;
            cell.imageView.image = image;
            //change the size of the imageview in cell to (90,90)
            cell.imageView.transform = CGAffineTransformMakeScale(widthScale, heightScale);
            //set textField for userName
            _userNameTF = [[UITextField alloc] init];
            _userNameTF.frame = CGRectMake(150, 35, 200, 50);
            _userNameTF.layer.cornerRadius = 5;
            _userNameTF.textAlignment = NSTextAlignmentLeft;
            _userNameTF.backgroundColor = BACKGROUND_COLOR;
            [_userNameTF setFont:[UIFont systemFontOfSize:20]];
            _userNameTF.delegate = self;
            _userNameTF.returnKeyType = UIReturnKeyDone;
            _userNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
            _userNameTF.placeholder = @"张三";
            [cell.contentView addSubview:_userNameTF];
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
            _birthdayTF.textAlignment = NSTextAlignmentRight;
            [self updateTextField:(id)_birthdayTF];
            [cell.contentView addSubview:_birthdayTF];
        }
        //height line
        else if(indexPath.row == 3)
        {
            UIPickerView *heightPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
            _heightPickerArray = [[NSMutableArray alloc] init];
            
            for (int height = 150; height<=200; height++) {
                NSString *heightString = [NSString stringWithFormat:@"%d",height];
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
            _heightTF.textAlignment = NSTextAlignmentRight;
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
                NSString *weightString = [NSString stringWithFormat:@"%d", weight];
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
            _weightTF.textAlignment = NSTextAlignmentRight;
            [self pickerView:weightPicker didSelectRow:20 inComponent:0];
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
    _sex = [NSNumber numberWithInteger:[sender selectedSegmentIndex]];
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
    if (self.birthdayTF.isFirstResponder) {
        [self.birthdayTF resignFirstResponder];
        [self.heightTF becomeFirstResponder];
    }
    else if (self.heightTF.isFirstResponder)
    {
        [self.heightTF resignFirstResponder];
        [self.weightTF becomeFirstResponder];
    }
    else
    {
        [self.weightTF resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
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
- (IBAction)addItem: (UIButton *)sender
{
    // Surround the "add" functionality with undo grouping
    User *newUser = (User *)[dataHelper newObject];
    NSUndoManager *manager = dataHelper.context.undoManager;
    [manager beginUndoGrouping];
    {
        [self setupNewUser:newUser];
    }
    [manager endUndoGrouping];
    [manager setActionName:@"Add"];
    [dataHelper save];
    //set current user to the newUser
    [_currentUser setCurrentUser:newUser];
//    NSLog(@"Cur_NAme: %@", _currentUser.userName);
    
    // Test listing all FailedBankInfos from the store
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSError *error;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                              inManagedObjectContext:dataHelper.context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [dataHelper.context executeFetchRequest:fetchRequest error:&error];
    for (User *user in fetchedObjects) {
        NSLog(@"NAme: %@", user.userName);
        NSLog(@"Weight: %@", user.weight.stringValue);
        NSLog(@"Height: %@", user.height.stringValue);
        NSLog(@"Birthday: %@", user.birthday);
        NSLog(@"Sex: %@", user.sex.stringValue);
    }
}

- (void)setupNewUser: (User *) user
{
    // Add a new item to the database
    
    user.userName = self.userNameTF.text;
    // split the string, we want only the number instead of unit
    NSArray *array = [self.weightTF.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *aNumber = [f numberFromString: array.firstObject];
    
    user.weight = aNumber;
    
    array = [self.heightTF.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    aNumber = [f numberFromString: array.firstObject];
    user.height = aNumber;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date = [dateFormat dateFromString:self.birthdayTF.text];
    //We should add one day because of a default unexplainable error from the datePicker
    user.birthday = [date dateByAddingTimeInterval:60*60*24*1];
    
    user.sex = self.sex == nil? [NSNumber numberWithInteger:0]: self.sex;
}
@end