//
//  CWSCarMaintainDetailContentView.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/7.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSCarMaintainDetailContentView.h"

#import "CWSCarMaintainInfoModel.h"

@implementation CWSCarMaintainDetailContentView{

    UILabel* titleLabel;
    
    UIImageView* signImageView;
    
    UILabel* priceLabel;
    
    UILabel* titleDetailLabel;

}



//-(instancetype)initWithFrame:(CGRect)frame{
//    
//    if(self = [super initWithFrame:frame]){
//    
//        [self createUI];
//    }
//    
//    return self;
//}



-(void)setThyModel:(CWSCarMaintainInfoModel *)thyModel{
    
    _thyModel = thyModel;
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, kSizeOfScreen.width, 18)];
    titleLabel.text = thyModel.sectionName;
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:titleLabel];
    [titleLabel sizeToFit];
    
    signImageView = [[UIImageView alloc]initWithFrame:CGRectMake((kSizeOfScreen.width-25), 10, 10, 16)];
    signImageView.image = [UIImage imageNamed:@"list_jiantou"];
    signImageView.hidden = !thyModel.isNeedShow;
    [self addSubview:signImageView];
    
    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(signImageView.frame)-60, 10, 60, 16)];
    priceLabel.font = [UIFont systemFontOfSize:15.0f];
    priceLabel.textColor = kCOLOR(249, 98, 104);
    if(thyModel.priceLabelText){
        priceLabel.hidden = NO;
        priceLabel.text = thyModel.priceLabelText;
    }
    priceLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:priceLabel];
    
    
    titleDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+10, 10, CGRectGetMinX(priceLabel.frame)-(CGRectGetMaxX(titleLabel.frame)+10), 18)];
    titleDetailLabel.font = [UIFont systemFontOfSize:14.0f];
    titleDetailLabel.textColor = [UIColor grayColor];
    titleDetailLabel.text = thyModel.sectionDetailName;
    [self addSubview:titleDetailLabel];

    
}


@end
