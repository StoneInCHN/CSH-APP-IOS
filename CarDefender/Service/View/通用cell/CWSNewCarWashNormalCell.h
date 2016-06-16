//
//  CWSNewCarWashNormalCell.h
//  CarDefender
//
//  Created by 王泰莅 on 15/12/10.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWSTableViewButtonCellDelegate.h"

@class CWSCarWashNormalModel;
@interface CWSNewCarWashNormalCell : UITableViewCell



@property (strong, nonatomic) IBOutlet UILabel *productNameLabel;


@property (strong, nonatomic) IBOutlet UIButton *payButton;


@property (strong, nonatomic) IBOutlet UILabel *priceLabel;


@property (nonatomic,strong)  CWSCarWashNormalModel* normalModel;

@property (nonatomic,strong) CWSCarWashDiscountModel* discountModel;

@property (nonatomic,assign) id <CWSTableViewButtonCellDelegate> delegate;

@end
