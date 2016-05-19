//
//  UserInfo.m
//  CarDefender
//
//  Created by sicnu_ifox on 16/5/10.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+ (instancetype)userDefault
{
    static UserInfo* defaultUserInfo;
    static dispatch_once_t one;
    dispatch_once(&one, ^{
        defaultUserInfo = [[self alloc] init];
    });
    return defaultUserInfo;
}

-(instancetype)init
{
    self = [super init];
    return self;
}

- (void)loadDataWithDict:(NSDictionary *)dict {
    self.defaultDeviceNo = dict[@"defaultDeviceNo"];
    self.defaultVehicle = dict[@"defaultVehicle"];
    self.defaultVehicleIcon = dict[@"defaultVehicleIcon"];
    self.defaultVehiclePlate = dict[@"defaultVehiclePlate"];
    self.nickName = dict[@"nickName"];
    self.photo = dict[@"photo"];
    self.signature = dict[@"signature"];
    self.userName = dict[@"userName"];
}

@end
