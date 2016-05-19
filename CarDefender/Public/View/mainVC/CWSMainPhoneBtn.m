//
//  CWSMainPhoneBtn.m
//  test
//
//  Created by 李散 on 15/6/23.
//  Copyright (c) 2015年 Mr Li. All rights reserved.
//

#import "CWSMainPhoneBtn.h"

static const CGFloat titleImgPercent = 0.64;
@implementation CWSMainPhoneBtn

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, self.frame.size.height*(1-titleImgPercent), self.frame.size.width, self.frame.size.height*titleImgPercent);
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat phoneImgW = (self.frame.size.height-2)*0.7;
    return CGRectMake(self.frame.size.width-phoneImgW, 0, phoneImgW, self.frame.size.height-2);
}
@end
