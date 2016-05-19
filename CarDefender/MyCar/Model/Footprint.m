//
//  Footprint.m
//  CarDefender
//
//  Created by 周子涵 on 15/4/21.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "Footprint.h"

@implementation Footprint
-(instancetype)initWithDic:(NSDictionary*)lDic
{
    if (self = [super init]) {
        self.addrStart = lDic[@"addr_start"];
        self.addrEnd = lDic[@"addr_end"];
        self.dateStart = lDic[@"date_start"];
        self.dateEnd = lDic[@"date_end"];
        self.desId = [NSString stringWithFormat:@"%@",lDic[@"desId"]];
        self.device = [NSString stringWithFormat:@"%@",lDic[@"device"]];
        self.lnglat = [NSString stringWithFormat:@"%@",lDic[@"lnglat"]];
        self.time = [NSString stringWithFormat:@"%@",lDic[@"time"]];
        self.type = [NSString stringWithFormat:@"%@",lDic[@"type"]];
        self.mile = [NSString stringWithFormat:@"%@",lDic[@"mile"]];
    }
    return self;
}
@end
