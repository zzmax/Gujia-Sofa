//
//  UserInfoRegisterViewController.m
//  iSmartHome
//
//  Created by admin on 15/12/1.
//  Copyright © 2015年 zzmax. All rights reserved.
//
//  This view is to create or modify the basic infos for a user

#import <Foundation/Foundation.h>
#import "UserInfoRegisterViewController.h"
#import "ConstraintMacros.h"
#import "AppDelegate.h"
#import "CoreDataHelper.h"
#import "CurrentUser.h"
#import "UsersCreationViewController.h"
#import "GlobalSocket.h"
#import "Utility.h"
@import AssetsLibrary;
@import MobileCoreServices;


@interface UserInfoRegisterViewController()<UtilityDelegate>
{
    CoreDataHelper *dataHelper;
    GlobalSocket *globalSocket;
    Utility *utility;
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
//This view contains two modes: creation or modification
//Yes => CreationMode
//NO =>  ModificationMode
@property BOOL isCreationMode;
@property BOOL didUserNameChanged;
@property UIPopoverController *photoPopover;//照片popover
@property int indexViewControllerToPresent;
@property BOOL userPhotoHasChanged;
@end

@implementation UserInfoRegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Establish Core Data
    dataHelper = [[CoreDataHelper alloc] init];
    dataHelper.entityName = @"User";
    dataHelper.defaultSortAttribute = @"userName";
    // Setup data
    [dataHelper setupCoreData];
    // Set to the current user
    _currentUser = [CurrentUser staticCurrentUser];
    
    //initiate connection to wifi
    globalSocket = [GlobalSocket sharedGlobalSocket];
    
    //initiate variable
    utility = [[Utility alloc]init];
    utility.utilityDelegateDelegate = self;
    
    //add an observer to _userNameTF
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userNameDidChange:) name:UITextFieldTextDidChangeNotification object:_userNameTF];
    
    self.view.backgroundColor = NAVIGATION_COLOR;
    self.tableView.backgroundColor = NAVIGATION_COLOR;
     self.tableView.scrollEnabled = NO;
    //initiate table data
    _infoTitles = [NSArray arrayWithObjects:@"",@"性别", @"生日", @"身高", @"体重",nil];
    
    // set title
    if (self.navTitle == nil) {
        self.navTitle = @"创建用户";
    }
    self.navigationItem.title = self.navTitle;
    
    //set view mode
    if (_currentUser.userName == nil || [self.navTitle isEqualToString:@"创建用户"]) {
        _isCreationMode = YES;
    }
    else _isCreationMode = NO;
    
    if ( _isCreationMode) {
//         _startBtn.hidden = NO;
        _startBtn.frame = BOTTOM_RECT;
        PREPCONSTRAINTS(_startBtn);
        ALIGN_VIEW_LEFT_CONSTANT(_startBtn.superview,_startBtn, 10);
        ALIGN_VIEW_RIGHT_CONSTANT(_startBtn.superview, _startBtn, -10);
        ALIGN_VIEW_BOTTOM_CONSTANT(self.view, _startBtn, -40);
        [_startBtn setTitle:@"开始使用" forState:UIControlStateNormal];
        _startBtn.titleLabel.textColor = [UIColor blackColor];
//        _currentUser = nil;
    }
    else {
//        _startBtn.hidden = YES;
        [_startBtn removeFromSuperview];
        
        UIButton *deleteUserBtn = [[UIButton alloc] initWithFrame:BOTTOM_RECT];
        [self.view addSubview:deleteUserBtn];
        PREPCONSTRAINTS(deleteUserBtn);
        ALIGN_VIEW_LEFT_CONSTANT(deleteUserBtn.superview,deleteUserBtn, 10);
        ALIGN_VIEW_RIGHT_CONSTANT(deleteUserBtn.superview, deleteUserBtn, -10);
        ALIGN_VIEW_BOTTOM_CONSTANT(self.view, deleteUserBtn, -40);
        [deleteUserBtn setTitle:@"删除用户" forState:UIControlStateNormal];
        deleteUserBtn.titleLabel.textColor = [UIColor blackColor];
        deleteUserBtn.backgroundColor = [UIColor redColor];
        deleteUserBtn.layer.cornerRadius = 5;
        CONSTRAIN_SIZE(deleteUserBtn, SCREEN_HEIGHT / 12, SCREEN_WIDTH - 40);
        [deleteUserBtn addTarget:self action:@selector(deleteUser) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _userPhoto = [[UIImageView alloc]init];
    _userPhoto.image = [self loadCurrentUserPhoto];
}


- (void)viewDidAppear:(BOOL)animated
{
    [self.userNameTF becomeFirstResponder];
}

- (IBAction)popView:(id) sender
{
    // if the view is modification mode, we will save data before quit the view
    if (!_isCreationMode)
    {
        [self modifyCurrentUser];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"InfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"男性",@"女性"]];
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    UIPickerView *heightPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    UIPickerView *weightPicker = [[UIPickerView alloc] init];
    
    NSDateFormatter *dformat = [[NSDateFormatter alloc]init];
    
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
//            if (!_userPhoto.image) {
//                UIImage *image = [UIImage imageNamed: @"background_small_white_circle"];
//                _userPhoto.image = image;
//            }
            
            //add a tap gesture recognizer to take photo for user
            UITapGestureRecognizer *photoTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showActionSheetForTakingPicture:)];
            photoTapRecognizer.delegate = self;
            cell.imageView.userInteractionEnabled = YES;
            [cell.imageView addGestureRecognizer:photoTapRecognizer];
            
            
            //set textField for userName
            _userNameTF = [[UITextField alloc] init];
            //set size and location
//            CGRect frameRect = _userNameTF.frame;
//            frameRect.size = CGSizeMake(200, 50);//150, 35,
//            _userNameTF.frame = frameRect;
            _userNameTF.frame = CGRectMake(SCREEN_WIDTH * 5/12 - 10, 35, SCREEN_WIDTH * 7/12, 50);
//            CONSTRAIN_SIZE(_userNameTF.viewForFirstBaselineLayout,200,50);
////            CONSTRAIN_HEIGHT(_userNameTF.viewForFirstBaselineLayout, 50);
            
            
            
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
            segmentedControl.frame = CGRectMake(SCREEN_WIDTH * 5/12 - 10, 7, SCREEN_WIDTH * 7/12, 28);
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
            datePicker.datePickerMode = UIDatePickerModeDate;
            [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
            
            //set textField for birthday
            _birthdayTF = [[UITextField alloc] init];
            _birthdayTF.frame = CGRectMake(SCREEN_WIDTH * 5/12 - 10,7, SCREEN_WIDTH * 7/12, 28);
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
            _heightTF.frame = CGRectMake(SCREEN_WIDTH * 5/12 - 10, 7, SCREEN_WIDTH * 7/12, 28);            _heightTF.inputView = heightPicker;
            _heightTF.inputAccessoryView = pickerToolbar;
            _heightTF.textColor = [UIColor whiteColor];
            _heightTF.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:_heightTF];
        }
        //weight line
        else if(indexPath.row == 4)
        {
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
            _weightTF.frame = CGRectMake(SCREEN_WIDTH * 5/12 - 10, 7, SCREEN_WIDTH * 7/12, 28);
            _weightTF.inputView = weightPicker;
            _weightTF.inputAccessoryView = pickerToolbar;
            _weightTF.textColor = [UIColor whiteColor];
            _weightTF.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:_weightTF];
        }
    }
    
    cell.textLabel.text = [_infoTitles objectAtIndex: indexPath.row];
    cell.backgroundColor = NAVIGATION_COLOR;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.clipsToBounds = YES;
    //disable cell selected effect
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //set value for each cell
    if (!_isCreationMode) {
        int shouldSelectHeightPickerRow = [_currentUser.height intValue] - [_heightPickerArray.firstObject intValue];
        int shouldSelectWeightPickerRow = [_currentUser.weight intValue] - [_weightPickerArray.firstObject intValue];
        switch (indexPath.row) {
            case 0:
                _userNameTF.text = _currentUser.userName;
                break;
            case 1:
                segmentedControl.selectedSegmentIndex = [_currentUser.sex intValue];
                break;
            case 2:
                [datePicker setDate: _currentUser.birthday];
                [self updateTextField:(id)_birthdayTF];
                break;
            case 3:
                [self pickerView:heightPicker didSelectRow:shouldSelectHeightPickerRow inComponent:0];
                [heightPicker selectRow:shouldSelectHeightPickerRow inComponent:0 animated:YES];
                break;
            case 4:
                [self pickerView:weightPicker didSelectRow:shouldSelectWeightPickerRow inComponent:0];
                [weightPicker selectRow:shouldSelectWeightPickerRow inComponent:0 animated:YES];

                break;
                
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row) {
            case 0:
                _userNameTF.text = nil;
                break;
            case 1:
                segmentedControl.selectedSegmentIndex = 0;
                break;
            case 2:
                [dformat setDateFormat:@"yyyy-MM-dd"];
                [datePicker setDate: [dformat dateFromString:@"1950-01-01"]];
                [self updateTextField:(id)_birthdayTF];
                break;
            case 3:
                [self pickerView:heightPicker didSelectRow:20 inComponent:0];
                //Set the default value to 170cm
                [heightPicker selectRow:20 inComponent:0 animated:YES];
                break;
            case 4:
                [self pickerView:weightPicker didSelectRow:20 inComponent:0];
                //Set the default value to 60kg
                [weightPicker selectRow:20 inComponent:0 animated:YES];
                break;
                
            default:
                break;
        }
    }
    if (indexPath.row == 0) {
        cell.imageView.image = _userPhoto.image;
        cell.imageView.layer.borderWidth = 20.0f;
        cell.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        //change the size of the imageview in cell to (90,90)
        CGFloat widthScale = 90/_userPhoto.image.size.width;
        CGFloat heightScale = 90/_userPhoto.image.size.height;
        cell.imageView.transform = CGAffineTransformMakeScale(widthScale, heightScale);
        //set image to a circle
        cell.imageView.layer.cornerRadius = cell.imageView.image.size.width/2;
        cell.imageView.layer.masksToBounds = YES;
    }
    
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

- (void)userNameDidChange:(NSNotification *)notification
{
    _didUserNameChanged = YES;
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
    
    if (!_userNameTF.text || [_userNameTF.text isEqualToString:@""])
    {
        [utility setAlert:@"错误" message:@"请输入名字！"];
        [self presentViewController:utility.anAlert animated:YES completion:nil];
        NSLog(@"Error: Input a name.");
        
    }
    else
    {
        //test the name if it has already been used
        [dataHelper fetchItemsMatching:_userNameTF.text forAttribute:@"userName" sortingBy:nil];
        if (dataHelper.fetchedResultsController.fetchedObjects.count > 0)
        {
            [utility setAlert:@"错误" message:@"已经有相同名字的用户。"];
            [self presentViewController:utility.anAlert animated:YES completion:nil];
            NSLog(@"Error1: Many results for the same user.");
        }
        else
            [self saveUserInfo];
    }
    
}

-(void)saveUserInfo
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
        NSLog(@"isCurrentUser: %@", user.isCurrentUser);
    }
    
    if (_userPhotoHasChanged) {
        //save the image as a file in app
        [self saveImageAsAPNG:_userPhoto.image];
    }
    
    if ([globalSocket.message isEqualToString:@"连接成功"]) {
        [self performSegueWithIdentifier:@"toNavigationViewController" sender:self];
    }
    /**
     *  just for test
     */
    [self performSegueWithIdentifier:@"toNavigationViewController" sender:self];
}

//override the methode to determine which view controller to push
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
    //we will test the connection of socket
    //if we've already get the connection, we should directly go to navigationVC
    //if not, we connect
    if ([globalSocket.message isEqualToString:@"连接成功"] && [identifier isEqualToString:@"toNavigationViewController"]) {
        return  YES;    }
    else if (![globalSocket.message isEqualToString:@"连接成功"] && [identifier isEqualToString:@"toWifiConfigNoteViewController" ])
    {
        return  YES;
    };
    
    
    return NO;
}

- (void)modifyCurrentUser
{
    [dataHelper fetchItemsMatching:_userNameTF.text forAttribute:@"userName" sortingBy:nil];
    //if we don't change the user name or if we've changed the name and after a second we changed it back
    if (!_didUserNameChanged || [_currentUser.userName isEqualToString:_userNameTF.text]) {
        if (dataHelper.fetchedResultsController.fetchedObjects.count == 1) {
            User *user = dataHelper.fetchedResultsController.fetchedObjects.firstObject;
            [self setupNewUser:user];
            [dataHelper save];
            [_currentUser setCurrentUser:user];
            if (_userPhotoHasChanged) {
                //save the image as a file in app
                [self saveImageAsAPNG:_userPhoto.image];
            }
        }
        else if (dataHelper.fetchedResultsController.fetchedObjects.count > 1)
        {
            [utility setAlert:@"系统错误" message:@"已经有相同名字的用户。"];
            [self presentViewController:utility.anAlert animated:YES completion:nil];
            NSLog(@"Error1: Many results for the same user.");
        }
    }
    //if we changed the name and it is not the same as the old one.
    else
    {
        if (dataHelper.fetchedResultsController.fetchedObjects.count == 0) {
            [dataHelper fetchItemsMatching:_currentUser.userName forAttribute:@"userName" sortingBy:nil];
            User *user = dataHelper.fetchedResultsController.fetchedObjects.firstObject;
            [self setupNewUser:user];
            [dataHelper save];
            [_currentUser setCurrentUser:user];
            if (_userPhotoHasChanged) {
                //save the image as a file in app
                [self saveImageAsAPNG:_userPhoto.image];
            }
        }
        else if (dataHelper.fetchedResultsController.fetchedObjects.count > 0)
        {
            [utility setAlert:@"错误" message:@"已经有相同名字的用户。"];
            [self presentViewController:utility.anAlert animated:YES completion:nil];
            NSLog(@"Error2: Many results for the same user.");
        }

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
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    NSDate *date = [dateFormat dateFromString:self.birthdayTF.text];
    //We should add one day because of a default unexplainable error from the datePicker
    user.birthday = date;//[date dateByAddingTimeInterval:60*60*24*1];
    
    user.sex = self.sex == nil? [NSNumber numberWithInteger:0]: self.sex;
    
    //change current user to a normal user
    [dataHelper fetchItemsMatching:@"1" forAttribute:@"isCurrentUser" sortingBy:nil];
    if (dataHelper.fetchedResultsController.fetchedObjects.count > 1)
    {
        [NSException raise:@"系统错误" format:@"Too many current user : %lu", dataHelper.fetchedResultsController.fetchedObjects.count];
    }
    User *oldUser = dataHelper.fetchedResultsController.fetchedObjects.firstObject;
    oldUser.isCurrentUser = [NSNumber numberWithInteger:0];
    
    user.isCurrentUser = [NSNumber numberWithInteger:1];
}

- (void)deleteUser
{
//    [dataHelper clearData];
    [utility setAlert:@"删除用户" message:@"这将会删除用户所有数据，确认删除吗？"];
    [self presentViewController:utility.anAlert animated:YES completion:nil];
}

/**
 *  删除用户提示
 *
 *  @param alertView   <#alertView description#>
 *  @param buttonIndex <#buttonIndex description#>
 */
-(void)deleteUserAction:(NSInteger)deleteOrNot
{
    if (deleteOrNot==1) {
        [self removePhotoForCurrentUser];
        [dataHelper fetchItemsMatching:_currentUser.userName forAttribute:@"userName" sortingBy:nil];
        if ([dataHelper deleteObject:dataHelper.fetchedResultsController.fetchedObjects.firstObject])
        {
            UsersCreationViewController *userChangeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UsersCreationViewController"];
            userChangeVC.navTitle = @"家人健康信息";
            [self.navigationController pushViewController:userChangeVC animated:YES];
            
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [app changeRootViewController:userChangeVC];

        }
    }else
    {
        [self popView:(id)self.navigationItem.leftBarButtonItem];
    }
}

#pragma choose a picture or take a picture for user
- (void)showActionSheetForTakingPicture:(UITapGestureRecognizer*)sender
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil
                                                                              message: nil
                                                                       preferredStyle: UIAlertControllerStyleActionSheet];
    [alertController addAction: [UIAlertAction actionWithTitle: @"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // Handle Take Photo here
        if (_photoPopover) return;
        _indexViewControllerToPresent = 1;
        [self presentViewController];
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"从照片中选取" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // Handle Choose Existing Photo here
        if (_photoPopover) return;
        _indexViewControllerToPresent = 2;
        [self presentViewController];
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}]];
    
    alertController.modalPresentationStyle = UIModalPresentationPopover;
    
    [self presentViewController: alertController animated: YES completion: nil];

}

- (void)presentViewController
{
    // Create and initialize the picker
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType =
                        _indexViewControllerToPresent == 1 ?UIImagePickerControllerSourceTypeCamera
                            :UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate = self;

    if (IS_IPHONE)
    {
        [self presentViewController:picker animated:YES completion:nil];
    }
    else if(_indexViewControllerToPresent == 1)
    {
        _photoPopover = [[UIPopoverController alloc] initWithContentViewController:picker];
        _photoPopover.delegate = self;
        [_photoPopover presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else if(_indexViewControllerToPresent == 2)
    {
        // Workaround to an Apple crasher when asking for asset library authorization with a popover displayed
        ALAssetsLibrary * assetsLibrary = [[ALAssetsLibrary alloc] init];
        ALAuthorizationStatus authStatus;
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_0)
            authStatus = [ALAssetsLibrary authorizationStatus];
        else
            authStatus = ALAuthorizationStatusAuthorized;
        
        if (authStatus == ALAuthorizationStatusAuthorized)
        {
            _photoPopover = [[UIPopoverController alloc] initWithContentViewController:picker];
            _photoPopover.delegate = self;
            [_photoPopover presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else if (authStatus == ALAuthorizationStatusNotDetermined)
        {
            // Force authorization
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                // If authorized, catch the final iteration and display popover
                if (group == nil)
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _photoPopover = [[UIPopoverController alloc] initWithContentViewController:picker];
                        _photoPopover.delegate = self;
                        [_photoPopover presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    });
                *stop = YES;
            } failureBlock:nil];
        }

    }
}

- (void)loadImageFromAssetURL:(NSURL *)assetURL into:(UIImage **)image
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    ALAssetsLibraryAssetForURLResultBlock resultsBlock = ^(ALAsset *asset)
    {
        ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
        CGImageRef cgImage = [assetRepresentation CGImageWithOptions:nil];
        CFRetain(cgImage); // Thanks Oliver Drobnik
        if (image) *image = [UIImage imageWithCGImage:cgImage];
        CFRelease(cgImage);
    };
    
    ALAssetsLibraryAccessFailureBlock failure = ^(NSError *__strong error)
    {
        NSLog(@"Error retrieving asset from url: %@", error.localizedFailureReason);
    };
    
    [library assetForURL:assetURL resultBlock:resultsBlock failureBlock:failure];
}

// Update image and for iPhone, dismiss the controller
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Use the edited image if available
    UIImage __autoreleasing *image = info[UIImagePickerControllerEditedImage];
    
    // If not, grab the original image
    if (!image) image = info[UIImagePickerControllerOriginalImage];
    
    NSURL *assetURL = info[UIImagePickerControllerReferenceURL];
    if (!image && !assetURL)
    {
        NSLog(@"Cannot retrieve an image from the selected item. Giving up.");
    }
    else if (!image)
    {
        NSLog(@"Retrieving from Assets Library");
        [self loadImageFromAssetURL:assetURL into:&image];
    }
    
    if (image)
    {
        if (_indexViewControllerToPresent == 1) {
            // Save the image to photo library
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
        _userPhoto.image = image;
        //image has changed
        _userPhotoHasChanged = YES;
        
        [_tableView reloadData];
    }
    
    [self performDismiss];
}

// Finished saving
- (void)image:(UIImage *)image didFinishSavingWithError: (NSError *)error contextInfo:(void *)contextInfo
{
    // Handle the end of the image write process
    if (!error)
        NSLog(@"Image written to photo album");
    else
        NSLog(@"Error writing to photo album: %@", error.localizedFailureReason);
}

-(void)saveImageAsAPNG:(UIImage*)image
{
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSMutableString *appendString = [NSMutableString string];
        [appendString appendString:_userNameTF.text];
        [appendString appendString:@".png"];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithString: appendString] ];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
}

- (UIImage*)loadCurrentUserPhoto
{
    if (!_isCreationMode) {
        return [utility loadPhotoForUser:_currentUser.userName];
    }
    return [utility loadPhotoForUser:@""];
   }

- (void)removePhotoForCurrentUser
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSMutableString *appendString = [NSMutableString string];
    [appendString appendString:_currentUser.userName];
    [appendString appendString:@".png"];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:appendString];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
//        UIAlertView *removedSuccessFullyAlert = [[UIAlertView alloc] initWithTitle:@"用户头像已移除" message:@"" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
//        [removedSuccessFullyAlert show];
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

// Dismiss picker
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self performDismiss];
}

- (void)performDismiss
{
    if (IS_IPHONE)
        [self dismissViewControllerAnimated:YES completion:nil];
    else
    {
        [_photoPopover dismissPopoverAnimated:YES];
        _photoPopover = nil;
    }
}


@end