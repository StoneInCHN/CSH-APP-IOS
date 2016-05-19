//
//  Detection.h
//  CarDefender
//
//  Created by 周子涵 on 15/4/23.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Detection : NSObject
@property (strong, nonatomic) NSString* detectionID;
@property (strong, nonatomic) NSString* mileRanking;
@property (strong, nonatomic) NSString* nick;
@property (strong, nonatomic) NSString* no;
@property (strong, nonatomic) NSString* photo;
@property (strong, nonatomic) NSString* tel;
@property (strong, nonatomic) NSString* uid;
@property (strong, nonatomic) NSString* currentCity;

-(instancetype)initWithDic:(NSDictionary*)lDic;
@end
