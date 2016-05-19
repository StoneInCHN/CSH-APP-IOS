//
//  MaintainReviewTableViewCell.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/9.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "MaintainReviewTableViewCell.h"

#import "CWSCarMaintainInfoModel.h"
@implementation MaintainReviewTableViewCell



-(void)setReviewModel:(CWSCarMaintainInfoModel *)reviewModel{
    _reviewModel = reviewModel;
    
    
    self.userHeaderImageView.layer.masksToBounds = YES;
    self.userHeaderImageView.layer.cornerRadius = 12.5f;
    self.userHeaderImageView.layer.borderColor = [UIColor blueColor].CGColor;
    self.userHeaderImageView.layer.borderWidth = 1.0f;
    
    self.userReviewLabel.text = [reviewModel.realDataArray firstObject];

}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
