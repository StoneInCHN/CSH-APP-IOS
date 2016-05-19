//
//  NewCarWashTableHeaderView.h
//  CarDefender
//
//  Created by 万茜 on 15/12/31.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWSTableViewButtonCellDelegate.h"

@interface NewCarWashTableHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;
@property (weak, nonatomic) IBOutlet UIView *storeReviewView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeDistanceLabel;

@property (nonatomic,strong) NSDictionary *dataDic;
@property (nonatomic,assign)id <CWSTableViewButtonCellDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame Data:(NSDictionary *)dic;
@end
