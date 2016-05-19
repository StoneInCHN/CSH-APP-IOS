//
//  WQPay.h
//  chlidfios
//
//  Created by 万茜 on 15/7/31.
//  Copyright (c) 2015年 万茜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQPay : NSObject
@property (copy, nonatomic) void (^paySucc)();
+(WQPay *) shareInstance;
-(void)payProductArray:(NSString *)thyPrice AndOrderID:(NSString *)order_code;
@end
