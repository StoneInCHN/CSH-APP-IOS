//
//  CWSPurchaseRecomCell.h
//  carLife
//
//  Created by MichaelFlynn on 12/2/15.
//  Copyright © 2015 王泰莅. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CWSTableViewButtonCellDelegate.h"

@interface CWSPurchaseRecomCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *purchaseTitleLabel; //物品名称

@property (weak, nonatomic) IBOutlet UILabel *discountLabel; //优惠价

@property (strong, nonatomic) IBOutlet UILabel *originalPriceLabel; //原价


@property (strong, nonatomic) IBOutlet UILabel *comfimLabel; //支付


@property (weak, nonatomic) IBOutlet UIImageView *redImageView;
@property (weak, nonatomic) IBOutlet UILabel *discountMessageLabel;

@property (nonatomic,copy)    NSString* commodityId; //商品ID

@property (nonatomic,strong)  NSDictionary* thyCommodityDict; //商品信息字典

@property (nonatomic,assign) id <CWSTableViewButtonCellDelegate>delegate;


@end
