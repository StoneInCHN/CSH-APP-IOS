//
//  LHPShaheObject.m
//  云车宝项目
//
//  Created by pan on 14/11/11.
//  Copyright (c) 2014年 HCYunAPP. All rights reserved.
//

#import "LHPShaheObject.h"

@implementation LHPShaheObject

+(void)saveMsgWithName:(NSString *)name andWithMsg:(NSMutableArray*)msg
{
    //    获取document目录
    NSArray*larray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*lstring=[larray lastObject];
    
    //    如果把数据存储
    NSString *pStr = [lstring stringByAppendingString:[NSString stringWithFormat:@"/%@.plist",name]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    MyLog(@"%@",pStr);
    BOOL result = [fileManager fileExistsAtPath:pStr];
    if (result) {
        [msg writeToFile:pStr atomically:YES];
    }else{
        //如果不存在就创建
        [[NSFileManager defaultManager]createFileAtPath:pStr contents:nil attributes:nil];
        [msg writeToFile:pStr atomically:YES];
    }
}

//消息中心未读数据条数
+(void)saveUnreadMsgWithName:(NSString*)name andCount:(int)msgCount
{
    //    获取document目录
    NSArray*larray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*lstring=[larray lastObject];
    
    //    如果把数据存储
    NSString *pStr = [lstring stringByAppendingString:[NSString stringWithFormat:@"/%@.plist",name]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    MyLog(@"%@",pStr);
    BOOL result = [fileManager fileExistsAtPath:pStr];
    if (result) {
        [[NSString stringWithFormat:@"%d",msgCount] writeToFile:pStr atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }else{
        //如果不存在就创建
        [[NSFileManager defaultManager]createFileAtPath:pStr contents:nil attributes:nil];
        [[NSString stringWithFormat:@"%d",msgCount] writeToFile:pStr atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}



+(void)saveAccountMsgWithName:(NSString*)name andWithMsg:(NSDictionary*)msg
{
    //    获取document目录
    NSArray*larray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*lstring=[larray lastObject];
    
    //    如果把数据存储
    NSString *pStr = [lstring stringByAppendingString:[NSString stringWithFormat:@"/%@.plist",name]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    MyLog(@"%@",pStr);
    BOOL result = [fileManager fileExistsAtPath:pStr];
    if (result) {
        [msg writeToFile:pStr atomically:YES];
    }else{
        //如果不存在就创建
        [[NSFileManager defaultManager]createFileAtPath:pStr contents:nil attributes:nil];
        [msg writeToFile:pStr atomically:YES];
    }
}
+(NSString*)readMsgFromeShaHeWithName:(NSString *)name
{
    NSArray*larray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*lstring=[larray lastObject];
    NSString*lpath=[lstring stringByAppendingString:[NSString stringWithFormat:@"/%@.plist",name]];
//    NSMutableArray*array2=[[NSMutableArray alloc]initWithContentsOfFile:lpath];
    return lpath;
}
+(BOOL)checkPathIsOk:(NSString*)name
{
    //    获取document目录
    NSArray*larray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*lstring=[larray lastObject];
    
    //    如果把数据存储
    NSString *pStr = [lstring stringByAppendingString:[NSString stringWithFormat:@"/%@.plist",name]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:pStr];
    return result;
}


//消息中心数据持久化
+(NSMutableArray*)messageCenterWithDic:(NSDictionary*)dic
{
    NSMutableArray*array;
    NSMutableDictionary*dic1=[NSMutableDictionary dictionaryWithDictionary:dic];
    [dic1 setObject:[NSString stringWithFormat:@"%@:%@",[Utils getTime][3],[Utils getTime][4]] forKey:@"time"];
    [dic1 setObject:@"info_message.png" forKey:@"imageName"];
//    dic = (NSDictionary*)dic1;
    //    获取document目录
    NSArray*larray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*lstring=[larray lastObject];
    
    //    如果把数据存储
    NSString *pStr = [lstring stringByAppendingString:[NSString stringWithFormat:@"/%@.plist",@"messageCenter"]];
    MyLog(@"%@",pStr);
    NSFileManager *fileManager = [NSFileManager defaultManager];

    BOOL result = [fileManager fileExistsAtPath:pStr];
    if (result) {//存在
        array=[NSMutableArray arrayWithContentsOfFile:pStr];
        [array insertObject:dic1 atIndex:array.count];
        [array writeToFile:pStr atomically:YES];
    }else{//不存在
        //如果不存在就创建
        array=[NSMutableArray arrayWithObjects:dic1, nil];
        [[NSFileManager defaultManager]createFileAtPath:pStr contents:nil attributes:nil];
        [array writeToFile:pStr atomically:YES];
    }
    
    
    return array;
}

@end
