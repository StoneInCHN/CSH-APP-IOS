//
//  CWSPurchaseRecomHeaderView.h
//  carLife
//
//  Created by 王泰莅 on 15/12/3.
//  Copyright © 2015年 王泰莅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWSTableViewButtonCellDelegate.h"
@interface CWSPurchaseRecomHeaderView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *storeImageView; //商店图片

@property (strong, nonatomic) IBOutlet UILabel *storeTitleLabel; //商店名称


@property (strong, nonatomic) IBOutlet UIView *starReviewView;  //评价视图


@property (strong, nonatomic) IBOutlet UILabel *storeAddressLabel; //商店地址

@property (strong, nonatomic) IBOutlet UILabel *storeDistanceLabel; //商店距离

@property (strong, nonatomic) IBOutlet UIButton *appointButton; //指定商店


@property (strong, nonatomic) IBOutlet UIButton *nearbyButton; //附近商店


@property (nonatomic,strong) NSDictionary* recomHeaderDataDict;
@property (nonatomic,assign)id <CWSTableViewButtonCellDelegate>delegate;
@end
