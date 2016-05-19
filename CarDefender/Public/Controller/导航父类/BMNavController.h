//
//  BMNavController.h
//  CarDefender
//
//  Created by 周子涵 on 15/8/7.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNRoutePlanModel.h"
#import "BNCoreServices.h"

@interface BMNavController : UIViewController<BNNaviUIManagerDelegate,BNNaviRoutePlanDelegate>

@property (assign, nonatomic) BN_NaviType naviType;
- (void)startNaviWithNewPoint:(CLLocationCoordinate2D)newPoint OldPoint:(CLLocationCoordinate2D)oldPoint;
@end
