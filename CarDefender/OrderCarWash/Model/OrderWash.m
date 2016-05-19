//
//  OrderWash.m
//  CarDefender
//
//  Created by 周子涵 on 15/8/25.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "OrderWash.h"

@implementation OrderWash
-(instancetype)initWithPark:(Park*)park{
    if (self = [super init]) {
        self.washID = park.parkID;
        self.distance = park.distance;
        self.latitude = park.latitude;
        self.longitude = park.longitude;
        self.addr = park.addr;
        self.picUrl = park.picUrl;
        self.name = park.name;
        self.priceDesc = park.priceDesc;
        self.tel = park.tel;
        self.date = park.date;
    }
    return self;
}
-(instancetype)initWithDic:(NSDictionary*)lDic{
    if (self = [super init]) {
        self.washID = [NSString stringWithFormat:@"%@",lDic[@"cw_id"]];
        self.name = [NSString stringWithFormat:@"%@",lDic[@"name"]];
        self.priceDesc = [NSString stringWithFormat:@"%@",lDic[@"des"]];
        self.longitude = [NSString stringWithFormat:@"%@",lDic[@"lon"]];
        self.addr = [NSString stringWithFormat:@"%@",lDic[@"address"]];
        self.tel = [NSString stringWithFormat:@"%@",lDic[@"tel"]];
        self.distance = [NSString stringWithFormat:@"%@",lDic[@"mile"]];
//        self.picUrl = [NSString stringWithFormat:@"%@",lDic[@"pic"]];
        self.picUrl = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"baseUrl"],lDic[@"pic"]];
        self.latitude = [NSString stringWithFormat:@"%@",lDic[@"lat"]];
        self.uno = [NSString stringWithFormat:@"%@",lDic[@"uno"]];
        self.time = [NSString stringWithFormat:@"%i",4-[lDic[@"time"] intValue]];
        self.date = [NSString stringWithFormat:@"%@",lDic[@"date"]];
    }
    return self;
}
@end
