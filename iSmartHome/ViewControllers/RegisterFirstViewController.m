//
//  RegisterFirstViewController.m
//  iSmartHome
//
//  Created by zwwang on 15/10/26.
//  Copyright © 2015年 zwwang. All rights reserved.
//

#import "RegisterFirstViewController.h"
#import "AppDelegate.h"
#import "Utility.h"
#import "ConstraintMacros.h"


@interface RegisterFirstViewController ()
@property (weak, nonatomic) IBOutlet UITextField *registerName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *registerSex;
@property (weak, nonatomic) IBOutlet UITextField *birthday;
@property (weak, nonatomic) IBOutlet UITextField *weight;
@property (weak, nonatomic) IBOutlet UITextField *height;

@end

@implementation RegisterFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.registerName.placeholder = @"姓 名";
    self.birthday.placeholder = @"1990-10-20";
    self.weight.placeholder=@"65.0 kg";
    self.height.placeholder =@"170 cm";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    //简单粗暴的收键盘方法
//    [self.view endEditing:YES];
//}
///cancel keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if ([[segue identifier]isEqualToString:@"ToRegisterLastPage"])
    {
   
//        appDelegate.registerUser.name = self.registerName.text;
        appDelegate.registerUser.birthday =[appDelegate  stringToDate : self.birthday.text];
        appDelegate.registerUser.weight = @([self.weight.text floatValue]);
        appDelegate.registerUser.height = @([self.height.text floatValue]);
        
        switch (self.registerSex.selectedSegmentIndex)
        {
            case 0:
                appDelegate.registerUser.sex = [NSNumber numberWithInt:1];
                break;
                
            case 1:
                appDelegate.registerUser.sex = [NSNumber numberWithInt:2];
                break;
                
            default:
                break;
        }
        
    }
    
}


@end
