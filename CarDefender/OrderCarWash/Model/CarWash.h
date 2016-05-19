//
//  CarWash.h
//  CarDefender
//
//  Created by 周子涵 on 15/8/24.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "Park.h"

@interface CarWash : Park
@property (strong, nonatomic) NSString* tel;         //电话

-(instancetype)initWithDic:(NSDictionary*)lDic;
@end
