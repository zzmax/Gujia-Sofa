//
//  CurrentUser.m
//  iSmartHome
//
//  Created by admin on 16/1/13.
//  Copyright © 2016年 zzmax. All rights reserved.
//
//  This object is a static object which contains the current user's info.
#import "CurrentUser.h"

@implementation CurrentUser

- (instancetype)init
{
    if (self = [super init]) {
//        self = [[User alloc] init];
    }
    return self;
}

+ (id)staticCurrentUser
{
    static CurrentUser *sharedCurrentUser = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCurrentUser = [[CurrentUser alloc] init];
    });
    
    return sharedCurrentUser;
}

- (void)setCurrentUser:(User *)user
{
    _birthday = user.birthday;
    _userName = user.userName;
    _weight = user.weight;
    _height = user.height;
    _sex = user.sex;
}

@end
