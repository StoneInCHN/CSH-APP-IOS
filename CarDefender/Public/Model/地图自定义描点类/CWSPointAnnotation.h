//
//  CWSPointAnnotation.h
//  CarDefender
//
//  Created by 周子涵 on 15/8/19.
//  Copyright (c) 2015年 SKY. All rights reserved.
//


#import <BaiduMapAPI/BMapKit.h>

@interface CWSPointAnnotation : BMKPointAnnotation
@property (assign, nonatomic) int type;
@property (assign, nonatomic) int degree;
@end
