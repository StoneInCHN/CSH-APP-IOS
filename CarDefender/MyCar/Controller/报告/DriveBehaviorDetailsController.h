//
//  DriveBehaviorDetailsController.h
//  CarDefender
//
//  Created by 周子涵 on 15/5/23.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DriveBehaviorDetailsController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSDictionary* dataDic;
@end
