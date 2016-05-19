//
//  CWSNewCarWashNormalCell.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/10.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSNewCarWashNormalCell.h"


#import "CWSCarWashNormalModel.h"
@implementation CWSNewCarWashNormalCell



-(void)setNormalModel:(CWSCarWashNormalModel *)normalModel{

    _normalModel = normalModel;
    
    
    [self.payButton setTitleColor:KOrangeColor forState:UIControlStateNormal];
    self.payButton.layer.masksToBounds = YES;
    self.payButton.layer.borderColor = KOrangeColor.CGColor;
    self.payButton.layer.borderWidth = 1.0f;
    self.payButton.layer.cornerRadius = 5.0f;
    
//    if(normalModel.price == nil){
//        self.priceLabel.hidden = YES;
//    }else{
//        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",normalModel.price];
//    }
    
//    self.productNameLabel.text = normalModel.productName;
}


- (IBAction)payButtonClicked:(UIButton *)sender {
    
    if([self.delegate respondsToSelector:@selector(selectTableViewButtonClicked:andNormalModel:)]){
        [self.delegate selectTableViewButtonClicked:sender andNormalModel:self.normalModel];
    }
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
