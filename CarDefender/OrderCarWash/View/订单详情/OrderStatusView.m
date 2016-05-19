//
//  OrderStatusView.m
//  CarDefender
//
//  Created by 万茜 on 15/12/8.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "OrderStatusView.h"
#import "UIImageView+WebCache.h"

@interface OrderStatusView()
{
    NSDictionary *dataDic;
}
@end

@implementation OrderStatusView

- (instancetype)initWithFrame:(CGRect)frame Data:(NSDictionary *)dic
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"OrderStatusView" owner:self options:nil] lastObject];
        self.frame = frame;
        self.statusImageView = (UIImageView *)[self viewWithTag:1];
        self.statusLabel = (UILabel *)[self viewWithTag:2];
        dataDic = [NSDictionary dictionaryWithDictionary:dic];
        [self showUI];
    }
    return self;
    
    
}


- (void)showUI
{
    
}

@end
