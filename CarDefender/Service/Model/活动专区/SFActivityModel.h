//
//  SFActivityModel.h
//  CarDefender
//
//  Created by sicnu_ifox on 16/6/16.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFActivityModel : NSObject

@property (strong, nonatomic) NSString *amount;
@property (strong, nonatomic) NSString *deadlineTime;
@property (strong, nonatomic) NSString *identify;
@property (strong, nonatomic) NSString *remainNum;
@property (strong, nonatomic) NSString *remark;
@property (strong, nonatomic) NSString *type;
@property (assign, nonatomic) BOOL isGet;
-(instancetype)initWithData:(NSDictionary *)dict;

@end
