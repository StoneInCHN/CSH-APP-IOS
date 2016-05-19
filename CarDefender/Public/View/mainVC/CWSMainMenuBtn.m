//
//  CWSMainMenuBtn.m
//  test
//
//  Created by 李散 on 15/6/19.
//  Copyright (c) 2015年 Mr Li. All rights reserved.
//

#import "CWSMainMenuBtn.h"
//#define kContentPercent 0.68
//#define kImgPercent 0.43666
//#define kTitleYPercent 0.7

static const CGFloat kImgPercent = 0.43666;
static const CGFloat kTitleYPercent = 0.7;
@implementation CWSMainMenuBtn

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleHW=contentRect.size.height*0.15;
    CGFloat titleY = contentRect.size.height*kTitleYPercent;
    return CGRectMake(0, titleY, contentRect.size.width, titleHW);
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imgHW=self.frame.size.height*kImgPercent;
    CGFloat imgY = self.frame.size.height*(1-kTitleYPercent)-contentRect.size.height*0.15;
    return CGRectMake((self.frame.size.height-imgHW)/2, imgY, imgHW, imgHW);
}
@end
