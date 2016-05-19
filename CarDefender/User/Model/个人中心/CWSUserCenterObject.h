//
//  CWSUserCenterObject.h
//  CarDefender
//
//  Created by 李散 on 15/8/20.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWSUserCenterObject : NSObject
@property (nonatomic, strong) NSString* addr; //地址
@property (nonatomic, strong) NSString* age; //年龄
@property (nonatomic, strong) NSString* birth; //生日
@property (nonatomic, strong) NSString* carAge; //车龄
@property (nonatomic, strong) NSString* carMile; // 车辆里程
@property (nonatomic, strong) NSString* carNum; //车辆号
@property (nonatomic, strong) NSString* city; //常出没城市
@property (nonatomic, strong) NSString* cityId; //城市ID
@property (nonatomic, strong) NSString* email; //邮箱
@property (nonatomic, strong) NSString* sex; //性别

-(instancetype)initWithDic:(NSDictionary*)lDic;
@end
