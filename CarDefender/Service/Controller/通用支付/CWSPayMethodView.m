//
//  CWSPayMethodView.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/12.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSPayMethodView.h"

@implementation CWSPayMethodView



-(void)setAlipayButton:(UIButton *)alipayButton{

    _alipayButton = alipayButton;
    self.alipayButton.selected = YES;
    [self.alipayButton setImageEdgeInsets:UIEdgeInsetsMake(0, kSizeOfScreen.width-35, 0, 0)];
}


-(void)setWxView:(UIView *)wxView{

    _wxView = wxView;
    
    
    UIButton* wxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    wxButton.frame = CGRectMake(0, 0, kSizeOfScreen.width, 58);
    [wxButton setImage:[UIImage imageNamed:@"mycar_click"] forState:UIControlStateSelected];
    [wxButton setImage:[UIImage imageNamed:@"mycar_noclick"] forState:UIControlStateNormal];
    [wxButton setImageEdgeInsets:UIEdgeInsetsMake(0, kSizeOfScreen.width-35, 0, 0)];
    [wxButton addTarget:self action:@selector(testClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.wxView addSubview:wxButton];

    

}


-(void)testClicked:(UIButton*)sender{

    NSLog(@"test");

}


@end
