//
//  SmartMlccUtil.h
//  SmartHome
//
//  Created by ysamg on 15-1-21.
//  Copyright (c) 2015年 妙联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmartMlccUtil : NSObject

+ (NSData *)makeTcpCommandData:(NSString *)command;
+ (NSData*)makeMlccUtil:(NSString *)command;
+ (NSString *)getReturnCommand:(NSData *)data;
+ (NSString*)parseCommandData:(NSString *)data;
+ (NSString *)parseTcpCommandData:(NSString *)data;

@end
