//
//  OrderProcessView.m
//  CarDefender
//
//  Created by 万茜 on 15/12/8.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "OrderProcessView.h"

@interface OrderProcessView()
{
    NSDictionary *dataDic;
}
@end

@implementation OrderProcessView

- (instancetype)initWithFrame:(CGRect)frame Data:(NSDictionary *)dic
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"OrderProcessView" owner:self options:nil] lastObject];
        self.frame = frame;
        dataDic = [NSDictionary dictionaryWithDictionary:dic];
        [self showUI];
    }
    return self;
    
    
}



- (void)showUI
{
//    effective_time:有效时间：
//    add_time：下单时间；
//    service_time：保养服务时间；
//    finished_time：完成时间
    
//    status：0: 取消; 1: 未付款; 2: 预约中; 3: 完成 4:已过期  12进行中
    NSString *createDate1 = [NSString stringWithFormat:@"%@",dataDic[@"createDate"]];
    if (![createDate1 isEqualToString:@"<null>"]) {
        self.firstTimeLabel.text =  [PublicUtils conversionTimeStamp:[PublicUtils checkNSNullWithgetString:dataDic[@"createDate"]]];
    }
    NSString *paymentDate1 = [NSString stringWithFormat:@"%@",dataDic[@"paymentDate"]];
    
    if (![paymentDate1 isEqualToString:@"<null>"]) {
        self.secondTimeLabel.text = [PublicUtils conversionTimeStamp:[PublicUtils checkNSNullWithgetString:paymentDate1]];
        self.secondImageView.image = [UIImage imageNamed:@"dingdanxiangqing_baoyang1"];
        self.secondTitleLabel.textColor =[UIColor colorWithRed:33.0/255 green:167.0/255 blue:238.0/255 alpha:1];
        self.secondTimeLabel.textColor = [UIColor colorWithRed:33.0/255 green:167.0/255 blue:238.0/255 alpha:1];
        
    }
    NSString *finishiData1 = [NSString stringWithFormat:@"%@",dataDic[@"finishDate"]];
    if (![finishiData1 isEqualToString:@"<null>"]) {
        self.thirdTimeLabel.text = [PublicUtils conversionTimeStamp:[PublicUtils checkNSNullWithgetString:finishiData1]];
        self.thirdImageView.image = [UIImage imageNamed:@"dingdanxiangqing_pay1"];
        self.thirdTimeLabel.textColor =[UIColor colorWithRed:33.0/255 green:167.0/255 blue:238.0/255 alpha:1];
        self.thirdTitleLabel.textColor = [UIColor colorWithRed:33.0/255 green:167.0/255 blue:238.0/255 alpha:1];
        self.line2.backgroundColor = [UIColor colorWithRed:33.0/255 green:167.0/255 blue:238.0/255 alpha:1];
   
    }
    
    
    if (self.secondTimeLabel.text.length >0) {
        self.firstLineView.backgroundColor = KBlueColor;
        self.secondImageView.image = [UIImage imageNamed:@"dingdanxiangqing_baoyang1"];
        self.secondTimeLabel.textColor = KBlueColor;
        self.secondTitleLabel.textColor = KBlueColor;
    }
    
    if (self.thirdTimeLabel.text.length >0) {
        self.secondLineView.backgroundColor = KBlueColor;
        self.thirdImageView.image = [UIImage imageNamed:@"dingdanxiangqing_pay1"];
        self.thirdTimeLabel.textColor = KBlueColor;
        self.thirdTitleLabel.textColor = KBlueColor;
    }
    
}

- (NSString *)changeTime:(NSString *)time
{
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate* inputDate = [inputFormatter dateFromString:time];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    
    
    NSString *currentDateStr = [dateFormatter stringFromDate:inputDate];
    return currentDateStr;
}

@end
