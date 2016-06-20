//
//  SFActivityTableViewCell.h
//  CarDefender
//
//  Created by sicnu_ifox on 16/6/15.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFActivityCellDelegate.h"

@class SFActivityModel,SFWashCarModel;

@interface SFActivityTableViewCell : UITableViewCell

@property (weak, nonatomic) id<SFActivityCellDelegate>delegate; ;
@property (strong, nonatomic) SFActivityModel *activityModel;
@property (strong, nonatomic) SFWashCarModel *washCarModel;

@property (strong, nonatomic) NSString *identify;
@property (weak, nonatomic) IBOutlet UIImageView *lightImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStaticLabel;


@property (weak, nonatomic) IBOutlet UIImageView *darkImageView;
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *couponSelectedImageView;
@property (weak, nonatomic) IBOutlet UIButton *discountCouponBtn;
@property (weak, nonatomic) IBOutlet UILabel *discountCouponCounter;
@property (weak, nonatomic) IBOutlet UILabel *displayLabel2;

- (IBAction)onDetailInfo:(id)sender;
- (IBAction)getDiscountCoupon:(id)sender;

@end
