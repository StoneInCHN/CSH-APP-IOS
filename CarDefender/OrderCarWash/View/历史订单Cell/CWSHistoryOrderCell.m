//
//  CWSHistoryOrderCell.m
//  CarDefender
//
//  Created by 周子涵 on 15/10/12.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSHistoryOrderCell.h"
#import "CWSHistoryOrder.h"
#import "CWSHistoryOrderView.h"



@implementation CWSHistoryOrderCell



- (void)awakeFromNib
{
    self.titleLabel  = (UILabel *)[self viewWithTag:1];
    self.statueLabel = (UILabel *)[self viewWithTag:2];
    self.shopNameLabel = (UILabel *)[self viewWithTag:3];
    self.moneyLabel = (UILabel *)[self viewWithTag:4];
    self.payTimeLabel = (UILabel *)[self viewWithTag:5];
    self.actionButton = (UIButton *)[self viewWithTag:6];
    self.actionButton.layer.borderWidth = 1.0;
    
    self.actionButton.layer.borderColor = [UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1].CGColor;
    [self.actionButton addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)setOrder:(CWSHistoryOrder *)order{
    
    _order = order;

}



-(void)actionButtonClicked:(UIButton*)sender{
//    if([self.delegate respondsToSelector:@selector(selectTableViewButtonClicked:Red:ID:andDataDict:)]){
//        [self.delegate selectTableViewButtonClicked:sender Red:0 ID:[self.dataDic[@"merchantsID"] integerValue] andDataDict:self.dataDic];
//    }
    if([self.delegate respondsToSelector:@selector(selectTableViewButtonClicked:andOrderHistoryModel:)]){
        [self.delegate selectTableViewButtonClicked:sender andOrderHistoryModel:self.order];
    }
}



@end
