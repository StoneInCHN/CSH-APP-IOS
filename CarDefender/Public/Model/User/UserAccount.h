//
//  UserAccount.h
//  CarDefender
//
//  Created by 李散 on 15/4/10.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAccount : NSObject
@property (strong, nonatomic) NSString* aid;     //账户ID
@property (strong, nonatomic) NSString* calling; //话费
@property (strong, nonatomic) NSString* total;   //返费
@property (strong, nonatomic) NSString* cash;    //可提现余额
@property (strong, nonatomic) NSString* freeze;  //冻结金额
//@property (strong, nonatomic) NSString* note;
//@property (strong, nonatomic) NSString* now;
//@property (strong, nonatomic) NSString* time;
//@property (strong, nonatomic) NSString* total;
//@property (strong, nonatomic) NSString* uid;
//@property (strong, nonatomic) NSString* used;
-(instancetype)initWithDic:(NSDictionary*)lDic;
@end
