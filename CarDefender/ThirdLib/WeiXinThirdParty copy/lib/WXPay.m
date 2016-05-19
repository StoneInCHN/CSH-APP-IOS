//
//  WXPay.m
//  CarDefender
//
//  Created by 王泰莅 on 15/11/21.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "WXPay.h"

static WXPay * wxPay;
@implementation WXPay

+(WXPay *) shareInstance{
    if (!wxPay) {
        wxPay=[[WXPay alloc] init];
    }
    return wxPay;
}

@end
