//
//  SmartMlccUtil.m
//  SmartHome
//
//  Created by ysamg on 15-1-21.
//  Copyright (c) 2015年 妙联. All rights reserved.
//

#import "SmartMlccUtil.h"

@implementation SmartMlccUtil

//

+ (NSString *)stringToNetCommandString:(NSString *)localCommandString {
    localCommandString = (localCommandString.length %2 == 0)?localCommandString:[NSString stringWithFormat:@"%@0",localCommandString];
    NSMutableData *data = [[NSMutableData alloc]init];
    for(int i = 0; i < localCommandString.length; i += 2) {
        int a = (int)strtoul([[localCommandString substringWithRange:NSMakeRange(i, 2)] UTF8String], 0, 16);
        [data appendData:[NSData dataWithBytes:&a length:1]];
    }
    NSString *result = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
    return result;
}

+ (NSString *)stringFromNetCommandString:(NSString *)netCommandString {
    NSData *data = [netCommandString dataUsingEncoding:NSISOLatin1StringEncoding];
    Byte *bytes = (Byte *)[data bytes];
    NSString *hexStr=@"";
    for(int i=0; i<[data length]; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr]; 
    } 
    return hexStr;
}

+ (NSData *)makeTcpCommandData:(NSString *)command {
    
    NSString *netCommand = [self stringToNetCommandString:command];
    NSString *sendCommand = [NSString stringWithFormat:@"CodeName=GetUartData&Chn=0&Len=%@&UserBinaryData=%@",@(netCommand.length), netCommand];
    NSData *sendCommandData = [sendCommand dataUsingEncoding:NSISOLatin1StringEncoding];
    return [self makeMlccUtilData:sendCommandData];
}

+ (NSString *)parseTcpCommandData:(NSString *)data {
    NSString *netCommand = [self parseCommandData:data];
    if (netCommand.length) {
        return [self stringFromNetCommandString:netCommand];
    }
    return nil;
}

+ (NSString*)parseCommandData:(NSString *)data {
    NSString *spString = @"UserBinaryData=";
    NSRange range = [data rangeOfString:spString];
    if (range.location != NSNotFound) {
        NSString *commandData = [data substringFromIndex:range.location + spString.length];
        if(commandData) {
            return commandData;
        }
    }
    return @"";
}

/*
 *pram    command  数据内容
 *return  返回mlcc协议数据
 */
+ (NSData *)makeMlccUtilData:(NSData *)commandData {
    int iTotalLen = (int)(8+12+commandData.length);
    char *pOutData = new char[iTotalLen];
    if(pOutData == NULL){
        return nil;
    }
    memset(pOutData, 0, iTotalLen);
    pOutData[0] = 0x30;
    pOutData[1] = 104;
    pOutData[2] = iTotalLen/256 & 0xFF;
    pOutData[3] = iTotalLen%256 & 0xFF;
    pOutData[4] = (0 >> 24 & 0xff);
    pOutData[5] = (0 >> 16 & 0xff);
    pOutData[6] = (0 >> 8 & 0xff);
    pOutData[7] = (0 >> 0 & 0xff);
    pOutData[8] = 0x65;
    pOutData[9] = 0;
    pOutData[10]= (iTotalLen-8)/256 & 0xFF;
    pOutData[11]= (iTotalLen-8)%256 & 0xFF;
    pOutData[12]= (1 >> 24 & 0xff);
    pOutData[13]= (1 >> 16 & 0xff);
    pOutData[14]= (1 >> 8 & 0xff);
    pOutData[15]= (1 >> 0 & 0xff);
    pOutData[16]= (0 >> 24 & 0xff);
    pOutData[17]= (0 >> 16 & 0xff);
    pOutData[18]= (0 >> 8 & 0xff);
    pOutData[19]= (0 >> 0 & 0xff);
    
    memcpy(pOutData+20, [commandData bytes], commandData.length);
    
    //encrypt data
    for (int i=8; i<iTotalLen; i++) {
        pOutData[i] ^= pOutData[0];
    }
    
    NSData *data = [NSData dataWithBytes:pOutData length:iTotalLen];
    
    delete pOutData;
    pOutData = NULL;
    
    return data;
}

+ (NSData*)makeMlccUtil:(NSString *)command {
    
    int iTotalLen = (int)(8+12+command.length);
    char *pOutData = new char[iTotalLen];
    if(pOutData == NULL){
        return nil;
    }
    memset(pOutData, 0, iTotalLen);
    pOutData[0] = 0x30;
    pOutData[1] = 104;
    pOutData[2] = iTotalLen/256 & 0xFF;
    pOutData[3] = iTotalLen%256 & 0xFF;
    pOutData[4] = (0 >> 24 & 0xff);
    pOutData[5] = (0 >> 16 & 0xff);
    pOutData[6] = (0 >> 8 & 0xff);
    pOutData[7] = (0 >> 0 & 0xff);
    pOutData[8] = 0x65;
    pOutData[9] = 0;
    pOutData[10]= (iTotalLen-8)/256 & 0xFF;
    pOutData[11]= (iTotalLen-8)%256 & 0xFF;
    pOutData[12]= (1 >> 24 & 0xff);
    pOutData[13]= (1 >> 16 & 0xff);
    pOutData[14]= (1 >> 8 & 0xff);
    pOutData[15]= (1 >> 0 & 0xff);
    pOutData[16]= (0 >> 24 & 0xff);
    pOutData[17]= (0 >> 16 & 0xff);
    pOutData[18]= (0 >> 8 & 0xff);
    pOutData[19]= (0 >> 0 & 0xff);
    
    memcpy(pOutData+20, [command UTF8String], command.length);
    
    //encrypt data
    for (int i=8; i<iTotalLen; i++) {
        pOutData[i] ^= pOutData[0];
    }
    
    NSData *data = [NSData dataWithBytes:pOutData length:iTotalLen];
    
    delete pOutData;
    pOutData = NULL;
    
    return data;
}

+ (NSString *)getReturnCommand:(NSData *)data {
    char *pData = (char *)[data bytes];
    if (pData[0] != 0x30) {
        return nil;
    }
    
    int iTotalLen = (pData[2]<<8) + pData[3];
    for (int i=8; i<iTotalLen; i++) {
        pData[i] ^= pData[0];
    }
    
    if (iTotalLen<=20) {
        return nil;
    }
    
    NSData *commandData = [NSData dataWithBytes:(char *)pData+20 length:iTotalLen-20];
    NSString *command = [[NSString alloc] initWithData:commandData encoding:NSASCIIStringEncoding];
//    NSLog(@"HEX---%@", NSDataToHex(commandData));
    return command;
}

@end
