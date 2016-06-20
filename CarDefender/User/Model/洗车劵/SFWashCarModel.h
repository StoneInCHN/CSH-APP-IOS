//
//  SFWashCarModel.h
//  CarDefender
//
//  Created by sicnu_ifox on 16/6/19.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFWashCarModel : NSObject

@property (strong, nonatomic) NSString *tenantName;
@property (strong, nonatomic) NSString *remark;
@property (strong, nonatomic) NSString *couponName;
@property (strong, nonatomic) NSString *remainNum;
@property (strong, nonatomic) NSString *identify;

- (instancetype)initWithData:(NSDictionary *)dict;

@end
