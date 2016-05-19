//
//  CWSTyreDetailController.h
//  CarDefender
//
//  Created by 李散 on 15/4/24.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNRoutePlanModel.h"
#import "BNCoreServices.h"

@interface CWSTyreDetailController : UIViewController<BNNaviUIManagerDelegate,BNNaviRoutePlanDelegate>
//导航类型，分为模拟导航和真实导航
@property (assign, nonatomic) BN_NaviType naviType;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSDictionary* repairDic;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIView *imageBaseView;
@property (weak, nonatomic) IBOutlet UILabel *companyName;

@end
