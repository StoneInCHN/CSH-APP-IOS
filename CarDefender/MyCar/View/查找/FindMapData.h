//
//  FindMapData.h
//  CarDefender
//
//  Created by 周子涵 on 15/6/19.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI/BMapKit.h>

@interface FindMapData : NSObject
@property (strong, nonatomic) NSArray* coordArray;              //坐标数组
@property (strong, nonatomic) NSArray* minorCoordArray;         //次要坐标数组
@property (assign, nonatomic) CLLocationCoordinate2D point;     //坐标
@property (strong, nonatomic) NSString* carAddress;             //车辆地址
@property (assign, nonatomic) BOOL traffic;                     //图片名字
@property (assign, nonatomic) BOOL nearbyCar;                   //汽车附件
@end
