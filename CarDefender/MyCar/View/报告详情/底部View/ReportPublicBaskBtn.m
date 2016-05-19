//
//  ReportPublicBaskBtn.m
//  报告动画
//
//  Created by 李散 on 15/5/19.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "ReportPublicBaskBtn.h"

@implementation ReportPublicBaskBtn

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, self.frame.size.height/2-10, self.frame.size.width, 20);
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
@end
