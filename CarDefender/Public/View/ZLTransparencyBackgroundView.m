//
//  ZLTransparencyBackgroundView.m
//  宗隆
//
//  Created by 李散 on 15/3/13.
//  Copyright (c) 2015年 sky. All rights reserved.
//

#import "ZLTransparencyBackgroundView.h"

@implementation ZLTransparencyBackgroundView

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
    NSLog(@"transparency touch begin");
    [self.delegate ZLTransparencyBackgroundViewTouchBegin];
}

@end
