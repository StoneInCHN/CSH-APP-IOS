//
//  OrderCancleProcessView.m
//  CarDefender
//
//  Created by 万茜 on 15/12/8.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "OrderCancleProcessView.h"

@interface OrderCancleProcessView()
{
    NSDictionary *dataDic;
}
@end



@implementation OrderCancleProcessView

- (instancetype)initWithFrame:(CGRect)frame Data:(NSDictionary *)dic
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"OrderCancleProcessView" owner:self options:nil] lastObject];
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
    
    //    status：0: 取消; 1: 未付款; 2: 预约中; 3: 完成 4:已过期
    
    if ([PublicUtils checkNSNullWithgetString:dataDic[@"add_time"]] != nil) {
        self.firstTimeLabel.text = [self changeTime:[PublicUtils checkNSNullWithgetString:dataDic[@"add_time"]]];
    }
    
    if ([PublicUtils checkNSNullWithgetString:dataDic[@"finished_time"]] != nil) {
        self.secondTimeLabel.text = [self changeTime:[PublicUtils checkNSNullWithgetString:dataDic[@"finished_time"]]];
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
