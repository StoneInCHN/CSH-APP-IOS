//
//  CWSMessageCancelBtn.m
//  CarDefender
//
//  Created by 李散 on 15/6/3.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSMessageCancelBtn.h"

@implementation CWSMessageCancelBtn


-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(10, 0, contentRect.size.width-10, contentRect.size.height);
}

@end
