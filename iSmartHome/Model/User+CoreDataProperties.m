//
//  User+CoreDataProperties.m
//  iSmartHome
//
//  Created by admin on 16/1/13.
//  Copyright © 2016年 zzmax. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)


@dynamic birthday;
@dynamic height;
@dynamic password;
@dynamic sex;
@dynamic userName;
@dynamic weight;
@dynamic healthInfo;

- (NSString *)section {
    return [[self.userName substringFromIndex:0] substringToIndex:1];
}

@end
