//
//  UserDefaultCarNew.h
//  CarDefender
//
//  Created by 李散 on 15/6/3.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultCarNew : NSObject



#if USENEWVERSION


@property (strong, nonatomic) NSString* brand;//品牌
@property (strong, nonatomic) NSString* cid;//ID
@property (strong, nonatomic) NSString* module;//车型
@property (strong, nonatomic) NSString* plate;//车牌
@property (strong, nonatomic) NSString* series;//车系
@property (nonatomic,copy)    NSString* drivingLicense;//驾照
@property (strong, nonatomic) NSString* device;//设备ID
@property (strong, nonatomic) NSString* logo;//图片

@property (strong, nonatomic) NSString* brandName;//品牌名称
@property (strong, nonatomic) NSString* seriesName;//车系名称
@property (strong, nonatomic) NSString* color;//颜色
@property (strong, nonatomic) NSString* vinNo;//车架号
@property (strong, nonatomic) NSString* carId;//车辆
#else
@property (strong, nonatomic) NSString* brand;//品牌
@property (strong, nonatomic) NSString* carId;//车辆
@property (strong, nonatomic) NSString* brandName;//品牌名称
@property (strong, nonatomic) NSString* seriesName;//车系名称
@property (strong, nonatomic) NSString* cid;//ID
@property (strong, nonatomic) NSString* color;//颜色
@property (strong, nonatomic) NSString* device;//设备ID
@property (strong, nonatomic) NSString* module;//车型
@property (strong, nonatomic) NSString* plate;//车牌
@property (strong, nonatomic) NSString* series;//车系
@property (strong, nonatomic) NSString* vinNo;//车架号
@property (strong, nonatomic) NSString* logo;//图片

#endif


-(instancetype)initWithDic:(NSDictionary*)lDic;
@end
