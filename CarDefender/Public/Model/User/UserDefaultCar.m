//
//  UserDefaultCar.m
//  CarDefender
//
//  Created by 李散 on 15/4/10.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "UserDefaultCar.h"

@implementation UserDefaultCar
-(instancetype)initWithDic:(NSDictionary*)lDic
{
    if (self = [super init]) {
        self.addTime = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"addTime"]];
        self.boundJson = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"boundJson"]];
        self.brand = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"brand"]];
        self.carId= [NSString stringWithFormat:@"%@",[lDic objectForKey:@"carId"]];
        self.cid = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"cid"]];
        self.color = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"color"]];
        self.device = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"device"]];
        
        self.flag = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"flag"]];
        self.isBound = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"isBound"]];
        self.isDefault = [Utils checkNSNullWithgetString:[lDic objectForKey:@"isDefault"]];
        self.module= [NSString stringWithFormat:@"%@",[lDic objectForKey:@"module"]];
        self.note = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"note"]];
        self.plate = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"plate"]];
        self.series = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"series"]];
        
        self.simNo = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"simNo"]];
        self.uid = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"uid"]];
        self.vinNo = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"vinNo"]];
    }
    return self;
}
@end
