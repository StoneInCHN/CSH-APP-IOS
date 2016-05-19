//
//  CWSRepairDetailsController.h
//  CarDefender
//
//  Created by 周子涵 on 15/4/8.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNRoutePlanModel.h"
#import "BNCoreServices.h"

@interface CWSRepairDetailsController : UIViewController<BNNaviUIManagerDelegate,BNNaviRoutePlanDelegate>
//导航类型，分为模拟导航和真实导航
@property (assign, nonatomic) BN_NaviType naviType;

@property (strong, nonatomic) NSDictionary* repairDic;
@property (strong,nonatomic) NSDictionary*alllMsgDic;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIView *imageBaseView;
@end
