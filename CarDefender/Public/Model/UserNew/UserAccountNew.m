//
//  UserAccountNew.m
//  CarDefender
//
//  Created by 李散 on 15/6/3.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "UserAccountNew.h"

@implementation UserAccountNew
-(instancetype)initWithDic:(NSDictionary*)lDic
{
    if (self = [super init]) {
        self.aid = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"aid"]];
        self.calling = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"calling"]];
        self.freeze = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"freeze"]];
        self.total = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"total"]];
        self.cash = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"cash"]];
        self.time = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"time"]];
        self.insurance = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"insurance"]];
    }
    return self;
}
@end
