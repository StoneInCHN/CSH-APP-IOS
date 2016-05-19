//
//  graphicView.m
//  绘图技术
//
//  Created by sky on 14-5-7.
//  Copyright (c) 2014年 HanChangIOS. All rights reserved.
//

#import "graphicView.h"

@implementation graphicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rate = -90;
        self.rate2 = -30;
        self.rate3 = -60;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    //画圆
    [self drawCirleLine];
    [self drawCirle];
}


//画圆
-(void)drawCirle
{
    CGRect rect=[UIScreen mainScreen].applicationFrame;
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(currentContext, [UIColor whiteColor].CGColor);
    CGContextAddArc(currentContext, rect.size.width/2, 100, 46, 0*M_PI/180, 360*M_PI/180, 0);
    CGContextFillPath(currentContext);
}
-(void)drawCirleLine
{
    CGRect rect=[UIScreen mainScreen].applicationFrame;
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(currentContext, [UIColor darkGrayColor].CGColor);
    CGContextAddArc(currentContext, rect.size.width/2, 100, 54, 0*M_PI/180, 360*M_PI/180, 0);
    CGContextFillPath(currentContext);
}
@end
