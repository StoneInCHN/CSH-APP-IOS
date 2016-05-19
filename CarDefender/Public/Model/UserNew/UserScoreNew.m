//
//  UserScoreNew.m
//  CarDefender
//
//  Created by 李散 on 15/6/3.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "UserScoreNew.h"

@implementation UserScoreNew
-(instancetype)initWithDic:(NSDictionary*)lDic
{
    if (self = [super init]) {
        self.cid = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"cid"]];
        self.now = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"now"]];
        self.total = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"total"]];
        self.used = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"used"]];
    }
    return self;
}
@end
