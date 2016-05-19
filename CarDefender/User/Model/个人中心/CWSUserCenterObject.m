
//
//  CWSUserCenterObject.m
//  CarDefender
//
//  Created by 李散 on 15/8/20.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSUserCenterObject.h"

@implementation CWSUserCenterObject
-(instancetype)initWithDic:(NSDictionary*)lDic
{
    if (self = [super init]) {
        self.addr = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"addr"]];
        self.age = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"age"]];
        self.birth = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"birth"]];
        self.carAge = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"carAge"]];
        self.carMile = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"carMile"]];
        self.carNum = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"carNum"]];
        self.city = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"city"]];
        self.cityId = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"cityId"]];
        self.email = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"email"]];
        self.sex = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"sex"]];
    }
    return self;
}
@end
