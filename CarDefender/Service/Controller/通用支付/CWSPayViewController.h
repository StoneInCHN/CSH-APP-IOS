//
//  CWSPayViewController.h
//  CarDefender
//
//  Created by 王泰莅 on 15/12/12.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSBasicViewController.h"
#import "CWSCarWashDiscountModel.h"

@interface CWSPayViewController : CWSBasicViewController

//改接口后
@property (nonatomic,strong)CWSCarWashDiscountModel *washDiscountModel;

/**是否可使用红包*/
@property (nonatomic,assign) BOOL isRedpackageUseable;

@property (nonatomic,strong) NSDictionary* dataDict;
@property (nonatomic, strong) NSString *serviceId;
@end
