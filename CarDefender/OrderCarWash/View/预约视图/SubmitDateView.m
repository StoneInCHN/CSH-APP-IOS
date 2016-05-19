//
//  SubmitDateView.m
//  CarDefender
//
//  Created by 周子涵 on 15/8/22.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "SubmitDateView.h"

@implementation SubmitDateView

- (id)initWithFrame:(CGRect)frame StarDate:(NSDate*)date  time:(NSString *)time PredeterminateViewStyle:(SubmitDateViewStyle)style{
    self = [super initWithFrame:frame];
    if (self) {
        if (style == PredeterminateStyle) {
            self = [[NSBundle mainBundle] loadNibNamed:@"SubmitDateView" owner:self options:nil][0];
        }else{
            self = [[NSBundle mainBundle] loadNibNamed:@"AnnualInspectionDateView" owner:self options:nil][0];
        }
        self.frame = frame;
        self.theTime = [time integerValue];
        _style = style;
        _currentDate = date;
        [self initData:date];
    }
    return self;
}



#pragma mark - 初始化数据
-(void)initData:(NSDate*)date{
    _isUploadTimel = YES;
//    NSDate* currentDate = date;
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
//    
//    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:currentDate];
//    int year = (int)[dateComponent year];
//    int month = (int)[dateComponent month];
//    int day = (int)[dateComponent day];
//    if (_style == PredeterminateStyle) {
//        self.datePicker.date = currentDate;
//    }else{
//        self.annualInspectionDatePicker.date = currentDate;
//    }
//    _selectDay=[NSString stringWithFormat:@"%d-%02d-%02d",year,month,day];
//    for (int i = 100; i < 103; i++) {
//        UIView* lView = [self viewWithTag:i];
//        [Utils setBianKuang:kMainColor Wide:1 view:lView];
//        [Utils setViewRiders:lView riders:10];
//    }
    for (int i = 10; i < 13; i++) {
        UIView* lView = [self viewWithTag:i];
        [Utils setViewRiders:lView riders:5];
    }
    _selectDay = [self getDate:date day:0];
    [self setUI];
    [Utils setViewRiders:self.submitBtn riders:4];
    [Utils setViewRiders:self.cancelBtn riders:4];
    [Utils setViewRiders:self.annualInspectionSubmitBtn riders:4];
    [Utils setViewRiders:self.annualInspectionCancelBtn riders:4];
}
-(void)setUI{
    self.firstDateLabel.text = [NSString stringWithFormat:@"（%@）",_selectDay];
    self.secedeDateLabel.text = [NSString stringWithFormat:@"（%@）",[self getDate:_currentDate day:1]];
    self.thirdDateLabel.text = [NSString stringWithFormat:@"（%@）",[self getDate:_currentDate day:2]];
    
    self.remainingTimeLabel = (UILabel *)[self viewWithTag:3];
    self.remainingTimeLabel.text = [NSString stringWithFormat:@"%@%ld",@"您本月剩余的预约次数为",(long)self.theTime];
}
-(NSString*)getDate:(NSDate*)date day:(int)dayNumber{
    NSString* dateStr;
    NSDate* currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:3600*24*dayNumber];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:currentDate];
    int year = (int)[dateComponent year];
    int month = (int)[dateComponent month];
    int day = (int)[dateComponent day];
    //    if (_style == PredeterminateStyle) {
    //        self.datePicker.date = currentDate;
    //    }else{
    //        self.annualInspectionDatePicker.date = currentDate;
    //    }
    dateStr=[NSString stringWithFormat:@"%d-%02d-%02d",year,month,day];
    return dateStr;
}
#pragma mark - 获取时间选择时间控件的时间差异
-(int)getTimeWithDate:(NSDate*)chooseDate isEqualSymbol:(BOOL)isEqualSymbol
{
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSDateComponents *dateComponent1 = [calendar components:unitFlags fromDate:chooseDate];
    
    int year = (int)[dateComponent year];
    int month = (int)[dateComponent month];
    int day = (int)[dateComponent day];
    
    int year1 = (int)[dateComponent1 year];
    int month1 = (int)[dateComponent1 month];
    int day1 = (int)[dateComponent1 day];
    
    _selectDay=[NSString stringWithFormat:@"%d-%02d-%02d",year1,month1,day1];
    
    int age;
    if (year>year1) {//大于的情况
        return 1;
    }else if(year==year1){//等于和大于的情况
        if (month>month1) {
            return 1;
        }else if (month == month1){
            if (isEqualSymbol) {
                if (day>=day1) {
                    return 1;
                }else{
                    age=-1;
                }
            }else{
                if (day>day1) {
                    return 1;
                }else{
                    age=-1;
                }
            }
            
        }else{
            age=-1;
        }
    }else{
        age=-1;
    }
    return age;
}
#pragma mark - 日期改变事件
- (IBAction)dataChange:(UIDatePicker *)sender {
    NSDate*date1=(NSDate*)sender.date;
    int age;
    if (_style == PredeterminateStyle) {
        age = [self getTimeWithDate:date1 isEqualSymbol:NO];
    }else{
        age = [self getTimeWithDate:date1 isEqualSymbol:YES];
    }
    if (age<0) {
        _isUploadTimel = YES;
    }else{
        _isUploadTimel = NO;
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"选择日期不规范，请重新选择" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}

- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag == 111) {
        MyLog(@"提交%@",_selectDay);
        [self.delegate submitDateBtnClickWithStyle:SubmitStyle Date:_selectDay];
    }else{
        MyLog(@"取消");
        [self.delegate submitDateBtnClickWithStyle:CancelStyle Date:nil];
    }
}

- (IBAction)dateClick:(UIButton *)sender {
    _firstMarkLabel.hidden = YES;
    _secedeMarkLabel.hidden = YES;
    _thirdMarkLabel.hidden = YES;
    if (sender.tag == 21) {
        _firstMarkLabel.hidden = NO;
        _selectDay = [self getDate:_currentDate day:0];
    }else if (sender.tag == 22){
        _secedeMarkLabel.hidden = NO;
        _selectDay = [self getDate:_currentDate day:1];
    }else{
        _thirdMarkLabel.hidden = NO;
        _selectDay = [self getDate:_currentDate day:2];
    }
}

- (IBAction)carManagerClick {
    MyLog(@"车辆管理");
    [self.delegate carManagerBtnClick];
}

@end
