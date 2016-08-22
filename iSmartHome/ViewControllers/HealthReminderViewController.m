//
//  HealthReminderViewController.m
//  iSmartHome
//
//  Created by admin on 16/3/22.
//  Copyright © 2016年 zzmax. All rights reserved.
//

#import "HealthReminderViewController.h"
#import "Utility.h"
#import "ConstraintMacros.h"

@interface HealthReminderViewController ()
@property (strong, nonatomic)IBOutlet UITextField *sedentaryReminderTF;
//For which time we launch the remind
@property (strong, nonatomic)IBOutlet UITextField *healthExamReminderHTF;
//For which day we launch the remind
@property (strong, nonatomic)IBOutlet UITextField *healthExamReminderDTF;
@property (strong, nonatomic)IBOutlet UIButton *cancelNotification;

@property (strong, nonatomic)NSMutableArray *sedentaryTimePickerArray;
@property (strong, nonatomic)NSMutableArray *healthTimePickerArray;
@property (strong, nonatomic)NSMutableArray *healthFreauencyPickerArray;

@property (strong, nonatomic)UIPickerView *sedentaryTimePicker;
@property (strong, nonatomic)UIPickerView *healthHourPicker;
@property (strong, nonatomic)UIPickerView *healthFrequencyPicker;
@property Utility *utility;
@end


@implementation HealthReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    PREPCONSTRAINTS(_sedentaryReminderTF);
    CONSTRAIN_WIDTH(_sedentaryReminderTF, 330 * SCREENFACTOR);
    
    _utility = [[Utility alloc]init];
    // set title
    self.navigationItem.title = @"健康提醒";
    //set tool bar to dismiss datepicker
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *cancelbtn = BARBUTTON(@"取消",@selector(cancelButtonPressed:));
    [barItems addObject:cancelbtn];
    
    UIBarButtonItem *flexSpace = SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace,nil);
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = BARBUTTON(@"完成", @selector(doneButtonPressed:));
    [barItems addObject:doneBtn];
    [pickerToolbar setItems:barItems animated:YES];
    
    _sedentaryReminderTF.inputAccessoryView = pickerToolbar;
    _healthExamReminderDTF.inputAccessoryView = pickerToolbar;
    _healthExamReminderHTF.inputAccessoryView = pickerToolbar;
    
    //
    _sedentaryTimePickerArray = [[NSMutableArray alloc] init];
    _healthFreauencyPickerArray = [[NSMutableArray alloc] init];
    _healthTimePickerArray = [[NSMutableArray alloc] init];
    
    for (int time = 0; time<=24; time++) {
        NSString *timeString = [NSString stringWithFormat:@"%d",time];
        if(time <= 6)
            [_sedentaryTimePickerArray addObject:timeString];
        if(time >= 5 && time <= 22)
            [_healthTimePickerArray addObject:timeString];
    }
    [_healthFreauencyPickerArray addObjectsFromArray:@[@"日",@"周",@"月"]];
    
    _sedentaryTimePicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    _healthHourPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    _healthFrequencyPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    
    _sedentaryTimePicker.delegate = self;
    _sedentaryTimePicker.dataSource = self;
    _sedentaryTimePicker.showsSelectionIndicator = YES;
    _sedentaryTimePicker.tag = 100;
    _sedentaryReminderTF.inputView = _sedentaryTimePicker;
    
    _healthFrequencyPicker.delegate = self;
    _healthFrequencyPicker.dataSource = self;
    _healthFrequencyPicker.showsSelectionIndicator = YES;
    _healthFrequencyPicker.tag = 101;
    _healthExamReminderDTF.inputView = _healthFrequencyPicker;

    _healthHourPicker.delegate = self;
    _healthHourPicker.dataSource = self;
    _healthHourPicker.showsSelectionIndicator = YES;
    _healthHourPicker.tag = 102;
    _healthExamReminderHTF.inputView = _healthHourPicker;
    
    _healthExamReminderDTF.layer.cornerRadius = 5;
    _healthExamReminderHTF.layer.cornerRadius = 5;
    _sedentaryReminderTF.layer.cornerRadius = 5;
    
    [_cancelNotification setExclusiveTouch: YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancelButtonPressed:(id)sender
{
    [self.sedentaryReminderTF resignFirstResponder];
    [self.healthExamReminderDTF resignFirstResponder];
    [self.healthExamReminderHTF resignFirstResponder];
}


-(void)doneButtonPressed:(id)sender
{
    if (self.sedentaryReminderTF.isFirstResponder) {
        [self.sedentaryReminderTF resignFirstResponder];
        [self.healthExamReminderDTF becomeFirstResponder];
    }
    else if (self.healthExamReminderDTF.isFirstResponder)
    {
        if (![_healthFrequencyPicker selectedRowInComponent:0]) {
            [_healthExamReminderDTF setText: [NSString stringWithFormat:@"%@%@",@"  每 日",@" 提醒进行健康检测"]];
            [self.healthFrequencyPicker selectRow:0 inComponent:0 animated:YES];
        }
        [self.healthExamReminderDTF resignFirstResponder];
        [self.healthExamReminderHTF becomeFirstResponder];
    }
    else
    {
        [self.healthExamReminderHTF resignFirstResponder];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/**
 *  This Function is to set a notification for Sedentary or health examination reminder.
 *
 *  @param aTime     Time to push notification.
 *  @param someWords Content of notification.
 *  @param aType     Sedentary or health Examination Reminder.(1 for Sedentary, 2 for health examination reminder  */
-(void)startLocalNotification: (NSInteger) aTime and:(NSString*) someWords forWhichTypeReminder:(NSInteger) aType{
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        
       UIUserNotificationType types = (UIUserNotificationType) (UIUserNotificationTypeBadge |
                                                                UIUserNotificationTypeSound | UIUserNotificationTypeAlert);
        
        UIUserNotificationSettings *mySettings =
        [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    }
    
    NSLog(@"startLocalNotification");
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (aType == 1) {
        //set for sedentary notification time
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:aTime * 60];// for a minute just for test // * 3600//
        //notification.applicationIconBadgeNumber = 1;
    }
    else if(aType == 2)
    {
       // NSDictionary* userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
        //@"uid",@"TestNote", [NSNumber numberWithInteger:aTime*60],@"period" ,nil];
       // notification.userInfo = userInfo;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *now = [NSDate date];
        NSDate *expected = [calendar dateBySettingHour:aTime minute:0 second:0 ofDate:now options:NSCalendarMatchStrictly];
        
        notification.fireDate = expected;
        notification.alertAction = @"健康检测提醒";
        notification.soundName = UILocalNotificationDefaultSoundName;
       // notification.applicationIconBadgeNumber = 1;
        
        NSInteger selectedRepeatInterval = [_healthFrequencyPicker selectedRowInComponent:0];
        switch (selectedRepeatInterval) {
            case 0:
                notification.repeatInterval = NSCalendarUnitDay;
                break;
            case 1:
                notification.repeatInterval = NSCalendarUnitWeekOfMonth;
                break;
            case 2:
                notification.repeatInterval = NSCalendarUnitMonth;
                break;
            default:
                notification.repeatInterval = NSCalendarUnitDay;
                break;
        }
        
//        NSLog(@"%ld, %d, %@", (long)aTime, 0, [expected descriptionWithLocale:[NSLocale currentLocale]]);

    }
    
    notification.alertBody = someWords;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = @"Function.wav";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (IBAction)cancelNotifications:(id)sender
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 100) {
        return _sedentaryTimePickerArray.count;
    }
    else if(pickerView.tag == 101)
        return _healthFreauencyPickerArray.count;
    else
        return _healthTimePickerArray.count;
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 100) {
        [_sedentaryReminderTF setText: [NSString stringWithFormat:
                                        @"%@%@%@",
                                            @"  久坐 ",
                                            [_sedentaryTimePickerArray objectAtIndex:row],
                                            @" 小时后提醒"]];
        [self startLocalNotification:row
                and:
                    [NSString stringWithFormat:
                        @"%@ %li %@",
                            @"已经坐了",
                            (long)row,
                            @"小时,请起来运动一会。"]
                forWhichTypeReminder:1];
    }
    else if (pickerView.tag == 101) {
        [_healthExamReminderDTF setText: [NSString stringWithFormat:
                                              @"%@%@%@",
                                                @"  每 ",
                                                [_healthFreauencyPickerArray objectAtIndex:row],
                                                @" 提醒进行健康检测"]];
        //[self startLocalNotification:row and:@"请进行健康检测。" forWhichTypeReminder:2];
    }
    else
    {
         [_healthExamReminderHTF setText: [NSString stringWithFormat:
                                                @"%@%@%@",
                                                    @"  ",
                                                    [_healthTimePickerArray objectAtIndex:row],
                                                    @" 时提醒进行健康检测"
                                           ]
          ];
        [self startLocalNotification:
                    [[_healthTimePickerArray objectAtIndex:row] integerValue]
                and: @"请进行健康检测。"
                forWhichTypeReminder: 2
         ];
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow: (NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 100) {
        return [_sedentaryTimePickerArray objectAtIndex:row];
    }
    else if(pickerView.tag == 101) {
        return [_healthFreauencyPickerArray objectAtIndex:row];
    }
    else
    {
        return [_healthTimePickerArray objectAtIndex:row];
    }
}


@end
