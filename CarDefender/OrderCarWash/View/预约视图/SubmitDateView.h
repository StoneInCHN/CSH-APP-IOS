//
//  SubmitDateView.h
//  CarDefender
//
//  Created by 周子涵 on 15/8/22.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SubmitDateViewStyle){
    PredeterminateStyle = 0,               //洗车预约
    AnnualInspectionStyle = 1,             //年检
};
typedef NS_ENUM(NSInteger, SubmitDateClickStyle){
    SubmitStyle = 0,               //提交
    CancelStyle = 1,               //取消
};

@protocol SubmitDateViewDelegate <NSObject>
-(void)submitDateBtnClickWithStyle:(SubmitDateClickStyle)style Date:(NSString*)date;
-(void)carManagerBtnClick;
@end

@interface SubmitDateView : UIView
{
    SubmitDateViewStyle   _style;          //状态
    NSDate*               _currentDate;    //当前日期
    NSString*             _selectDay;      //当前日期
    BOOL                  _isUploadTimel;
   
}
@property (weak, nonatomic) IBOutlet UILabel *firstDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *secedeDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstMarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *secedeMarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdMarkLabel;
@property (strong,nonatomic)UILabel          *remainingTimeLabel;//剩余次数

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *annualInspectionSubmitBtn;
@property (weak, nonatomic) IBOutlet UIButton *annualInspectionCancelBtn;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *annualInspectionDatePicker;
@property (assign, nonatomic) id<SubmitDateViewDelegate> delegate;

@property (assign,nonatomic)NSInteger             theTime;           //剩余次数

- (id)initWithFrame:(CGRect)frame StarDate:(NSDate*)date  time:(NSString *)time PredeterminateViewStyle:(SubmitDateViewStyle)style;
- (IBAction)dataChange:(UIDatePicker *)sender;
- (IBAction)btnClick:(UIButton *)sender;
- (IBAction)dateClick:(UIButton *)sender;
- (IBAction)carManagerClick;

@end
