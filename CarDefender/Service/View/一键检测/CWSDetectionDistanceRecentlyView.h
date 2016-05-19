//
//  CWSDetectionDistanceRecentlyView.h
//  CarDefender
//
//  Created by 王泰莅 on 15/12/14.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSDetectionDistanceRecentlyView : UIView

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *thisOilLabel;//本次油耗

@property (weak, nonatomic) IBOutlet UILabel *avgSpeedLabel;//平均速度

@property (weak, nonatomic) IBOutlet UILabel *avgConsumptionLabel;//平均油耗
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (instancetype)initWithFrame:(CGRect)frame controller:(UIViewController *)controller data:(NSDictionary *)data;
@end
