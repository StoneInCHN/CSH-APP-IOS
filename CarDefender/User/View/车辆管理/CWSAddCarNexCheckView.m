//
//  CWSAddCarNexCheckView.m
//  CarDefender
//
//  Created by 李散 on 15/5/8.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSAddCarNexCheckView.h"

@implementation CWSAddCarNexCheckView
@synthesize datePicker = _datePicker;
-(void)loadDatePickerView
{
    chooseDate=[NSDate date];
    UIView*view1=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-162-44, self.frame.size.width, 162+44)];
    view1.backgroundColor=kCOLOR(242, 242, 242);
    [self addSubview:view1];
    
    _datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, self.frame.size.width, 162)];
    [view1 addSubview:_datePicker];
    _datePicker.datePickerMode=UIDatePickerModeDate;
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    UIButton*sureBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-20-80, 5, 80, 30)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(makeSureNextCheckTime:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:sureBtn];
    [Utils setViewRiders:sureBtn riders:4];
    [Utils setBianKuang:kMainColor Wide:1 view:sureBtn];
    
    UIButton*cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 5, 80, 30)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelChooseTime) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:cancelBtn];
    [Utils setViewRiders:cancelBtn riders:4];
    [Utils setBianKuang:kMainColor Wide:1 view:cancelBtn];
    
    UIView*view2=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-view1.frame.size.height)];
    view2.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self addSubview:view2];
    UIGestureRecognizer*gestrue=[[UIGestureRecognizer alloc]initWithTarget:self action:@selector(cancelChooseTime)];
    [view2 addGestureRecognizer:gestrue];
}
-(void)makeSureNextCheckTime:(UIButton*)sender
{
    if (chooseDate!=nil) {
        NSTimeInterval chooseTime=[chooseDate timeIntervalSince1970];
        NSTimeInterval nowTime=[[NSDate date] timeIntervalSince1970];
        
        NSDateFormatter*formatter1=[[NSDateFormatter alloc]init];
        [formatter1 setDateFormat:@"YYYY-MM-DD"];
        NSString*chooseDate1=[formatter1 stringFromDate:chooseDate];
        NSString*nowDate=[formatter1 stringFromDate:[NSDate date]];
        if ([chooseDate1 isEqualToString:nowDate]) {
            [self.delegate addCarNexCheckViewChooseDate:chooseDate];
        }else{
            if (chooseTime<nowTime) {
                [_datePicker setDate:[NSDate date] animated:YES];
                return;
            }
            [self.delegate addCarNexCheckViewChooseDate:chooseDate];
        }
    }
    for (UIView*viewSub in self.subviews) {
        [viewSub removeFromSuperview];
    }
    [self removeFromSuperview];
}
-(void)cancelChooseTime
{
    for (UIView*viewSub in self.subviews) {
        [viewSub removeFromSuperview];
    }
    [self removeFromSuperview];
}
-(void)dateChanged:(UIDatePicker*)piker
{
    chooseDate=piker.date;
}
@end
