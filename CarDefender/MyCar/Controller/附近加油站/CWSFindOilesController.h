//
//  CWSFindOilesController.h
//  CarDefender
//
//  Created by 周子涵 on 15/4/11.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNRoutePlanModel.h"
#import "BNCoreServices.h"

@interface CWSFindOilesController : UIViewController<BNNaviUIManagerDelegate,BNNaviRoutePlanDelegate>
{
    NSDictionary* _currentDic;
}
//导航类型，分为模拟导航和真实导航
@property (assign, nonatomic) BN_NaviType naviType;

@property (strong, nonatomic) NSDictionary* dataDic;
@property (strong, nonatomic) NSString* type;

@property (weak, nonatomic) IBOutlet UILabel *footNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *footAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *footDistanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *footDistanceBtn;
@property (weak, nonatomic) IBOutlet UIButton *trafficBtn;

@property (strong, nonatomic) IBOutlet UIView *footView;
- (IBAction)qiehuanbtnClick:(UIButton *)sender;
- (IBAction)goBtnClick;


- (IBAction)addBtnClick:(UIButton *)sender;
@end
