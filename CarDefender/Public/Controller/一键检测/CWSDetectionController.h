//
//  CWSDetectionController.h
//  CarDefender
//
//  Created by 周子涵 on 15/4/7.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "graphicView.h"

@interface CWSDetectionController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *carStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *maintainStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *faultLabel;
@property (strong, nonatomic) IBOutlet UIView *carStateview;
@property (strong, nonatomic) IBOutlet UIView *maintainStateView;
@property (strong, nonatomic) IBOutlet UIView *faultDetectionView;
@property (strong, nonatomic) NSDictionary* dataDic;

@property (strong, nonatomic) IBOutlet UIView *baoyangView;
@property (strong, nonatomic) IBOutlet UIView *nianjianView;
@property (weak, nonatomic) IBOutlet UITextField *currentMileageTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastMileageTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;

- (IBAction)submitBtnClick:(UIButton *)sender;
- (IBAction)baoyangControlTouchDown;
- (IBAction)backPadTouchDown;
@end
