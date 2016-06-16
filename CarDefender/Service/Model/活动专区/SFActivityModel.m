//
//  SFActivityModel.m
//  CarDefender
//
//  Created by sicnu_ifox on 16/6/16.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "SFActivityModel.h"

@implementation SFActivityModel

- (instancetype)initWithData:(NSDictionary *)dict {
    if (self = [super init]) {
        self.amount = [PublicUtils checkNSNullWithgetString:dict[@"amount"]];
        self.deadlineTime = [PublicUtils checkNSNullWithgetString:dict[@"deadlineTime"]];
        self.identify = [PublicUtils checkNSNullWithgetString:dict[@"id"]];
        self.remainNum = [PublicUtils checkNSNullWithgetString:dict[@"remainNum"]];
        self.remark = [PublicUtils checkNSNullWithgetString:dict[@"remark"]];
        self.type = [PublicUtils checkNSNullWithgetString:dict[@"type"]];
        self.isGet = [[NSString stringWithFormat:@"%@",dict[@"isGet"]] isEqualToString:@"1"] ? YES : NO;
    }
    return self;
}

@end
