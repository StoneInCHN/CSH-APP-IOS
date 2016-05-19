//
//  DaysView.m
//  test
//
//  Created by sky on 14-8-21.
//  Copyright (c) 2014年 HCYunAPP. All rights reserved.
//

#import "DaysView.h"

@implementation DaysView

- (id)initWithFrame:(CGRect)frame number:(int)number
{
    self = [super initWithFrame:frame];
    if (self) {
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 10, 22, 22)];
        [self.numberLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
        [self.numberLabel setTextAlignment:NSTextAlignmentCenter];
        self.numberLabel.text = [NSString stringWithFormat:@"%i",number + 1];
        [self addSubview:self.numberLabel];
        
        self.imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(23, 22, 15, 15)];
         [self.imageBtn setImage:[UIImage imageNamed:@"info_qiandao"] forState:UIControlStateNormal];
        [self addSubview:self.imageBtn];
        
    }
    return self;
}

@end
