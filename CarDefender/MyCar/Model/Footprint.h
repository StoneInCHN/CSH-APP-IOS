//
//  Footprint.h
//  CarDefender
//
//  Created by 周子涵 on 15/4/21.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Footprint : NSObject
@property (strong, nonatomic) NSString* addrStart;
@property (strong, nonatomic) NSString* addrEnd;
@property (strong, nonatomic) NSString* dateStart;
@property (strong, nonatomic) NSString* dateEnd;
@property (strong, nonatomic) NSString* desId;
@property (strong, nonatomic) NSString* device;
@property (strong, nonatomic) NSString* lnglat;
@property (strong, nonatomic) NSString* time;
@property (strong, nonatomic) NSString* type;
@property (strong, nonatomic) NSString* mile;
@property (strong, nonatomic) NSDictionary* latAndlonDic;

-(instancetype)initWithDic:(NSDictionary*)lDic;
@end
