//
//  Interest.h
//  CarDefender
//
//  Created by 周子涵 on 15/4/16.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Interest : NSObject
@property (strong, nonatomic) NSString* address;    //地址
@property (strong, nonatomic) NSString* cityName;   //城市名
@property (strong, nonatomic) NSString* distance;   //距离
@property (strong, nonatomic) NSString* district;   //区名
@property (strong, nonatomic) NSString* lat;        //纬度
@property (strong, nonatomic) NSString* lng;        //经度
@property (strong, nonatomic) NSString* name;       //名字
@property (strong, nonatomic) NSString* type;       //类型
@property (strong, nonatomic) NSString* telephone;  //电话

-(instancetype)initWithDic:(NSDictionary*)lDic;
@end
