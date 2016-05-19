//
//  CWSCarMaintainComfirmAlertView.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/7.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSCarMaintainComfirmAlertView.h"

@implementation CWSCarMaintainComfirmAlertView



-(instancetype)initWithFrame:(CGRect)frame{

    if(self = [super initWithFrame:frame]){
    
   
    
    }

    return self;
}


-(void)setAlertMessageLabel:(UILabel *)AlertMessageLabel{

    _AlertMessageLabel = AlertMessageLabel;
    
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc]initWithString:_AlertMessageLabel.text];
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:12.0f];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_AlertMessageLabel.text length])];
    _AlertMessageLabel.attributedText = attributedString;
    
    
}


- (IBAction)buttonClicked:(UIButton *)sender {
    

    
    if([self.delegate respondsToSelector:@selector(selectTableViewButtonClicked:)]){
    
        [self.delegate selectTableViewButtonClicked:sender];
    }
}



@end
