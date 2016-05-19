//
//  CarMaintainTableViewCell.h
//  CarDefender
//
//  Created by 王泰莅 on 15/12/6.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CWSTableViewButtonCellDelegate.h"


@class CWSCarWashDiscountModel;
@interface NewCarWashDiscountCell : UITableViewCell


/**商品名称*/
@property (strong, nonatomic) IBOutlet UILabel *projectNameLabel;


/**商品附加信息*/
@property (strong, nonatomic) IBOutlet UILabel *projectDetailNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *discountMessageLabel;
@property (weak, nonatomic) IBOutlet UIView *discountLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discountPriceLabelLead;


/**折后价格*/
@property (strong, nonatomic) IBOutlet UILabel *discountPriceLabel;


/**原价*/
@property (strong, nonatomic) IBOutlet UILabel *originalPriceLabel;


/**支付按钮*/
@property (strong, nonatomic) IBOutlet UIButton *payButton;


/**红包图片*/
@property (strong, nonatomic) IBOutlet UIImageView *redPackageImageView;


@property (nonatomic,assign)id <CWSTableViewButtonCellDelegate>delegate;
@property (nonatomic,strong) CWSCarWashDiscountModel* discountModel;

@end
