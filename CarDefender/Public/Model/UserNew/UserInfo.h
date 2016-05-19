//
//  UserInfo.h
//  CarDefender
//
//  Created by sicnu_ifox on 16/5/10.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property(strong, nonatomic) NSString *token;
@property(strong,nonatomic) NSString *desc;

@property(strong, nonatomic) NSString *defaultDeviceNo;
@property(strong, nonatomic) NSString *defaultVehicle;
@property(strong, nonatomic) NSString *defaultVehicleIcon;
@property(strong, nonatomic) NSString *defaultVehiclePlate;
@property(strong, nonatomic) NSString *nickName;
@property(strong, nonatomic) NSString *photo;
@property(strong, nonatomic) NSString *signature;
@property(strong, nonatomic) NSString *userName;

@property(strong, nonatomic) NSString *latitude;
@property(strong, nonatomic) NSString *longitude;

+ (instancetype)userDefault;
- (void)loadDataWithDict:(NSDictionary *)dict;

@end
