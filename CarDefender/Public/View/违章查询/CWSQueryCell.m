//
//  CWSQueryCell.m
//  CarDefender
//
//  Created by 李散 on 15/6/30.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSQueryCell.h"

@implementation CWSQueryCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)drawRect:(CGRect)rect
{
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGFloat lengths[] = {5,2};
    CGContextSetLineDash(context, 0, lengths,2);
    CGContextMoveToPoint(context, 10.0, 33.0);
    CGContextAddLineToPoint(context, 320.0,33.0);
    CGContextStrokePath(context);
    CGContextClosePath(context);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
