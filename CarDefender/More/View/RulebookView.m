//
//  RulebookView.m
//  云车宝项目
//
//  Created by sky on 14-8-21.
//  Copyright (c) 2014年 HCYunAPP. All rights reserved.
//

#import "RulebookView.h"

@implementation RulebookView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (IBAction)zhongjiangjiluBtnClick:(UIButton *)sender {
    
    [self.delegate ruleBookViewRewardBtnClick];
}
@end
