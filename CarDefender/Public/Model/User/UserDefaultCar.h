//
//  UserDefaultCar.h
//  CarDefender
//
//  Created by 李散 on 15/4/10.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultCar : NSObject
@property (strong, nonatomic) NSString* addTime;
@property (strong, nonatomic) NSString* boundJson;
@property (strong, nonatomic) NSString* brand;
@property (strong, nonatomic) NSString* carId;
@property (strong, nonatomic) NSString* cid;
@property (strong, nonatomic) NSString* color;
@property (strong, nonatomic) NSString* device;
@property (strong, nonatomic) NSString* flag;
@property (strong, nonatomic) NSString* isBound;
@property (strong, nonatomic) NSString* isDefault;
@property (strong, nonatomic) NSString* module;
@property (strong, nonatomic) NSString* note;
@property (strong, nonatomic) NSString* plate;
@property (strong, nonatomic) NSString* series;
@property (strong, nonatomic) NSString* simNo;
@property (strong, nonatomic) NSString* uid;
@property (strong, nonatomic) NSString* vinNo;
-(instancetype)initWithDic:(NSDictionary*)lDic;
@end
