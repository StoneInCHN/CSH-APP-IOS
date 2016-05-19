//
//  UserAccount.m
//  CarDefender
//
//  Created by 李散 on 15/4/10.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "UserAccount.h"

@implementation UserAccount
-(instancetype)initWithDic:(NSDictionary*)lDic
{
    if (self = [super init]) {
        self.aid = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"aid"]];
        self.calling = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"calling"]];
        self.total = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"total"]];
        self.cash = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"cash"]];
        self.freeze= [NSString stringWithFormat:@"%@",[lDic objectForKey:@"freeze"]];
    }
    return self;
}
@end
