//
//  CWSDetectionDetailController.h
//  CarDefender
//
//  Created by 周子涵 on 15/4/24.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSDetectionDetailController : UIViewController
@property (strong, nonatomic) NSMutableArray* dataArray;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@property (strong, nonatomic) IBOutlet UIView *baoyangView;
@property (strong, nonatomic) IBOutlet UIView *nianjianView;
@property (weak, nonatomic) IBOutlet UITextField *currentMileageTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastMileageTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;


- (IBAction)btnClick;
- (IBAction)questions:(UIButton *)sender;
- (IBAction)submitBtnClick:(UIButton *)sender;
- (IBAction)baoyangControlTouchDown;
- (IBAction)backPadTouchDown;

@end
