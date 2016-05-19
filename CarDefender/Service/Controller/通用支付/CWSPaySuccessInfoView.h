//
//  CWSPaySuccessInfoView.h
//  CarDefender
//
//  Created by 王泰莅 on 15/12/14.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSPaySuccessInfoView : UIView


/**商家名称*/
@property (strong, nonatomic)  UILabel *storeNameLabel;


/**服务名称*/
@property (strong, nonatomic)  UILabel *productNameLabel;


/**订单金额*/
@property (strong, nonatomic)  UILabel *orderPriceLabel;


/**订单号*/
@property (strong, nonatomic)  UILabel *orderIdLabel;


/**订单有效期*/
@property (strong, nonatomic)  UILabel *orderValidityPeriodLabel;



@property (nonatomic,strong)  NSDictionary* dataDict;


//-(instancetype)initWithDict:(NSDictionary*)dataDict;

- (instancetype)initWithFrame:(CGRect)frame  Data:(NSDictionary *)dataDict;

@end
