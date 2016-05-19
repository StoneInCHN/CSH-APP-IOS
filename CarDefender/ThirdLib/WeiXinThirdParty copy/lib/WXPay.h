//
//  WXPay.h
//  CarDefender
//
//  Created by 王泰莅 on 15/11/21.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXPay : NSObject

@property (copy, nonatomic) void (^paySucc)();
+(WXPay *) shareInstance;

@property (nonatomic,assign)BOOL isSuccess;

@end
