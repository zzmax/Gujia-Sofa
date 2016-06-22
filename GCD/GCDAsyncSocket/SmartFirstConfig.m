//
//  SmartFirstConfig.m
//  SmartHome
//
//  Created by ysamg on 15-2-9.
//  Copyright (c) 2015年 妙联. All rights reserved.
//

#import "SmartFirstConfig.h"
#import "GCDAsyncUdpSocket.h"
#import "SmartMlccUtil.h"
//#import "SmartCrcUtil.h"
//#import "smtiot.h"
//#import "HFSmartLink.h"
//#import "HFSmartLinkDeviceInfo.h"
#import <SystemConfiguration/CaptiveNetwork.h>

#import "JSONKit.h"


#define CONFIG_PORT_FROM_SERVER    64535
#define CONFIG_PORT_AP             64536
#define CONFIG_PORT_CUSTOM         64530
#define CONFIG_PORT_NEW_CUSTOM     64531
#define CONFIG_PORT_FROM_SERVER_KILL  64666

#define CONFIG_HOST                @"255.255.255.255"

#define AUTHMODE_OPEN               0x00
#define AUTHMODE_SHARED             0x01
#define AUTHMODE_AUTOSWITCH         0x02
#define AUTHMODE_WPA                0x03
#define AUTHMODE_WPAPSK             0x04
#define AUTHMODE_WPANONE            0x05
#define AUTHMODE_WPA2               0X06
#define AUTHMODE_WPA2PSK            0X07
#define AUTHMODE_WPA1WPA2           0X08
#define AUTHMODE_WPA1PSKWPA2PSK     0X09

@interface SHBlockObject : NSObject

@property(nonatomic, copy)void(^finishBlock)();

@end

@implementation SHBlockObject

@end

typedef enum {
    SmartConfigFirstOld,
    SmartConfigSecondOld,
    SmartConfigFirstNew,
    SmartConfigSecondNew
} SmartConfigStep;

@interface SmartFirstConfig()<GCDAsyncUdpSocketDelegate>


@property   (nonatomic , strong) GCDAsyncUdpSocket   *smartUdpSocket;
@property   (nonatomic , strong) NSArray             *realCommandArr;
@property   (nonatomic , strong) NSString            *realCommandFirstConfig;
@property   (nonatomic , strong) NSString            *staId;
@property   (nonatomic , strong) NSString            *staPwd;
@property   (nonatomic , assign) NSInteger           operType;

@property   (nonatomic , strong) NSTimer             *fristConfigTimer;
@property   (nonatomic , strong) NSString            *realMac;
@property   (nonatomic , strong) NSData              *fromServerAddress;


//------------SmartConfig模式------------
@property   (nonatomic , assign) NSInteger           smartConfigSendFlg;
@property   (nonatomic , assign) NSInteger           sendUdpLength;
@property   (nonatomic , assign) NSInteger           sendUdpIndex;
@property   (nonatomic , assign) int                 sendCrcL;
@property   (nonatomic , assign) int                 sendCrcH;
@property   (nonatomic , assign) NSInteger           staPwdLength;
@property   (nonatomic , strong) NSTimer             *smartConfigTimer;
@property   (nonatomic , strong) NSTimer             *smartSearchTimer;
@property   (nonatomic, assign) SmartConfigStep      smartConfigStep;

//------------new SmartConfig模式--------
@property   (nonatomic , assign) int newSmartConfigNumber;

//------------SmartConnect模式-----------

@end

@implementation SmartFirstConfig

- (void)dealloc
{
    [self smartSocketClose];
}

/*
 *  设备配置
 *  @param   staId           路由名称
 *  @param   staPwd          路由密码
 *  @param   realCommandArr  广播内容
 *  @param   operType        配置模式方式  4 首次配置  0：搜索设备
 */
-(void)doSmartFirstConfig: (NSString*)staId sspwd:(NSString*)staPwd realCommandArr:(NSArray *)realCommandArr andOperType:(NSInteger)operType
{
    self.staId = staId;
    self.staPwd = staPwd;
    self.realCommandArr = realCommandArr;
    self.operType = operType;
    
    //初始化socket
    [self creatUdp];
    
    switch (operType) {
        case 0:
            [self searchAllMac];
            break;
        case 4:
            [self newSmartConfig];
            break;
        default:
            break;
    }

}
-(void)searchAllMacTimer{
    NSData *sendData = [SmartMlccUtil makeMlccUtil:self.realCommandFirstConfig];
    [_smartUdpSocket sendData:sendData toHost:CONFIG_HOST port:CONFIG_PORT_AP withTimeout:-1 tag:1];

}

- (BOOL)connectServerWithHost:(NSString*)serverIP andPort:(uint16_t)prot{
    //初始化socket
    [self creatUdp];
    BOOL isConnected =  [_smartUdpSocket connectToHost:serverIP onPort:prot error:nil];
    return isConnected;
}

- (void)sendDataToServer:(NSString *)actionName{
    self.realCommandFirstConfig  =[NSString stringWithFormat:@"CodeName=GetUartData&Chn=0&Len=%d&UserBinaryData=%@",actionName.length,actionName];
    NSData *sendData = [SmartMlccUtil makeMlccUtil:self.realCommandFirstConfig];
    [_smartUdpSocket sendData:sendData  withTimeout:-1 tag:1];

}

-(void)searchAllMac{
    
    self.realCommandFirstConfig = @"CodeName=Search";
    if (_smartSearchTimer == nil) {
        _smartSearchTimer =  [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(searchAllMacTimer) userInfo:nil repeats:YES];
        [_smartSearchTimer fire];
    }
}

- (void)startSmartConfigTimer:(NSTimeInterval)timeInterval {
    _smartConfigTimer =  [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(smartconfigConnectStaAction) userInfo:nil repeats:NO];
}

- (void)smartconfigConnectStaAction {
    if (_smartConfigStep < SmartConfigFirstNew) {
        [self connectStaAction];
    } else {
        [self newConnectStaAction];
    }
}

/*
 *  设备路由客户端对接 smartConfig前期配置
 */
- (void)newConnectStaAction{
    char flag = 1;
    NSData *flagData = [NSData dataWithBytes: &flag length: 8];
    
    NSString *host = @"239.";
    if (self.newSmartConfigNumber <= 5) {
        //发送标识位
        NSLog(@"new smart config 标识位");
        host = [host stringByAppendingFormat:@"118.%d.%d", self.newSmartConfigNumber, self.newSmartConfigNumber];
    } else if (self.newSmartConfigNumber == 6) {
        //发送ssid长度
        NSLog(@"new smart config ssid 长度");
        host = [host stringByAppendingFormat:@"119.%d.%ld", self.newSmartConfigNumber, (long)self.staId.length];
    } else if (self.newSmartConfigNumber == 7) {
        //发送pass长度
        NSLog(@"new smart config pass 长度");
        host = [host stringByAppendingFormat:@"119.%d.%ld", self.newSmartConfigNumber, (long)self.staPwd.length];
    } else if (self.newSmartConfigNumber <= 7+self.staId.length) {
        //发送ssid
        NSLog(@"new smart config ssid");
        NSString *s = [self.staId substringWithRange:NSMakeRange(self.newSmartConfigNumber-8, 1)];
        host = [host stringByAppendingFormat:@"120.%d.%d", self.newSmartConfigNumber, [s characterAtIndex:0]];
    } else if (self.newSmartConfigNumber <= 7+self.staId.length+self.staPwd.length) {
        //发送pass
        NSLog(@"new smart config pass");
        NSString *s = [self.staPwd substringWithRange:NSMakeRange(self.newSmartConfigNumber-8-self.staId.length, 1)];
        host = [host stringByAppendingFormat:@"121.%d.%d", self.newSmartConfigNumber, [s characterAtIndex:0]];
    }
    [_smartUdpSocket sendData:flagData toHost:host port:CONFIG_PORT_NEW_CUSTOM withTimeout:-1 tag:self.newSmartConfigNumber];
    self.newSmartConfigNumber++;
    if (self.newSmartConfigNumber > 7+self.staId.length+self.staPwd.length) {
        self.newSmartConfigNumber = 1;
        _smartConfigStep ++;
        if (_smartConfigStep > SmartConfigSecondNew) {
            _smartConfigStep = SmartConfigFirstOld;
            [self startSmartConfigTimer:0.003];
        } else {
            [self startSmartConfigTimer:0.01];
        }
    } else {
        [self startSmartConfigTimer:0.01];
    }
}

-(void)connectStaAction
{
    NSString *sendUdpforIDorPwd = @"";
    
    //SSID标志位
    if (self.smartConfigSendFlg <= 3) {
        
        NSLog(@"SSID标志位");
        self.sendUdpIndex = 0;
        char flag = 111;
        NSData *flagData = [NSData dataWithBytes: &flag length: 20];
        [_smartUdpSocket sendData:flagData toHost:CONFIG_HOST port:CONFIG_PORT_CUSTOM withTimeout:-1 tag:1];
        
    }else if (self.smartConfigSendFlg <= self.sendUdpLength && self.smartConfigSendFlg > 3){
        
        //SSID
        NSLog(@"SSID");
        sendUdpforIDorPwd = [self.staId substringWithRange:NSMakeRange(self.sendUdpIndex, 1)];
        
        int ssidLen = [sendUdpforIDorPwd characterAtIndex:0];
        
        char ssid = ssid;
        
        NSData *ssidData = [NSData dataWithBytes: &ssid length: ssidLen];
        if (ssidLen == 0) {
            
            NSString *strNil = @"";
            const char *da =[strNil cStringUsingEncoding:NSASCIIStringEncoding];
            ssidData = [NSData dataWithBytes: &da length:0];
            
        }
        [_smartUdpSocket sendData:ssidData toHost:CONFIG_HOST port:CONFIG_PORT_CUSTOM withTimeout:-1 tag:2];
        
        self.sendUdpIndex++;
        
    }else if (self.smartConfigSendFlg <= self.sendUdpLength + 3 && self.smartConfigSendFlg > self.sendUdpLength){
        
        NSLog(@"password标志位");
        //password标志位
        char flag = 222;
        NSData *flagData = [NSData dataWithBytes: &flag length: 21];
        self.sendUdpIndex = 0;
        [_smartUdpSocket sendData :flagData toHost:CONFIG_HOST port:CONFIG_PORT_CUSTOM withTimeout:-1 tag:3];
        
    }else if (self.smartConfigSendFlg <= (self.sendUdpLength + 3 +self.staPwdLength) && self.smartConfigSendFlg > self.sendUdpLength + 3){
        
        //password
        NSLog(@"password");
        sendUdpforIDorPwd = [self.staPwd substringWithRange:NSMakeRange(self.sendUdpIndex, 1)];
        
        int pwdLen = [sendUdpforIDorPwd characterAtIndex:0];
        char pwd = pwd;
        NSData *pwdData = [NSData dataWithBytes: &pwd length: pwdLen];
        
        if (pwdLen == 0) {
            
            NSString *strNil = @"";
            const char *da =[strNil cStringUsingEncoding:NSASCIIStringEncoding];
            pwdData = [NSData dataWithBytes: &da length:0];
        }
        
        [_smartUdpSocket sendData :pwdData toHost:CONFIG_HOST port:CONFIG_PORT_CUSTOM withTimeout:-1 tag:4];
        
        self.sendUdpIndex++;
        
    }else if (self.smartConfigSendFlg <= (self.sendUdpLength + 6 +self.staPwdLength) && self.smartConfigSendFlg > (self.sendUdpLength +self.staPwdLength)){
        
        //结束标志位
        NSLog(@"结束标志位");
        char flag = 222;
        NSData *flagData = [NSData dataWithBytes: &flag length: 22];
        [_smartUdpSocket sendData :flagData toHost:CONFIG_HOST port:CONFIG_PORT_CUSTOM withTimeout:-1 tag:5];
        
    }else if (self.smartConfigSendFlg <= (self.sendUdpLength + 8 +self.staPwdLength) && self.smartConfigSendFlg > (self.sendUdpLength + 6 +self.staPwdLength)){
        
        char crc = 223;
        //crc校验码
        NSLog(@"crc校验码");
        NSData *crcData = nil;
        if (self.smartConfigSendFlg == (self.sendUdpLength + 8 +self.staPwdLength) && self.smartConfigSendFlg) {
            //校验码低位包
            crcData = [NSData dataWithBytes: &crc length:self.sendCrcL + 20];
        }else{
            //校验码高位包
            crcData = [NSData dataWithBytes: &crc length:self.sendCrcH + 20];
        }
        
        [_smartUdpSocket sendData :crcData toHost:CONFIG_HOST port:CONFIG_PORT_CUSTOM withTimeout:-1 tag:6];
        
    }
    
    if (self.smartConfigSendFlg == (self.sendUdpLength + 12 +self.staPwdLength)) {
        
        self.smartConfigSendFlg = 1;
        _smartConfigStep++;
        if (_smartConfigStep == SmartConfigFirstNew) {
            [self startSmartConfigTimer:0.5];
        } else {
            [self startSmartConfigTimer:0.003];
        }
        return;
    }
    
    self.smartConfigSendFlg ++;
    [self startSmartConfigTimer:0.003];
}

/*
 *  配置模式4 smartConfig组播
 */
- (void)newSmartConfig {
    self.newSmartConfigNumber = 1;
    [self newSmartConfigAction];
}

- (void)newSmartConfigAction {
    char flag = 1;
    NSData *flagData = [NSData dataWithBytes: &flag length: 8];
    
    NSString *host = @"239.";
    if (self.newSmartConfigNumber <= 5) {
        //发送标识位
        NSLog(@"new smart config 标识位");
        host = [host stringByAppendingFormat:@"118.%d.%d", self.newSmartConfigNumber, self.newSmartConfigNumber];
    } else if (self.newSmartConfigNumber == 6) {
        //发送ssid长度
        NSLog(@"new smart config ssid 长度");
        host = [host stringByAppendingFormat:@"119.%d.%ld", self.newSmartConfigNumber, (long)self.staId.length];
    } else if (self.newSmartConfigNumber == 7) {
        //发送pass长度
        NSLog(@"new smart config pass 长度");
        host = [host stringByAppendingFormat:@"119.%d.%ld", self.newSmartConfigNumber, (long)self.staPwd.length];
    } else if (self.newSmartConfigNumber <= 7+self.staId.length) {
        //发送ssid
        NSLog(@"new smart config ssid");
        NSString *s = [self.staId substringWithRange:NSMakeRange(self.newSmartConfigNumber-8, 1)];
        host = [host stringByAppendingFormat:@"120.%d.%d", self.newSmartConfigNumber, [s characterAtIndex:0]];
    } else if (self.newSmartConfigNumber <= 7+self.staId.length+self.staPwd.length) {
        //发送pass
        NSLog(@"new smart config pass");
        NSString *s = [self.staPwd substringWithRange:NSMakeRange(self.newSmartConfigNumber-8-self.staId.length, 1)];
        host = [host stringByAppendingFormat:@"121.%d.%d", self.newSmartConfigNumber, [s characterAtIndex:0]];
    }
    [_smartUdpSocket sendData:flagData toHost:host port:CONFIG_PORT_NEW_CUSTOM withTimeout:-1 tag:self.newSmartConfigNumber];
    self.newSmartConfigNumber++;
    if (self.newSmartConfigNumber > 7+self.staId.length+self.staPwd.length) {
        self.newSmartConfigNumber = 1;
    }
    if (_smartConfigTimer == nil) {
        _smartConfigTimer =  [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(newSmartConfigAction) userInfo:nil repeats:YES];
    }
}

/*
 *  创建socket
 */
-(void)creatUdp
{
    if (!_smartUdpSocket) {
        
        _smartUdpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];

        NSError *socketError=nil;
        
        //广播设置
        [_smartUdpSocket enableBroadcast:YES error:&socketError];
        
        //服务侦听
        [self bindUdpServer];
        //NSLog(@"---------------creatUdp-----------%@--------",socketError);
    }
}

/*
 *  关闭socket 同时
 */
-(void)smartSocketClose
{
    if (_smartUdpSocket!=nil) {
        [_smartUdpSocket close];
        _smartUdpSocket.delegate = nil;
        _smartUdpSocket = nil;
    }
    
    if (self.fristConfigTimer!=nil) {
        [self.fristConfigTimer invalidate];
        self.fristConfigTimer = nil;
    }
    
    if (self.smartConfigTimer!=nil) {
        [self.smartConfigTimer invalidate];
        self.smartConfigTimer = nil;
    }
    if (self.smartSearchTimer!=nil) {
        [self.smartSearchTimer invalidate];
        self.smartSearchTimer = nil;
    }
}

/*
 *  服务侦听
 */
- (void)bindUdpServer
{
    NSError *serverError = nil;

    if (![_smartUdpSocket bindToPort:CONFIG_PORT_FROM_SERVER error:&serverError])
    {
        NSLog(@"+++++++++++++++++++++++%@++++++++++++++",serverError);
        return;
    }
    
    if (![_smartUdpSocket beginReceiving:nil])
    {
        [self smartSocketClose];
        
        return;
    }
    //NSLog(@"Udp Echo server started on port %hu", [_smartUdpSocket localPort]);
    
}

/*
 *  首次配置udp发包
 */
-(void)firstConfigTask
{
    NSLog(@"===========首次配置udp发包================");
    [_smartUdpSocket sendData:[SmartMlccUtil makeMlccUtil:self.realCommandFirstConfig] toAddress:self.fromServerAddress withTimeout:-1 tag:10];
}

/*
 *
 * 返回字符串转换成json
 * @param   result
 * @return  dicJson
 */
-(NSDictionary*)jsonFromResult:(NSString*)result
{
    NSString *resultTemp = result;
    resultTemp = [resultTemp stringByReplacingOccurrencesOfString:@"&" withString:@"\",\""];
    resultTemp = [resultTemp stringByReplacingOccurrencesOfString:@"=" withString:@"\":\""];
    resultTemp = [NSString stringWithFormat:@"{\"%@\"}",resultTemp];
    
    NSData *jsonDta = [resultTemp dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dicJson = [jsonDta objectFromJSONData];
    
    return dicJson;

}

/*
 * 获取的MAC地址
 *
 */
- (NSString *)currentWifiBSSID {
    // Does not work on the simulator.
    NSString *bssid = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info[@"BSSID"]) {
            bssid = info[@"BSSID"];
        }
    }
    __block NSString *newBSSID = @"";
    NSArray *arrays =[bssid componentsSeparatedByString:@":"];
    [arrays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *atom = (NSString *)obj;
        if (atom.length == 1) {
            newBSSID = [newBSSID stringByAppendingString:@"0"];
        }
        newBSSID = [newBSSID stringByAppendingString:atom];
        if (idx != arrays.count-1) {
            newBSSID = [newBSSID stringByAppendingString:@":"];
        }
    }];
    
    return [newBSSID uppercaseString];
}

#pragma GCDAsyncUdpSocketDelegate
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    //NSLog(@"-------------收到数据------------start");
    NSString    *result = [SmartMlccUtil getReturnCommand:data];
    
    //NSLog(@"==========result================%@=====",result);
    self.fromServerAddress = address;
   
    if (result==nil||[result isEqual:[NSNull null]]) {
        return;
    }

    NSDictionary *dicResult = [self jsonFromResult:result];
    
    
    if (self.operType ==0)
    {
        if ([self.fristConfigDelegate respondsToSelector:@selector(onSmartSearchSuccess:)]) {
            [self.fristConfigDelegate onSmartSearchSuccess:dicResult];
        }
    }
    else if ([dicResult[@"CodeName"] isEqualToString:@"smart_connected"])
    {
        //销毁计数器
        [self.smartConfigTimer invalidate];
        self.smartConfigTimer = nil;
        
        self.realMac = dicResult[@"mac"];
        
        NSString * codeNameStr = [NSString stringWithFormat:@"CodeName=fc_ml_platform&mac=%@&pf_url=www.51miaomiao.com&pf_port=28001&pf_ip1=114.215.149.63&pf_ip2=122.225.196.132",self.realMac];
        
        self.realCommandFirstConfig = codeNameStr;
        
        if (!self.fristConfigTimer) {
        
            self.fristConfigTimer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(firstConfigTask) userInfo:nil repeats:YES];
            [self.fristConfigTimer fire];
        }
        
    }
    else if ([dicResult[@"CodeName"] isEqualToString:@"fc_ml_platform_ack"])
    {
        if (self.fristConfigTimer) {
            [self.fristConfigTimer invalidate];
            self.fristConfigTimer = nil;
        }
        //完成首次配置,执行首次完成udp确认包
        self.realCommandFirstConfig = [NSString stringWithFormat:@"CodeName=fc_complete&mac=%@",self.realMac];
        self.fristConfigTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(firstConfigTask) userInfo:nil repeats:YES];
        [self.fristConfigTimer fire];
    }
    else if([dicResult[@"CodeName"] isEqualToString:@"fc_complete_ack"])
    {
        if (self.fristConfigTimer) {
            [self.fristConfigTimer invalidate];
            self.fristConfigTimer = nil;
        }
        self.realCommandFirstConfig = [NSString stringWithFormat:@"CodeName=fc_complete_fin&mac=%@",self.realMac];
        [self firstConfigTask];
        sleep(1);
        
        [self smartSocketClose];
        
        if (!self.fristConfigDelegate) {
            return;
        }
        if ([self.fristConfigDelegate respondsToSelector:@selector(onSmartFirstConfigSuccess:)]) {
            [self.fristConfigDelegate onSmartFirstConfigSuccess:self.realMac];
        }
        
    }
   // NSLog(@"-------------收到数据------------end");

}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error
{
    NSLog(@"=========didNotConnect==========");
    if (!self.fristConfigDelegate) {
        [self smartSocketClose];
        return;
    }
    [self smartSocketClose];
    if ([self.fristConfigDelegate respondsToSelector:@selector(onSmartFirstConfigFailure)]) {
        [self.fristConfigDelegate onSmartFirstConfigFailure];
    }
}


@end
