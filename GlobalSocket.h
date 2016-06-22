//
//  GlobalSocket.h
//  iSmartHome
//
//  Created by admin on 15/12/19.
//  Copyright © 2015年 zzmax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "GCDAsyncSocket.h"

@interface GlobalSocket : NSObject
{
//    NSString *message;
}

#define INPUTBUFFERSIZE 125

@property (strong, retain)NSString *message;
@property (strong, retain)NSMutableArray *sofaTemp;
@property (strong, retain)NSString *bodyTemp;
@property (strong, retain)NSString *bloodO2;
@property (strong, retain)NSString *bloodPressure;
@property (strong, retain)NSString *heartRate;
@property (strong, retain)NSString *weight;
@property bool  btnS1;    //button s1
@property bool  btnS2;    //button s2


+ (id)sharedGlobalSocket;

NSString* MBNonEmptyString(id obj);

- (NSDictionary *)getWifiInfo;

- (GCDAsyncSocket *)getSocket;

- (UInt8 *)getInputBuffer;

- (void)setHost:(NSString *)aHost;

- (void)setPort:(NSString *)aPort;

- (void)setInputBuffer:(int)order and:(UInt8)anInputBuffer;

-(void)initControlMessage;

-(void)initAcquireSensorDataMessage;

-(void)initNetworkCommunication;

-(void)startSendMessageTimer;

-(void)stopSendMessgeTimer;

-(void)sendMessageDown:(UInt8*)uintSendData length:(int)intSendDataLength;

-(void)sendMessageInterval:(NSTimer *)paramTimer;
@end
