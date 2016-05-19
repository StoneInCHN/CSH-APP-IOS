//
//  CarMaintainTableViewCell.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/6.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CarBeautyTableViewCell.h"

@implementation CarBeautyTableViewCell



-(void)setStoreImageView:(UIImageView *)storeImageView{

    _storeImageView = storeImageView;
    
    self.storeImageView.layer.borderColor = [UIColor cyanColor].CGColor;
    self.storeImageView.layer.borderWidth = 1.0f;
    

}


-(void)setStoreReviewView:(UIView *)storeReviewView{

    _storeReviewView = storeReviewView;
    
    
    for(int i=0; i<3; i++){
        
        UIImageView* diamondImg = [[UIImageView alloc]initWithFrame:CGRectMake(i*16, 0, 15, 15)];
        diamondImg.image = [UIImage imageNamed:@"haoping"];
        [self.storeReviewView addSubview:diamondImg];
        if(i == 2){
            UILabel* reviewLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(diamondImg.frame)+4, 0, kSizeOfScreen.width, 13)];
            reviewLabel.text = @"100%好评";
            reviewLabel.font = [UIFont systemFontOfSize:15.0f];
            reviewLabel.textColor = kCOLOR(255, 102, 0);
            [self.storeReviewView addSubview:reviewLabel];
        }
    }

}


-(void)setPayButton:(UIButton *)payButton{

    _payButton = payButton;
    
    
    [self.payButton setTitle:((arc4random() % 1 + 1 ) ? @"预约" : @"支付") forState:UIControlStateNormal];
    [self.payButton setTitleColor:[self.payButton.titleLabel.text isEqualToString:@"预约"] ? KOrangeColor : KBlueColor forState:UIControlStateNormal];
    self.payButton.layer.masksToBounds = YES;
    self.payButton.layer.borderWidth = 1.0f;
    self.payButton.layer.cornerRadius = 5.0f;
    self.payButton.layer.borderColor = [self.payButton.titleLabel.text isEqualToString:@"预约"] ? KOrangeColor.CGColor : KBlueColor.CGColor;
}




- (IBAction)firstButtonClicked:(UIButton *)sender {
    
    if([self.delegate respondsToSelector:@selector(selectTableViewButtonClicked:)]){
        [self.delegate selectTableViewButtonClicked:sender];
    }
    
}


- (void)awakeFromNib {
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
