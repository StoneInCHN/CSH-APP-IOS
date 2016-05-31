//
//  Helper.m
//  CarDefender
//
//  Created by sicnu_ifox on 16/5/11.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+ (BOOL)isStringEmpty:(NSString *)string
{
    if ([string isEqual:[NSNull null]] || [string isEqualToString:@""] ) {
        return YES;
    }
    return NO;
}

+ (NSString *)convertDateViaTimeStamp:(double)timeStamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-dd-MM HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeStamp / 1000];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+ (NSString *)convertNULLToString:(id)data {
    if ([data isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",data];
}
@end
