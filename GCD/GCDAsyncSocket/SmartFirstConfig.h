//
//  SmartFirstConfig.h
//  SmartHome
//
//  Created by ysamg on 15-2-9.
//  Copyright (c) 2015年 妙联. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SmartFirstConfigDelegate <NSObject>
@optional
-(void)onSmartFirstConfigSuccess:(NSString*)reaMac;
-(void)onSmartSearchSuccess:(NSDictionary*)allMacInfo;
-(void)onSmartFirstConfigFailure;
@end

@interface SmartFirstConfig : NSObject

@property   (nonatomic , weak) id<SmartFirstConfigDelegate> fristConfigDelegate;


-(void)doSmartFirstConfig: (NSString*)staId sspwd:(NSString*)staPwd realCommandArr:(NSArray *)realCommandArr andOperType:(NSInteger)operType;
-(void)smartSocketClose;


- (BOOL)connectServerWithHost:(NSString*)serverIP andPort:(uint16_t)prot;
- (void)sendDataToServer:(NSString *)actionName;

@end
