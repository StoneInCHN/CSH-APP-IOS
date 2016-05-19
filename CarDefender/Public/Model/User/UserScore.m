//
//  UserScore.m
//  CarDefender
//
//  Created by 李散 on 15/4/10.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "UserScore.h"

@implementation UserScore
-(instancetype)initWithDic:(NSDictionary*)lDic
{
    if (self = [super init]) {
        self.cid = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"cid"]];
//        self.note = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"note"]];
        self.now = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"now"]];
//        self.time= [NSString stringWithFormat:@"%@",[lDic objectForKey:@"time"]];
//        self.total = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"total"]];
//        self.uid = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"uid"]];
//        self.used = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"used"]];
    }
    return self;
}

@end
