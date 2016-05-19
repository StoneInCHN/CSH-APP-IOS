//
//  User.m
//  云车宝项目
//
//  Created by sky on 14-9-17.
//  Copyright (c) 2014年 HCYunAPP. All rights reserved.
//

#import "User.h"

@implementation User
-(instancetype)initWithDic:(NSDictionary*)lDic
{
    if (self = [super init]) {
        self.account = [[UserAccount alloc]initWithDic:[lDic objectForKey:@"account"]];
        self.key = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"key"]];
        self.mileRanking = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"mileRanking"]];
        self.nick = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"nick"]];
        self.no = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"no"]];
        self.photo = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"photo"]];
        self.score = [[UserScore alloc]initWithDic:[lDic objectForKey:@"score"]];
        self.tel = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"tel"]];
        self.uid = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"uid"]];
        self.car = [[UserDefaultCar alloc]initWithDic:[lDic objectForKey:@"car"]];
        self.sign = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"sign"]];
    }
    return self;
}
@end