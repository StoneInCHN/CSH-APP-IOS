//
//  CWSPurchaseRecomHeaderView.m
//  carLife
//
//  Created by 王泰莅 on 15/12/3.
//  Copyright © 2015年 王泰莅. All rights reserved.
//

#import "CWSPurchaseRecomHeaderView.h"
#import "UIImageView+WebCache.h"
@implementation CWSPurchaseRecomHeaderView


-(instancetype)init{
    
    if(self = [super init]){
        
        
        
    }
    
    return self;
}

-(void)setRecomHeaderDataDict:(NSDictionary *)recomHeaderDataDict{
    
    _recomHeaderDataDict = recomHeaderDataDict;
    
   // _diamondImageView.image = [UIImage imageNamed:@"haoping"];
    
    
    _appointButton.layer.cornerRadius = 10;
    _appointButton.backgroundColor = [UIColor colorWithRed:0.220f green:0.706f blue:0.902f alpha:1.00f];
    [_appointButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _nearbyButton.layer.cornerRadius = 10;
    _nearbyButton.backgroundColor = [UIColor colorWithRed:0.992f green:0.698f blue:0.380f alpha:1.00f];
    [_nearbyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _storeImageView.layer.masksToBounds = YES;
//    _storeImageView.layer.borderColor = [UIColor cyanColor].CGColor;
//    _storeImageView.layer.borderWidth = 1.0f;
//    _storeImageView.layer.cornerRadius = 5.0f;
    NSString*url=[NSString stringWithFormat:@"%@/csh-interface%@",SERVERADDRESS,recomHeaderDataDict[@"photo"]];
    NSLog(@"租户logo地址：%@", url);
    NSURL*logoImgUrl=[NSURL URLWithString:url];
    [_storeImageView setImageWithURL:logoImgUrl placeholderImage:[UIImage imageNamed:@"zhaochewei_img"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
    
    if ([recomHeaderDataDict[@"distance"] isKindOfClass:[NSNull class]]) {
        self.storeDistanceLabel.text = @"";
    } else {
        self.storeDistanceLabel.text = [NSString stringWithFormat:@"%@km",recomHeaderDataDict[@"distance"]];
    }
    self.storeTitleLabel.text = recomHeaderDataDict[@"tenantName"];
    self.storeAddressLabel.text = recomHeaderDataDict[@"address"];

    NSString *praiseRate;
    if ([recomHeaderDataDict[@"praiseRate"] isKindOfClass:[NSNull class]]) {
        praiseRate = @"0";
    } else {
        praiseRate = recomHeaderDataDict[@"praiseRate"];
    }
    for(int i=0; i<[praiseRate integerValue]; i++){
        UIImageView* diamondImg = [[UIImageView alloc]initWithFrame:CGRectMake(i*16, 0, 15, 15)];
        diamondImg.image = [UIImage imageNamed:@"haoping"];
        [self.starReviewView addSubview:diamondImg];
//        if(i == [recomHeaderDataDict[@"evaluateImg"] integerValue]-1){
//            UILabel* reviewLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(diamondImg.frame)+4, 0, kSizeOfScreen.width, 13)];
//            reviewLabel.text = [NSString stringWithFormat:@"%@好评",recomHeaderDataDict[@"evaluate"]];
//            reviewLabel.font = [UIFont systemFontOfSize:15.0f];
//            reviewLabel.textColor = kCOLOR(255, 102, 0);
//            [self.starReviewView addSubview:reviewLabel];
//        }
    }
    
}

- (IBAction)buttonCilck:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(selectTableViewButtonClicked:Red:ID:andDataDict:)]){
        //把是否支持红包支付的值赋给按钮的tag值并回传
        [self.delegate selectTableViewButtonClicked:sender Red:0 ID:[_recomHeaderDataDict[@"id"] integerValue] andDataDict:_recomHeaderDataDict];
    }
}




@end
