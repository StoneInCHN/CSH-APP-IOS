//
//  CarMaintainTableViewCell.h
//  CarDefender
//
//  Created by 王泰莅 on 15/12/6.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CWSTableViewButtonCellDelegate.h"

@interface NewCarWashTableViewCell : UITableViewCell



@property (strong, nonatomic) IBOutlet UILabel *projectNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *discountPriceLabel;

@property (strong, nonatomic) IBOutlet UILabel *originalPriceLabel;

@property (strong, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIImageView *redImageView;

@property (nonatomic,strong) NSDictionary *dataDic;
@property (nonatomic,assign)id <CWSTableViewButtonCellDelegate>delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Data:(NSDictionary *)dic;

@end
