//
//  UserScoreNew.h
//  CarDefender
//
//  Created by 李散 on 15/6/3.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserScoreNew : NSObject
@property (strong, nonatomic) NSString* cid;//积分账户
@property (strong, nonatomic) NSString* now;//当前剩余积分
@property (strong, nonatomic) NSString* total;//历史总积分
@property (strong, nonatomic) NSString* used;//已使用积分
-(instancetype)initWithDic:(NSDictionary*)lDic;
@end
