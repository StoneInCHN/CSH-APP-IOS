//
//  QianDao.h
//  云车宝项目
//
//  Created by sky on 14-8-21.
//  Copyright (c) 2014年 HCYunAPP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QianDao : NSObject
-(int)getDifferDayNumber:(int)year month:(int)month day:(int)day;
//判断是否是闰年
-(BOOL)judgeLeapYear:(int)year;
//返回该天是某年的第几天
-(int)judgeDays:(int)year month:(int)month day:(int)day;
//返回该月有多少天
-(int)judgeMonthHaveDays:(int)year month:(int)month;
//判断该天是否存在
-(BOOL)jude:(int)month day:(int)day isLeapYear:(BOOL)isLeapYear;

-(int)exports:(int)month day:(int)day isLeapYear:(BOOL)isLeapYear;
@end
