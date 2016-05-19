//
//  CWSHistoryOrderCell.h
//  CarDefender
//
//  Created by 周子涵 on 15/10/12.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWSHistoryOrder.h"
#import "CWSTableViewButtonCellDelegate.h"
@interface CWSHistoryOrderCell : UITableViewCell


@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *statueLabel;//标题
@property (nonatomic,strong)UILabel *shopNameLabel;//商家
@property (nonatomic,strong)UILabel *moneyLabel;//实付金额
@property (nonatomic,strong)UILabel *payTimeLabel;//支付时间
@property (nonatomic,strong)UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UILabel *payTimeTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageViewWidth;
@property (nonatomic,strong)CWSHistoryOrder*      order;
@property (nonatomic,assign) id <CWSTableViewButtonCellDelegate>delegate;


@end
