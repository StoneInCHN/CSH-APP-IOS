//
//  OrderStatusView.h
//  CarDefender
//
//  Created by 万茜 on 15/12/8.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderStatusView : UIView
@property (nonatomic,strong)UIImageView *statusImageView;
@property (nonatomic,strong)UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerConstraint;

- (instancetype)initWithFrame:(CGRect)frame Data:(NSDictionary *)dic;
@end
