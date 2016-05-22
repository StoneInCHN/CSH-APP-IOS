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
    NSString*url=[NSString stringWithFormat:@"%@/csh-interface%@",SERVERADDRESS, self.dataDic[@"photo"]];
    NSLog(@"租户logo地址：%@", url);
    NSURL *logoImgUrl=[NSURL URLWithString:url];
    [self.storeImageView setImageWithURL:logoImgUrl placeholderImage:[UIImage imageNamed:@"zhaochewei_img"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
    
    self.storeNameLabel.text = self.dataDic[@"tenantName"];
    self.storeAddressLabel.text = self.dataDic[@"address"];
    self.storeDistanceLabel.text = [NSString stringWithFormat:@"%@km", self.dataDic[@"distance"]];
    
    NSString *praiseRate;
    if ([self.dataDic[@"praiseRate"] isKindOfClass:[NSNull class]]) {
        praiseRate = @"0";
    } else {
        praiseRate = self.dataDic[@"praiseRate"];
    }
    for(int i=0; i<[praiseRate integerValue]; i++){
        UIImageView* diamondImg = [[UIImageView alloc]initWithFrame:CGRectMake(i*16, 0, 15, 15)];
        diamondImg.image = [UIImage imageNamed:@"haoping"];
        [self.storeReviewView addSubview:diamondImg];
    }

    
}

- (IBAction)buttonCilck:(UIButton *)sender {    
    if([self.delegate respondsToSelector:@selector(selectTableViewButtonClicked:Red:ID:andDataDict:)]){
        //把是否支持红包支付的值赋给按钮的tag值并回传
        [self.delegate selectTableViewButtonClicked:sender Red:0 ID:[self.dataDic[@"id"] integerValue] andDataDict:self.dataDic];
    }
}

@end
