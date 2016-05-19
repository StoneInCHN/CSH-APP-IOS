//
//  QianDao.m
//  云车宝项目
//
//  Created by sky on 14-8-21.
//  Copyright (c) 2014年 HCYunAPP. All rights reserved.
//

#import "QianDao.h"

#define KYEAR 2014
#define KMONTH 8
#define KDAY 3

@implementation QianDao

-(int)getDifferDayNumber:(int)year month:(int)month day:(int)day
{
    int differDayNumber = 0;
    if (KYEAR > year) {
        for (int i = year + 1; i <KYEAR; i++) {
            if ([self judgeLeapYear:i]) {
                differDayNumber += 366;
            }else
            {
                differDayNumber += 365;
            }
        }
        if ([self judgeLeapYear:year]) {
            differDayNumber += 366 - [self judgeDays:year month:month day:day] + [self judgeDays:KYEAR month:KMONTH day:KDAY];
        }else
        {
            differDayNumber += 365 - [self judgeDays:year month:month day:day] + [self judgeDays:KYEAR month:KMONTH day:KDAY];
        }
        differDayNumber = -differDayNumber;
    }else if (KYEAR < year)
    {
        for (int i = KYEAR + 1; i<year; i++) {
            if ([self judgeLeapYear:i]) {
                differDayNumber += 366;
            }else
            {
                differDayNumber += 365;
            }
        }
        differDayNumber += 365 + [self judgeDays:year month:month day:day] - [self judgeDays:KYEAR month:KMONTH day:KDAY];
    }else
    {
        differDayNumber = [self judgeDays:year month:month day:day] - [self judgeDays:KYEAR month:KMONTH day:KDAY];
    }
    return differDayNumber;
}
-(BOOL)judgeLeapYear:(int)year
{
    if (year%400==0||(year%4==0&&year%100!=0))
        return YES;
    else
        return NO;
}
-(int)judgeDays:(int)year month:(int)month day:(int)day
{
    BOOL isLeapYear;
    int data;
    if ([self judgeLeapYear:year]) isLeapYear = YES;
    else isLeapYear = NO;
    if ([self jude:month day:day isLeapYear:isLeapYear]) {
        //        data=export(month, day, isLeapYear);
        data = [self export:month day:day isLeapYear:isLeapYear];
    }
    return data;
}
-(int)judgeMonthHaveDays:(int)year month:(int)month
{
    if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12 ) {
        return 31;
    }
    if (month == 4 || month == 6 || month == 9 || month == 11) {
        return 30;
    }
    if ([self judgeLeapYear:year]) {
        return 29;
    }
    return 28;
}
-(BOOL)jude:(int)month day:(int)day isLeapYear:(BOOL)isLeapYear
{
    if (month==1||month==3||month==5||month==7||month==8||month==10||month==12) {
        if (day>31||day<1) {
            return NO;
        }else
            return YES;
    }
    if (month==2) {
        if (!isLeapYear) {
            if (day>28||day<1) {
                return NO;
            }else
                return YES;
        }
        if (isLeapYear) {
            if (day>29||day<1) {
                return NO;
            }else
                return YES;
        }
    }
    if (month==4||month==6||month==9||month==11) {
        if (day>30||day<1) {
            return NO;
        }else
            return YES;
    }
    return NO;
}
-(int)export:(int)month day:(int)day isLeapYear:(BOOL)isLeapYear
{
    int data=0;
    if (isLeapYear) {
        if (month==1) {
            data=day;
        }
        if (month==2) {
            data=31+day;
        }
        if (month==3) {
            data=60+day;
        }
        if (month==4) {
            data=91+day;
        }
        if (month==5) {
            data=121+day;
        }
        if (month==6) {
            data=152+day;
        }
        if (month==7) {
            data=182+day;
        }
        if (month==8) {
            data=213+day;
        }if (month==9) {
            data=244+day;
        }if (month==10) {
            data=274+day;
        }if (month==11) {
            data=305+day;
        }
        if (month==12) {
            data=335+day;
        }
    }else {
        if (month==1) {
            data=day;
        }
        if (month==2) {
            data=31+day;
        }
        if (month==3) {
            data=59+day;
        }
        if (month==4) {
            data=90+day;
        }
        if (month==5) {
            data=120+day;
        }
        if (month==6) {
            data=151+day;
        }
        if (month==7) {
            data=181+day;
        }
        if (month==8) {
            data=212+day;
        }if (month==9) {
            data=243+day;
        }if (month==10) {
            data=273+day;
        }if (month==11) {
            data=304+day;
        }
        if (month==12) {
            data=334+day;
        }
    }
    return data;
}
@end
