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

@property (strong, nonatomic)NSMutableArray *sedentaryTimePickerArray;
@property (strong, nonatomic)NSMutableArray *healthHourPickerArray;
@property (strong, nonatomic)NSMutableArray *healthDayPickerArray;

@property (strong, nonatomic)UIPickerView *sedentaryTimePicker;
@property (strong, nonatomic)UIPickerView *healthHourPicker;
@property (strong, nonatomic)UIPickerView *healthDayPicker;
@end

@implementation HealthReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
    
    _sedentaryReminderTF.inputAccessoryView = pickerToolbar;
    _healthExamReminderDTF.inputAccessoryView = pickerToolbar;
    _healthExamReminderHTF.inputAccessoryView = pickerToolbar;
    
    //
    _sedentaryTimePickerArray = [[NSMutableArray alloc] init];
    _healthDayPickerArray = [[NSMutableArray alloc] init];
    _healthHourPickerArray = [[NSMutableArray alloc] init];
    
    for (int time = 0; time<=24; time++) {
        NSString *timeString = [NSString stringWithFormat:@"%d",time];
        if(time <= 6)
            [_sedentaryTimePickerArray addObject:timeString];
        if(time >= 5 && time <= 22)
            [_healthHourPickerArray addObject:timeString];
        if(time <= 7)
            [_healthDayPickerArray addObject:timeString];
    }
    
    _sedentaryTimePicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    _healthHourPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    _healthDayPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    
    _sedentaryTimePicker.delegate = self;
    _sedentaryTimePicker.dataSource = self;
    _sedentaryTimePicker.showsSelectionIndicator = YES;
    _sedentaryTimePicker.tag = 100;
    _sedentaryReminderTF.inputView = _sedentaryTimePicker;
    
    _healthDayPicker.delegate = self;
    _healthDayPicker.dataSource = self;
    _healthDayPicker.showsSelectionIndicator = YES;
    _healthDayPicker.tag = 101;
    _healthExamReminderDTF.inputView = _healthDayPicker;

    _healthHourPicker.delegate = self;
    _healthHourPicker.dataSource = self;
    _healthHourPicker.showsSelectionIndicator = YES;
    _healthHourPicker.tag = 102;
    _healthExamReminderHTF.inputView = _healthHourPicker;
    
    _healthExamReminderDTF.layer.cornerRadius = 5;
    _healthExamReminderHTF.layer.cornerRadius = 5;
    _sedentaryReminderTF.layer.cornerRadius = 5;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doneButtonPressed:(id)sender
{
    if (self.sedentaryReminderTF.isFirstResponder) {
        [self.sedentaryReminderTF resignFirstResponder];
        [self.healthExamReminderDTF becomeFirstResponder];
    }
    else if (self.healthExamReminderDTF.isFirstResponder)
    {
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
//
-(void)startLocalNotification: (NSInteger) aTime and:(NSString*) someWords{  // Bind this method to UIButton action
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        
       UIUserNotificationType types = (UIUserNotificationType) (UIUserNotificationTypeBadge |
                                                                UIUserNotificationTypeSound | UIUserNotificationTypeAlert);
        
        UIUserNotificationSettings *mySettings =
        [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    }
    
    NSLog(@"startLocalNotification");
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:aTime];
    notification.alertBody = someWords;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = 10;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
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
        return _healthDayPickerArray.count;
    else
        return _healthHourPickerArray.count;
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 100) {
        [_sedentaryReminderTF setText: [NSString stringWithFormat:@"%@%@%@",@"  久坐 ",[_sedentaryTimePickerArray objectAtIndex:row],@" 小时后提醒"]];
        [self startLocalNotification:row*60 and:[NSString stringWithFormat:@"%@ %li %@",@"已经坐了",(long)row,@"小时；请起来运动一会。"]];
    }
    else if (pickerView.tag == 101) {
        [_healthExamReminderDTF setText: [NSString stringWithFormat:@"%@%@%@",@"  每过 ",[_healthDayPickerArray objectAtIndex:row],@" 天提醒进行健康检测"]];
    }
    else
    {
         [_healthExamReminderHTF setText: [NSString stringWithFormat:@"%@%@%@",@"  每天 ",[_healthHourPickerArray objectAtIndex:row],@" 时提醒进行健康检测"]];
        
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow: (NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 100) {
        return [_sedentaryTimePickerArray objectAtIndex:row];
    }
    else if(pickerView.tag == 101) {
        return [_healthDayPickerArray objectAtIndex:row];
    }
    else
    {
        return [_healthHourPickerArray objectAtIndex:row];
    }
}


@end
