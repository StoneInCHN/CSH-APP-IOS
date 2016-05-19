//
//  CWSPayInfoView.h
//  CarDefender
//
//  Created by 王泰莅 on 15/12/12.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSPayInfoView : UIView


@property (strong, nonatomic) IBOutlet UIView *validPeriodView;


@property (strong, nonatomic) IBOutlet UILabel *storeNameLabel;


@property (strong, nonatomic) IBOutlet UILabel *goodsNameLabel;


@property (strong, nonatomic) IBOutlet UILabel *priceLabel;


@property (nonatomic,strong) NSDictionary* dataDict;

@end
