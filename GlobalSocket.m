//
//  GlobalSocket.m
//  iSmartHome
//
//  Created by admin on 15/12/19.
//  Copyright © 2015年 zzmax. All rights reserved.
//

#import "GlobalSocket.h"


@interface GlobalSocket ()
{
    
    NSTimeInterval socketTimeOut;
    NSTimer *sendMessageTimer;
    
    NSString *host;
    uint16_t port;
    GCDAsyncSocket *socket;
    UInt8 inputBuffer[INPUTBUFFERSIZE];
    int  sendDataLength;
    
    BOOL isConnected;
    
}

@end

@implementation GlobalSocket

NSString* MBNonEmptyString(id obj){
    if (obj == nil || obj == [NSNull null] ||
        ([obj isKindOfClass:[NSString class]] && [obj length] == 0)) {
        return @"";
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        return MBNonEmptyString([obj stringValue]);
    }
    
    return obj;
}

- (UInt8 *)getInputBuffer
{
    return inputBuffer;
}

- (void)setHost:(NSString *)aHost
{
    host = aHost;
}

- (NSString *)getHost
{
    return host;
}

- (void)setPort:(NSString *) aPort
{
    port = (uint16_t)[aPort intValue];
}

- (int)getPort
{
    return port;
}


/**
 *  set the value of inputBuffer form another class
 *
 *  @param order         : the position of data in inputBuffer
 *  @param anInputBuffer : the value
 */
- (void)setInputBuffer:(int)order and:(UInt8)anInputBuffer
{
//    inputBuffer  = anInputBuffer;
    inputBuffer[order] = anInputBuffer;
}

- (GCDAsyncSocket *)getSocket
{
    return socket;
}

- (instancetype)init
{
    if (self = [super init]) {
//        someProperty = [[NSString alloc] initWithString:@"Default Property Value"];
        socketTimeOut = 100;
        _sofaTemp = [[NSMutableArray alloc]initWithCapacity:3];
        [self initNetworkCommunication];
//        [self initControlMessage];
        [self sendMessageDown:inputBuffer length:sendDataLength];
    }
    return self;
}


+ (id)sharedGlobalSocket
{
    static GlobalSocket *sharedGlobalSocket = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGlobalSocket = [[GlobalSocket alloc] init];
    });
    
    return sharedGlobalSocket;
}
//static UInt8 inputBuffer[INPUTBUFFERSIZE];






#pragma mark - socket part to send and recieve msg from server
/**
 *  This method is to intiate the message array that we will send to control part
// */
//-(void)initControlMessage
//{
//    sendDataLength=8;
//    inputBuffer[0]=0x21;    //message ID
//    inputBuffer[1]=0x02;    //?
//    inputBuffer[2]=0x03;    //?
//    inputBuffer[3]=0x01;    //data that control the sofa
//    inputBuffer[4]=0x00;
//    inputBuffer[5]=0x00;
//    inputBuffer[6]=0x0d;
//    inputBuffer[7]=0x0a;
//}
//
///**
// *  This method is to intiate the message array that we will send to sensors to aquire data
// */
//-(void)initAcquireSensorDataMessage
//{
//    sendDataLength=8;
//    inputBuffer[0]=0x24;
//    inputBuffer[1]=0x02;
//    inputBuffer[2]=0x03;
//    inputBuffer[3]=0x02;
//    inputBuffer[4]=0x00;
//    inputBuffer[5]=0x00;
//    inputBuffer[6]=0x0d;
//    inputBuffer[7]=0x0a;
//}

/**
 *  Connect to the server
 *
 *  @param sender : Cnnection button
 */
//- (void)connectServer
//{
//    [self initNetworkCommunication];
//    [self initControlMessage];
//    [self sendMessageDown:inputBuffer length:_sendDataLength];
//}

- (void) initHealthMsg
{
    self.bloodO2 = @"";
    self.bloodPressure = @"";
    self.bodyTemp = @"";
    self.heartRate = @"";
    self.weight = @"";
}
/**
 *  This method is to intiate the communication between the server and the
 terminator via socket.
 */
-(void)initNetworkCommunication
{
//    host = @"192.168.10.250";
//    host = @"";
    //port = (uint16_t)[@"8080" intValue];
    
    //    _messageLabel.text = _host;
    [self getSavedWifiInfo];
    socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    socket.delegate = self;
    NSError *err = nil;
    BOOL connState=[socket connectToHost:host onPort:port error:&err];
    if(!connState)
    {
        _message = err.description;//[_messageLabel.text stringByAppendingString:err.description ];
        NSLog(@"连接服务器：%@,%d 不成功！！！",host,port);
    }
    else
    {
        _message = @"连接成功";
        NSLog(@"连接服务器：%@,%d 成功",host,port);
    }
    
    [socket readDataWithTimeout:socketTimeOut tag:0];
}

-(void)getSavedWifiInfo
{
    // Establish Core Data
    CoreDataHelper *dataHelper = [[CoreDataHelper alloc] init];
    dataHelper.entityName = @"WifiInfo";
    dataHelper.defaultSortAttribute = @"ssid";
    // Setup data
    [dataHelper setupCoreData];

    // Test listing all FailedBankInfos from the store
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSError *error;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WifiInfo"
                                              inManagedObjectContext:dataHelper.context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [dataHelper.context executeFetchRequest:fetchRequest error:&error];
    for (WifiInfo *res in fetchedObjects) {
        NSLog(@"-------------------");
        NSLog(@"ip: %@", res.ip);
        NSLog(@"port: %@", res.port.stringValue);
        NSLog(@"ssid: %@", res.ssid);
        NSLog(@"psd: %@", res.psd);
        NSLog(@"connectionTime: %@", res.connectionTime);
        NSLog(@"state: %@", res.state);
        
        if ([MBNonEmptyString([self getWifiInfo][@"SSID"]) isEqualToString:res.ssid]) {
            host = res.ip;
            NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
            port = [[formatter numberFromString:res.port.stringValue] unsignedShortValue];
        }
    }
}

/**
 *  Set the timer for the message sender.
 Per 400ms we will send a message.
 */
-(void)startSendMessageTimer
{
    sendMessageTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(sendMessageInterval:) userInfo:nil repeats:YES ];
    
}

/**
 *  Stop the timer 400ms and stop sending the message.
 */
-(void)stopSendMessgeTimer
{
    if (sendMessageTimer != nil)
    {
        [sendMessageTimer invalidate];
    }
    
}

/**
 *  Send the message to server via socket.
 *
 *  @param uintSendData
 *  @param intSendDataLength
 */
-(void)sendMessageDown:(UInt8*)uintSendData length:(int)intSendDataLength
{
    
    NSData *sendData = [[NSData alloc] initWithBytes:inputBuffer length:intSendDataLength];
    [socket writeData:sendData withTimeout:-1 tag:0];
    [socket readDataWithTimeout:socketTimeOut tag:0];
}

-(void)sendMessageDown:(NSString *)sendDataStr
{
//    if ([socket connectToHost:host onPort:port error:nil]) {
        NSData *sendData = [SmartMlccUtil makeTcpCommandData:sendDataStr];
        [socket writeData:sendData withTimeout:-1 tag:0];
     NSLog(@"发送的信息：%@",sendDataStr);
//    }
//    else
//        NSLog(@"Not connected...");
//    NSString *result = [SmartMlccUtil getReturnCommand:data];
//    NSString *command = [SmartMlccUtil parseTcpCommandData:result];
//    [socket readDataWithTimeout:socketTimeOut tag:0];
}

/**
 *  Send message according to the timer.
 *
 *  @param paramTimer : The timmer setted in startSendMessageTimer, 400ms.
 */
-(void)sendMessageInterval:(NSTimer *)paramTimer
{
    NSLog(@"Time excute....");
    if (_btnS1)//SOFA 推杆升按键按下
    {
//        [self initControlMessage];
//        inputBuffer[4]=0x01;
//        [self sendMessageDown:inputBuffer length:sendDataLength];
        [self sendMessageDown:@"F1F101020100047E"];
    }
    else if (_btnS2)//SOFA 推杆降按键按下
    {
//        [self initControlMessage];
//        inputBuffer[4]=0x02;
//        [self sendMessageDown:inputBuffer length:sendDataLength];
        [self sendMessageDown:@"F1F101020200057E"];
    }
    else
    {
//        [self initControlMessage];
        [self sendMessageDown:inputBuffer length:sendDataLength];
    }
}


/**
 *  Reload the method of CocoaSocket to read data.
 *
 *  @param sock : socket
 *  @param data : data we will read
 *  @param tag
 */
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *ip = [sock connectedHost];
    uint16_t aPort = [sock connectedPort];
    NSString *commands;
    if ([ip isEqualToString:host] && port == aPort)
    {
        NSString *result = [SmartMlccUtil getReturnCommand:data];
        commands = [SmartMlccUtil parseTcpCommandData:result];
        NSLog(@"返回信息=%@",commands);
    }
    
    [sock readDataWithTimeout:-1 tag:200];
    
    NSArray* cmdsWithoutStart = [commands componentsSeparatedByString: @"f2f2"];//split the msg by the start "f2f2" and throw away the "f2f2"
    
    
    for (NSString *aCmd in cmdsWithoutStart) {
        if ( [aCmd length] != 0  &&
                            ([[aCmd substringWithRange:NSMakeRange(12, 2)] isEqualToString:@"7e"]
                                ||
                             [[aCmd substringWithRange:NSMakeRange(14, 2)] isEqualToString:@"7e"]//称重
                             )
            )
        {
            NSLog(@"one command = %@",aCmd);
            NSString *cmdCode=[aCmd substringWithRange:NSMakeRange(0, 4)];
            NSLog(@"cmdCode=%@",cmdCode);
            if ([cmdCode isEqualToString:@"0103"]) {//电热毯信息
                NSString *strElectricBlanket;
                NSString *str=[aCmd substringWithRange:NSMakeRange(4, 2)];//电热毯开关信息
                if([str isEqualToString:@"00"])
                {
                    self.sofaTemp[0] = @"关";
                }
                else if ([str isEqualToString:@"01"]){
                    NSString *value=[aCmd substringWithRange:NSMakeRange(6, 2)];//电热毯温度值信息
                    NSString *value1=[aCmd substringWithRange:NSMakeRange(8, 2)];//电热毯档位信息
                    
                    NSString *value2=[NSString stringWithFormat:@"%lu",strtoul([value UTF8String],0,16)];
                    int value3=[[NSString stringWithFormat:@"%lu",strtoul([value1 UTF8String],0,16)] intValue];
                    
                    strElectricBlanket = [NSString stringWithFormat:@"开,温度%@,档位%d",value2,value3];
                    //                    [self.temp addObject:[NSString stringWithFormat: @"%d",value]];
                    //                    [self.temp addObject:[NSString stringWithFormat: @"%d",value1]];
                    self.sofaTemp[0] = value2;
                    self.sofaTemp[1] = value1;
                }
                
            }
            if ([cmdCode isEqualToString:@"0204"]) {//称重信息
                NSString *value=[aCmd substringWithRange:NSMakeRange(6, 2)];//重量kg高位
                NSString *value1=[aCmd substringWithRange:NSMakeRange(8, 2)];//重量kg低位
                NSString *value2=[aCmd substringWithRange:NSMakeRange(10, 2)];//重量g，g的值仅发送百位和十位数，最大99，即990g
                
                float value4=[[NSString stringWithFormat:@"%lu",strtoul([value UTF8String],0,16)] floatValue];
                float value5=[[NSString stringWithFormat:@"%lu",strtoul([value1 UTF8String],0,16)] floatValue];
                float value6=[[NSString stringWithFormat:@"%lu",strtoul([value2 UTF8String],0,16)] floatValue];
                
                float fWeighting= value4 * 100 + value5 + value6 / 100;
                
                NSString *strWeighting = [NSString stringWithFormat:@"%.1f",fWeighting];
                self.weight = strWeighting;
            }
            
            cmdCode =[aCmd substringWithRange:NSMakeRange(0, 6)];
            if ([cmdCode isEqualToString:@"030302"]) {//血氧，脉搏信息
                NSString *value=[aCmd substringWithRange:NSMakeRange(6, 2)];//
                NSString *value1=[aCmd substringWithRange:NSMakeRange(8, 2)];//
                
                int value2=[[NSString stringWithFormat:@"%lu",strtoul([value UTF8String],0,16)] intValue];
                int value3=[[NSString stringWithFormat:@"%lu",strtoul([value1 UTF8String],0,16)] intValue];
                
                self.bloodO2 = [NSString stringWithFormat:@"%d", value2];
                self.heartRate = [NSString stringWithFormat:@"%d", value3];
                
            }
            
            if ([cmdCode isEqualToString:@"030301"]) {//体温信息
                NSString *value=[aCmd substringWithRange:NSMakeRange(6, 2)];//
                NSString *value1=[aCmd substringWithRange:NSMakeRange(8, 2)];//
                
                float value2=[[NSString stringWithFormat:@"%lu",strtoul([value UTF8String],0,16)] floatValue];
                float value3=[[NSString stringWithFormat:@"%lu",strtoul([value1 UTF8String],0,16)] floatValue];
                
                
                float fTemperature= value2 + value3/10;
                
                NSString *strTemperature = [NSString stringWithFormat:@"%.1f",fTemperature];
                self.bodyTemp = strTemperature;
                
            }
            //        if ([cmd isEqualToString:@"0303"]) {//血压实时测量
            //            //Real blood pressure measure
            //
            //            NSString *value=[command substringWithRange:NSMakeRange(10, 2)];//电热毯温度值信息
            //             NSString *value1=[command substringWithRange:NSMakeRange(12, 2)];//电热毯档位信息
            //
            //            self.bloodPressure = value;
            //        }
            if ([cmdCode isEqualToString:@"030303"] || [cmdCode isEqualToString:@"030304"]) {//血压实时测量 || 血压测试完成
                NSString *value=[aCmd substringWithRange:NSMakeRange(6, 2)];//
                NSString *value1=[aCmd substringWithRange:NSMakeRange(8, 2)];//
                
                int value2=[[NSString stringWithFormat:@"%lu",strtoul([value UTF8String],0,16)] intValue];
                int value3=[[NSString stringWithFormat:@"%lu",strtoul([value1 UTF8String],0,16)] intValue];
                
                
                NSString *strbloodPressure;
                strbloodPressure = [NSString stringWithFormat:@"%d/%d",value2,value3];//收缩压/舒张压
                self.bloodPressure = strbloodPressure;
                
            }
            if ([cmdCode isEqualToString:@"030305"]) {//血压测试异常
                
                self.bloodPressure = @"测试异常";
                
            }
            
            [socket readDataWithTimeout:100 tag:0];
            
        }
    }
//    NSString *str=@"返回信息:";
//    NSString *hexStr=@"";
//    int lengthReceiveMessage=(int)[data length];
//    unsigned char buffer[512];
//    hexStr = [NSString stringWithFormat:@"Length: %d ",lengthReceiveMessage];
//    str=[str stringByAppendingString:hexStr];
//    Byte *btemp=(Byte *)[data bytes];
//    
//    for (int i =0; i<lengthReceiveMessage;i++)
//    {
//        buffer[i]=btemp[i];
//        hexStr = [NSString  stringWithFormat:@"0x%x ",buffer[i]];
//        str=[str stringByAppendingString:hexStr];
//    }
//    //    self.messageLabel.text =str;
//    self.message = str;
//    NSLog(@"%@",self.message);
//    
//    ////////////
//    NSString *strState=@"";
//    NSString *temp=@"";
//    
//    if (lengthReceiveMessage==18)
//    {
//        if((buffer[0]== 0x13) && (buffer[1]== 0x02))
//        {
//            
//            if(buffer[4] & 0x01)
//            {
//                temp=@"Yellow light On...";
//            }
//            else
//            {
//                temp=@"Yellow light Off...";
//            }
//            
//            strState = [strState stringByAppendingString:temp];
//            strState = [strState stringByAppendingString:@"\n"];
//            
//            if(buffer[4] & 0x02)
//            {
//                temp=@"Green light On...";
//            }
//            else
//            {
//                temp=@"Green light Off...";
//            }
//            
//            strState = [strState stringByAppendingString:temp];
//            strState = [strState stringByAppendingString:@"\n"];
//            
//            if(buffer[4] & 0x04)
//            {
//                temp=@"AC light On...";
//            }
//            else
//            {
//                temp=@"AC light Off...";
//            }
//            
//            strState = [strState stringByAppendingString:temp];
//            strState = [strState stringByAppendingString:@"\n"];
//            
//            if(buffer[4] & 0x08)
//            {
//                temp=@"S5 light On...";
//            }
//            else
//            {
//                temp=@"S5 light Off...";
//            }
//            
//            strState = [strState stringByAppendingString:temp];
//            strState = [strState stringByAppendingString:@"\n"];
//            
//            if(buffer[4] & 0x10)
//            {
//                temp=@"S1 POWER light On...";
//            }
//            else
//            {
//                temp=@"S1 POWER light Off...";
//            }
//            
//            strState = [strState stringByAppendingString:temp];
//            strState = [strState stringByAppendingString:@"\n"];
//            
//            if(buffer[4] & 0x20)
//            {
//                temp=@"S9 LEG LOCK light On...";
//            }
//            else
//            {
//                temp=@"S9 LEG LOCK light Off...";
//            }
//            strState = [strState stringByAppendingString:temp];
//            strState = [strState stringByAppendingString:@"\n"];
//            
//            if(buffer[4] & 0x40)
//            {
//                temp=@"S13 BACK LOCK light On...";
//            }
//            else
//            {
//                temp=@"S13 BACK LOCK light Off...";
//            }
//            strState = [strState stringByAppendingString:temp];
//            strState = [strState stringByAppendingString:@"\n"];
//            
//            if(buffer[4] & 0x80)
//            {
//                temp=@"S17 ALL LOCK light On...";
//            }
//            else
//            {
//                temp=@"S17 ALL LOCK light Off...";
//            }
//            strState = [strState stringByAppendingString:temp];
//            strState = [strState stringByAppendingString:@"\n"];
//        }
//        //        self.stateText.text=strState;
//    }
//    if(lengthReceiveMessage==9)//electric blanket state
//    {
//        if ((buffer[0]== 0x12) && (buffer[1]== 0x02) && (buffer[3]== 0x01))
//        {
//            Byte electricBlanketByte[2];
//            
//            NSString *strElectricBlanket;
//            switch (buffer[4])
//            {
//                case 0x00:
//                    strElectricBlanket = @"关";
//                    break;
//                case 0x01:
//                    electricBlanketByte[0]=buffer[5];
//                    electricBlanketByte[1]=buffer[6];
//                    int value=(int)electricBlanketByte[0];
//                    int value1=(int)electricBlanketByte[1];
//                    strElectricBlanket = [NSString stringWithFormat:@"开,温度%d,档位%d",value,value1];
////                    [self.temp addObject:[NSString stringWithFormat: @"%d",value]];
////                    [self.temp addObject:[NSString stringWithFormat: @"%d",value1]];
//                    self.sofaTemp[0] = [NSString stringWithFormat: @"%d",value];
//                    self.sofaTemp[1] = [NSString stringWithFormat: @"%d",value1];
//
//                    break;
//            }
////            self.message = strElectricBlanket;
//        }
//        
//        
//    }
//    //Measure  data
//    if(lengthReceiveMessage==11)
//    {
//        //body temperature
//        if ((buffer[0]== 0x42) && (buffer[1]== 0x02) && (buffer[3]== 0x07) &&(buffer[4]== 0x01))
//        {
//            Byte tempteratureByte[2];
//            tempteratureByte[0]=buffer[5];
//            tempteratureByte[1]=buffer[6];
//            int value=(int)tempteratureByte[0];
//            int value1=(int)tempteratureByte[1];
//            float fTemperature=(float)value+((float)value1)/10;
//            
//            NSString *strTemperature = [NSString stringWithFormat:@"%.1f",fTemperature];
//            self.bodyTemp = strTemperature;
//        }
//        
//        //pulse
//        if ((buffer[0]== 0x42) && (buffer[1]== 0x02) && (buffer[3]== 0x07) &&(buffer[4]== 0x02))
//        {
//            Byte tempteratureByte[2];
//            tempteratureByte[0]=buffer[5];
//            tempteratureByte[1]=buffer[6];
//            int value0=(int)tempteratureByte[0];
//            int value1=(int)tempteratureByte[1];
//            
//            self.bloodO2 = [NSString stringWithFormat:@"%d",value0];
//            self.heartRate = [NSString stringWithFormat:@"%d ",value1];
//            
//        }
//        
//        //Real blood pressure measure
//        if ((buffer[0]== 0x42) && (buffer[1]== 0x02) && (buffer[3]== 0x07) &&(buffer[4]== 0x04) && (buffer[5]== 0x01) )
//        {
//            Byte tempteratureByte[2];
//            tempteratureByte[0]=buffer[6];
//            
//            int value0=(int)tempteratureByte[0];
////            NSString *strTemperature = [NSString stringWithFormat:@"实时压力%dmmHg",value0];
//            
//            self.bloodPressure = [NSString stringWithFormat:@"%d",value0];
//        }
//        //blood pressure
//        if ((buffer[0]== 0x42) && (buffer[1]== 0x02) && (buffer[3]== 0x07) &&(buffer[4]== 0x04) && (buffer[5]== 0x02) )
//        {
//            Byte tempteratureByte[2];
//            tempteratureByte[0]=buffer[6];
//            tempteratureByte[1]=buffer[7];
//            int value0=(int)tempteratureByte[0];
//            int value1=(int)tempteratureByte[1];
//            
//            NSString *strTemperature;
//            switch (buffer[8])
//            {
//                case 0x00:
//                    strTemperature = [NSString stringWithFormat:@"%d/%d",value0,value1];//收缩压/舒张压
//                    break;
//                case 0x03:
//                    strTemperature = [NSString stringWithFormat:@"%d/%d",value0,value1];
//                    // strTemperature = @"无错误";
//                    break;
//                case 0x06:
//                    strTemperature = @"袖带过松";
//                    break;
//                case 0x07:
//                    strTemperature = @"漏气";
//                    break;
//                case 0x09:
//                    strTemperature = @"若信号";
//                    break;
//                case 0x10:
//                    strTemperature = @"超范围";
//                    break;
//                case 0x11:
//                    strTemperature = @"过分运动";
//                    break;
//                case 0x12:
//                    strTemperature = @"过压";
//                    break;
//                case 0x13:
//                    strTemperature = @"信号饱和";
//                    break;
//                case 0x14:
//                    strTemperature = @"漏气";
//                    break;
//                case 0x15:
//                    strTemperature = @"系统错误";
//                    break;
//                case 0x19:
//                    strTemperature = @"超时";
//                    break;
//                    
//                default:
//                    break;
//            }
//            self.bloodPressure = strTemperature;
//        }
//    }
//    if (lengthReceiveMessage==13)
//    {
//        //weighting
//        if ((buffer[0]== 0x42) && (buffer[1]== 0x02) && (buffer[3]== 0x01))
//        {
//            Byte weightingByte[3];
//            weightingByte[0]=buffer[5];
//            weightingByte[1]=buffer[6];
//            weightingByte[2]=buffer[7];
//            int value=(int)weightingByte[0];
//            int value1=(int)weightingByte[1];
//            int value2=(int)weightingByte[2];
//            float fWeighting=(float)value+((float)value1)+((float)value2)/100;
//            
//            NSString *strWeighting = [NSString stringWithFormat:@"%.1f",fWeighting];
//            self.weight = strWeighting;
//        }
//    }
//
//    //    [self.stateText insertText:str];
//    [socket readDataWithTimeout:100 tag:0];
}

/**
 *  Get the SSID,Mac,Password,etc
 *
 *  @return a dictionary of info wifi
 */
- (NSDictionary *)getWifiInfo
{
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            return networkInfo;
        }
    }
    
    return nil;
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"连接成功");
    isConnected=YES;
    [sock readDataWithTimeout:-1 tag:200];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"连接失败 %@", err);
    _message = @"连接失败";
    // 断线重连
    isConnected=NO;
    [sock connectToHost:host onPort:port withTimeout:60 error:nil];
}

- (void) disconnect
{
    [socket disconnect];
}

@end
