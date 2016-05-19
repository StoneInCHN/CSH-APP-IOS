//
//  CWSTyreHomeController.h
//  CarDefender
//
//  Created by 李散 on 15/4/23.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "BMNavController.h"
@interface CWSTyreHomeController : BMNavController

@property (nonatomic,strong)UILabel *addressLabel;//地址
@property (nonatomic,strong)UIButton *addressButton;
@property (nonatomic,strong)UIView   *mapCustomView;//地图
@property (nonatomic,strong)UIButton *callSaveButton;//呼叫救援


@end
