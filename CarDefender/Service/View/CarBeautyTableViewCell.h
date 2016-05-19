//
//  CarMaintainTableViewCell.h
//  CarDefender
//
//  Created by 王泰莅 on 15/12/6.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CWSTableViewButtonCellDelegate.h"

@interface CarBeautyTableViewCell : UITableViewCell



@property (strong, nonatomic) IBOutlet UIImageView *storeImageView;


@property (strong, nonatomic) IBOutlet UILabel *storeNameLabel;


@property (strong, nonatomic) IBOutlet UIView *storeReviewView;


@property (strong, nonatomic) IBOutlet UILabel *storeAddressLabel;


@property (strong, nonatomic) IBOutlet UILabel *storeDistanceLabel;


@property (strong, nonatomic) IBOutlet UILabel *projectNameLabel;


@property (strong, nonatomic) IBOutlet UILabel *discountPriceLabel;


@property (strong, nonatomic) IBOutlet UILabel *originalPriceLabel;


@property (strong, nonatomic) IBOutlet UIButton *payButton;



@property (nonatomic,assign)id <CWSTableViewButtonCellDelegate>delegate;


@end
