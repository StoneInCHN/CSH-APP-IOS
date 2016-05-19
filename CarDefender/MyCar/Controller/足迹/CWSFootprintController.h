//
//  CWSFootprintController.h
//  CarDefender
//
//  Created by 周子涵 on 15/3/30.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSFootprintController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *cityNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *stopNumLabel;
@property (strong, nonatomic) IBOutlet UIView *markBackgroundView;
@property (strong, nonatomic) IBOutlet UIView *normalView;


@end
