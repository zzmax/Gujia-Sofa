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
        [self initControlMessage];
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
 */
-(void)initControlMessage
{
    sendDataLength=8;
    inputBuffer[0]=0x21;    //message ID
    inputBuffer[1]=0x02;    //?
    inputBuffer[2]=0x03;    //?
    inputBuffer[3]=0x01;    //data that control the sofa
    inputBuffer[4]=0x00;
    inputBuffer[5]=0x00;
    inputBuffer[6]=0x0d;
    inputBuffer[7]=0x0a;
}

/**
 *  This method is to intiate the message array that we will send to sensors to aquire data
 */
-(void)initAcquireSensorDataMessage
{
    sendDataLength=8;
    inputBuffer[0]=0x24;
    inputBuffer[1]=0x02;
    inputBuffer[2]=0x03;
    inputBuffer[3]=0x02;
    inputBuffer[4]=0x00;
    inputBuffer[5]=0x00;
    inputBuffer[6]=0x0d;
    inputBuffer[7]=0x0a;
}

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
    socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    socket.delegate = self;
    NSError *err = nil;
    BOOL connState=[socket connectToHost:host onPort:port error:&err];
    if(!connState)
    {
        _message = err.description;//[_messageLabel.text stringByAppendingString:err.description ];
    }
    else
    {
        _message = @"连接成功";
        NSLog(@"连接服务器：%@,%d 成功",host,port);
    }
    
    [socket readDataWithTimeout:socketTimeOut tag:0];
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
        [self initControlMessage];
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
    NSString *command;
    if ([ip isEqualToString:host] && port == aPort)
    {
        NSString *result = [SmartMlccUtil getReturnCommand:data];
        command = [SmartMlccUtil parseTcpCommandData:result];
        NSLog(@"返回信息=%@",command);
    }
    
    [sock readDataWithTimeout:-1 tag:200];
    
    if (command!=nil&&command.length==18) {
        NSString *cmd=[command substringWithRange:NSMakeRange(4, 4)];
        NSLog(@"cmd=%@",cmd);//////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if ([cmd isEqualToString:@"0103"]) {//电热毯信息
            NSString *strElectricBlanket;
            NSString *str=[command substringWithRange:NSMakeRange(8, 2)];//电热毯开关信息
            if([str isEqualToString:@"00"])
            {
                strElectricBlanket = @"关";
            }
            else if ([str isEqualToString:@"01"]){
                NSString *value=[command substringWithRange:NSMakeRange(10, 2)];//电热毯温度值信息
                NSString *value1=[command substringWithRange:NSMakeRange(12, 2)];//电热毯档位信息
                strElectricBlanket = [NSString stringWithFormat:@"开,温度%@,档位%@",value,value1];
                //                    [self.temp addObject:[NSString stringWithFormat: @"%d",value]];
                //                    [self.temp addObject:[NSString stringWithFormat: @"%d",value1]];
                self.sofaTemp[0] = value;
                self.sofaTemp[1] = value1;
            }
           
        }
        if ([cmd isEqualToString:@"0204"]) {//称重信息
            NSString *value=[command substringWithRange:NSMakeRange(10, 2)];//重量kg高位
            NSString *value1=[command substringWithRange:NSMakeRange(12, 2)];//重量kg低位
            NSString *value2=[command substringWithRange:NSMakeRange(14, 2)];//重量g，g的值仅发送百位和十位数，最大99，即990g
            float fWeighting= [value floatValue] +([value1 floatValue]+[value2 floatValue])/100;

            NSString *strWeighting = [NSString stringWithFormat:@"%.1f",fWeighting];
            self.weight = strWeighting;
        }

        cmd =[command substringWithRange:NSMakeRange(6, 4)];
        if ([cmd isEqualToString:@"0302"]) {//血氧，脉搏信息
            NSString *value=[command substringWithRange:NSMakeRange(10, 2)];//电热毯温度值信息
            NSString *value1=[command substringWithRange:NSMakeRange(12, 2)];//电热毯档位信息
            
            self.bloodO2 = value;
            self.heartRate = value1;

        }
    
        if ([cmd isEqualToString:@"0301"]) {//体温信息
            NSString *value=[command substringWithRange:NSMakeRange(10, 2)];//电热毯温度值信息
            NSString *value1=[command substringWithRange:NSMakeRange(12, 2)];//电热毯档位信息
            
            float fTemperature=[value floatValue]+[value1 floatValue]/10;
            
            NSString *strTemperature = [NSString stringWithFormat:@"%.1f",fTemperature];
            self.bodyTemp = strTemperature;

        }
        if ([cmd isEqualToString:@"0303"]) {//血压实时测量
            //Real blood pressure measure
//            int value0=(int)tempteratureByte[0];
            NSString *value=[command substringWithRange:NSMakeRange(10, 2)];//电热毯温度值信息
             NSString *value1=[command substringWithRange:NSMakeRange(12, 2)];//电热毯档位信息
            self.bloodPressure = value;
        }
        if ([cmd isEqualToString:@"0304"]) {//血压测试完成
            NSString *value=[command substringWithRange:NSMakeRange(10, 2)];//电热毯温度值信息
            NSString *value1=[command substringWithRange:NSMakeRange(12, 2)];//电热毯档位信息
            
            NSString *strbloodPressure;
            strbloodPressure = [NSString stringWithFormat:@"%@/%@",value,value1];//收缩压/舒张压
            self.bloodPressure = strbloodPressure;
            
        }
        if ([cmd isEqualToString:@"0305"]) {//血压测试异常
            
            self.bloodPressure = @"测试异常";
            
        }
        
        [socket readDataWithTimeout:100 tag:0];

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
    // 断线重连
    isConnected=NO;
    [sock connectToHost:host onPort:port withTimeout:60 error:nil];
}


@end
