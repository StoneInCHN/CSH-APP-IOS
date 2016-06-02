//
//  CWSCarWashDetileController.h
//  CarDefender
//
//  Created by 周子涵 on 15/8/20.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMNavController.h"
#import "OrderWash.h"
#import "MyOrderDetailModel.h"
#import "CWSCarWashDiscountModel.h"
#import "CWSHistoryOrder.h"
@interface CWSCarWashDetileController : BMNavController




#if USENEWVERSION
@property (strong, nonatomic) OrderWash* orderWash;
@property (assign, nonatomic) int state;
@property (assign, nonatomic) CLLocationCoordinate2D oldPt;
@property (assign,nonatomic)NSInteger  time;
@property (assign ,nonatomic)NSInteger status;


@property (nonatomic,strong)CWSCarWashDiscountModel *washDiscountModel;
@property (nonatomic,strong)MyOrderDetailModel *myOrderDetailModel;
@property (nonatomic,assign)NSInteger tag;//支付成功查看详情点过来的
@property (nonatomic,strong) NSDictionary* dataDict; // 数据字典
@property (nonatomic,strong)CWSHistoryOrder *order; //订单
#else
@property (strong, nonatomic) OrderWash* orderWash;
@property (assign, nonatomic) int state;
@property (assign, nonatomic) CLLocationCoordinate2D oldPt;
@property (assign,nonatomic)NSInteger  time;
@property (assign ,nonatomic)NSInteger status;

#endif


@end
