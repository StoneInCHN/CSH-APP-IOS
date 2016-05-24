//
//  CWSCarReportViewController.h
//  CarDefender
//
//  Created by 李散 on 15/4/16.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSCarReportViewController : UIViewController
{
    BOOL _detailOrMain;//1为在详情，0不在详情
    BOOL _getDataChooseOrNor;
}
@property (strong, nonatomic) IBOutlet UIView *reportView;
@property (strong, nonatomic) IBOutlet UIView *reportView2;
@property (weak, nonatomic) IBOutlet UILabel *averageSpeed;//平均速度
@property (weak, nonatomic) IBOutlet UILabel *hundredOilConsumption;//百公里油耗

@property (weak, nonatomic) IBOutlet UILabel *totalMileage;//总里程
@property (weak, nonatomic) IBOutlet UILabel *driveTime;//驾驶时间
@property (weak, nonatomic) IBOutlet UILabel *oilConsumption;//油耗量
@property (weak, nonatomic) IBOutlet UILabel *totalCost;//费用
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel1;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel2;
@property (weak, nonatomic) IBOutlet UILabel *normalLabel1;
@property (weak, nonatomic) IBOutlet UILabel *normalLable;

@property (strong, nonatomic) NSString *searchDate;

@property (strong, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)submitBtnClick:(UIButton *)sender;
- (IBAction)groundTouchDown;

- (IBAction)findMoreBtn;
@end
