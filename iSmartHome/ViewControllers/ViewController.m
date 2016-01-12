//
//  ViewController.m
//  iSmartHome
//
//  Created by zwwang on 15/10/26.
//  Copyright © 2015年 zwwang. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Utility.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *cipherCode;

@property (weak, nonatomic) IBOutlet UILabel *userNameShow;
@property (weak, nonatomic) IBOutlet UILabel *cipherCodeShow;
//Some useful methodes we can share
@property Utility *utility;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.userName.placeholder = @"用户名";
    self.cipherCode.placeholder = @"密码";
    
    //Initiate the utility object 
    _utility = [[Utility alloc] init];
    [self.utility activeDismissableKeyboard:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//cancel the first responder of the keyborad until we active next textField
- (BOOL)textFieldShouldReturn: (UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)login:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    NSError *error;
    
    if (![[self fetchedResultsController:self.userName.text forAttribute:@"username"] performFetch:&error])
    {
        ;
    }
    
    int iCount=0;
    NSString *strTempUserName=@"";
    NSString *strTempPassowrd=@"";
    
    for (User *user in self.fetchedResultsController.fetchedObjects)
    {
        iCount++;
        strTempUserName=[strTempUserName stringByAppendingFormat: @"#%d,# %@",iCount,user.userName];
        strTempPassowrd=[strTempPassowrd stringByAppendingFormat: @"#%d,# %@",iCount,user.password];
    }
    
    self.userNameShow.text = strTempUserName;
    self.cipherCodeShow.text = strTempPassowrd;
}

#pragma  mark - Fetched Results controller
-(NSFetchedResultsController *)fetchedResultsController:(NSString *)searchString forAttribute:(NSString *) attribute
{
    /*
    if (_fetchedResultsController!=nil)
    {
        return _fetchedResultsController;
    }
    */
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    //
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    
    NSSortDescriptor *userNameSortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"username" ascending:YES];
    
    NSArray *sortDescriptors = @[nameSortDescriptor, userNameSortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    if (searchString && attribute)
    {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K contains[CD] %@",attribute,searchString];
    }
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

@end
