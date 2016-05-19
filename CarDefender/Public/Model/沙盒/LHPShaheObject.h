//
//  LHPShaheObject.h
//  云车宝项目
//
//  Created by pan on 14/11/11.
//  Copyright (c) 2014年 HCYunAPP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHPShaheObject : NSObject
//创建沙盒存入数据或沙盒路径已有存入数据
+(void)saveMsgWithName:(NSString*)name andWithMsg:(NSMutableArray*)msg;

+(NSString*)readMsgFromeShaHeWithName:(NSString*)name;
//检查路径是否存在
+(BOOL)checkPathIsOk:(NSString*)name;
+(void)saveAccountMsgWithName:(NSString*)name andWithMsg:(NSDictionary*)msg;


//消息中心数据持久化
+(NSMutableArray*)messageCenterWithDic:(NSDictionary*)dic;

//消息中心未读数据条数
+(void)saveUnreadMsgWithName:(NSString*)name andCount:(int)msgCount;

@end
