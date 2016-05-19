//
//  UserDefaultCarNew.m
//  CarDefender
//
//  Created by 李散 on 15/6/3.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "UserDefaultCarNew.h"

@implementation UserDefaultCarNew
-(instancetype)initWithDic:(NSDictionary*)lDic
{
    if (self = [super init]) {
        
#if USENEWVERSION
//        @property (strong, nonatomic) NSString* brand;//品牌
//        @property (strong, nonatomic) NSString* carId;//车辆
//        @property (strong, nonatomic) NSString* cid;//ID
//        @property (strong, nonatomic) NSString* module;//车型
//        @property (strong, nonatomic) NSString* plate;//车牌
//        @property (strong, nonatomic) NSString* series;//车系
//        @property (nonatomic,copy)    NSString* drivingLicense;//驾照
        self.brand = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"brand"]];
        self.device = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"device"]];
        self.cid = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"id"]];
        self.module= [NSString stringWithFormat:@"%@",[lDic objectForKey:@"module"]];
        self.plate = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"plate"]];
        self.series = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"series"]];
        self.drivingLicense = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"driving_license"]];
#else
        self.brand = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"brand"]];
        self.carId= [NSString stringWithFormat:@"%@",[lDic objectForKey:@"carId"]];
        self.cid = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"cid"]];
        self.color = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"color"]];
        self.device = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"device"]];
        self.module= [NSString stringWithFormat:@"%@",[lDic objectForKey:@"module"]];
        self.plate = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"plate"]];
        self.series = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"series"]];
        self.vinNo = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"vinNo"]];
        self.seriesName = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"seriesName"]];
        self.brandName = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"brandName"]];
        self.logo = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"logo"]];
#endif

    }
    return self;
}
@end
