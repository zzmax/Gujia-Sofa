//
//  RegisterLastViewController.m
//  iSmartHome
//
//  Created by zwwang on 15/10/26.
//  Copyright © 2015年 zwwang. All rights reserved.
//

#import "RegisterLastViewController.h"
#import "AppDelegate.h"

@interface RegisterLastViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userName;


@property (weak, nonatomic) IBOutlet UITextField *code1;

@property (weak, nonatomic) IBOutlet UITextField *code2;


@end

@implementation RegisterLastViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerLandingAccount:(UIButton *)sender
{
    NSError __autoreleasing *error;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    appDelegate.registerUser.userName = self.userName.text;
    
    if (self.code1.text ==  self.code2.text)
    {
        appDelegate.registerUser.password = self.code1.text;
    }
    
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    
    User *newUser = (User *)newManagedObject;
//    newUser.name = appDelegate.registerUser.name;
    newUser.password = appDelegate.registerUser.password ;
    newUser.sex =appDelegate.registerUser.sex ;
    newUser.birthday =appDelegate.registerUser.birthday ;
    newUser.height = appDelegate.registerUser.height;
    newUser.weight = appDelegate.registerUser.weight ;
    newUser.userName = appDelegate.registerUser.userName ;
    
    BOOL success;
    
    if (!(success = [context save:&error]))
    {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        abort();
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
