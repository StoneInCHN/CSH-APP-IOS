//
//  CWSReportAddCostController.h
//  报告动画
//
//  Created by 李散 on 15/5/18.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSReportAddCostController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *costText;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (IBAction)chooseTimeClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIView *chooseTimeView;
- (IBAction)cancelClick:(UIButton *)sender;
- (IBAction)sureClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (strong, nonatomic) IBOutlet UIView *footView;
- (IBAction)delegateClick:(id)sender;
@property (strong,nonatomic) NSDictionary*menuDic;

@property (weak, nonatomic) IBOutlet UITextField *oilCost;
@property(nonatomic,strong)NSString*reportTime;
@property (weak, nonatomic) IBOutlet UIButton *chooseTimeBtn;

@property (weak, nonatomic) IBOutlet UIView *costMenuView;
@property(nonatomic,strong)NSDictionary*currentCostDic;
@property(nonatomic,strong)NSString*reportRid;
@property (strong, nonatomic) IBOutlet UIView *oilBaseView;
@end
