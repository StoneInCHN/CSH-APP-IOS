//
//  UserAccountNew.h
//  CarDefender
//
//  Created by 李散 on 15/6/3.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAccountNew : NSObject
@property (strong, nonatomic) NSString* aid;//账户
@property (strong, nonatomic) NSString* calling;//话费
@property (strong, nonatomic) NSString* total;//历史总金额
@property (strong, nonatomic) NSString* freeze;//已使用金额
@property (strong, nonatomic) NSString* cash;//当前剩余金额
@property (strong, nonatomic) NSString* time;//时间
@property (strong, nonatomic) NSString* insurance;//判断保险数据
-(instancetype)initWithDic:(NSDictionary*)lDic;
@end
