//
//  NewCarWashTableHeaderView.m
//  CarDefender
//
//  Created by 万茜 on 15/12/31.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "NewCarWashTableHeaderView.h"
#import "UIImageView+WebCache.h"


@implementation NewCarWashTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame Data:(NSDictionary *)dic
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"NewCarWashTableHeaderView" owner:self options:nil] lastObject];
        self.dataDic = [dic mutableCopy];
        [self showUI];
    }
    return self;
}

- (void)showUI
{
    [self.storeImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"baseUrl"],self.dataDic[@"image_1"]]] placeholderImage:[UIImage imageNamed:@"zhaochewei_img"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
    
    self.storeNameLabel.text = self.dataDic[@"store_name"];
    self.storeAddressLabel.text = self.dataDic[@"address"];
    self.storeDistanceLabel.text = [NSString stringWithFormat:@"%.2fkm",[self.dataDic[@"distance"] floatValue]/1000];
    for(int i=0; i<[self.dataDic[@"evaluateImg"] integerValue]; i++){
        
        UIImageView* diamondImg = [[UIImageView alloc]initWithFrame:CGRectMake(i*16, 0, 15, 15)];
        diamondImg.image = [UIImage imageNamed:@"haoping"];
        [self.storeReviewView addSubview:diamondImg];
        if(i == [self.dataDic[@"evaluateImg"] integerValue]-1){
            UILabel* reviewLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(diamondImg.frame)+4, 0, kSizeOfScreen.width, 13)];
            reviewLabel.text = [NSString stringWithFormat:@"%@好评",self.dataDic[@"evaluate"]];
            reviewLabel.font = [UIFont systemFontOfSize:15.0f];
            reviewLabel.textColor = kCOLOR(255, 102, 0);
            [self.storeReviewView addSubview:reviewLabel];
        }
    }
}

- (IBAction)buttonCilck:(UIButton *)sender {    
    if([self.delegate respondsToSelector:@selector(selectTableViewButtonClicked:Red:ID:andDataDict:)]){
        //把是否支持红包支付的值赋给按钮的tag值并回传
        [self.delegate selectTableViewButtonClicked:sender Red:0 ID:[self.dataDic[@"id"] integerValue] andDataDict:self.dataDic];
    }
}

@end
