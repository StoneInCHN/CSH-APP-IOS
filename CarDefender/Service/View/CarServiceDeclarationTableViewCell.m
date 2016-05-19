//
//  CarServiceDeclarationTableViewCell.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/8.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CarServiceDeclarationTableViewCell.h"

@implementation CarServiceDeclarationTableViewCell



-(void)setServiceDeclarationLabel:(UILabel *)serviceDeclarationLabel{
    
    _serviceDeclarationLabel = serviceDeclarationLabel;
    
    
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc]initWithString:_serviceDeclarationLabel.text];
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:7.0];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_serviceDeclarationLabel.text length])];
    _serviceDeclarationLabel.attributedText = attributedString;
    [_serviceDeclarationLabel sizeToFit];

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
