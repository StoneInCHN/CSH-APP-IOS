//
//  CarMaintainTableViewCell.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/6.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "NewCarWashTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation NewCarWashTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Data:(NSDictionary *)dic
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"NewCarWashTableViewCell" owner:self options:nil] lastObject];
        self.dataDic = [dic mutableCopy];
        [self showUI];
    }
    return self;
}


- (void)awakeFromNib {
    
    [self showUI];
    
}


- (void)showUI
{
    
    //支付
    [self.payButton setTitleColor:kMainColor forState:UIControlStateNormal];
    self.payButton.layer.masksToBounds = YES;
    self.payButton.layer.borderColor = kMainColor.CGColor;
    self.payButton.layer.borderWidth = 1.0f;
    self.payButton.layer.cornerRadius = 5.0f;
    
//    if ([self.dataDic[@"support_red"] integerValue]) {
//        self.redImageView.hidden = NO;
//    }
//    else {
//        self.redImageView.hidden = YES;
//    }
    self.redImageView.hidden = YES;
}


- (IBAction)firstButtonClicked:(UIButton *)sender {
    
//    if([self.delegate respondsToSelector:@selector(selectTableViewButtonClicked:Red:ID:andDataDict:)]){
//        //把是否支持红包支付的值赋给按钮的tag值并回传
//        [self.delegate selectTableViewButtonClicked:sender Red:[self.dataDic[@"support_red"] integerValue] ID:[self.dataDic[@"merchantsID"] integerValue] andDataDict:self.dataDic];
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
