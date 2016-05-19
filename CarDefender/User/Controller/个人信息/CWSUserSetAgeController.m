//
//  CWSUserSetAgeController.m
//  CarDefender
//
//  Created by 李散 on 15/4/14.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSUserSetAgeController.h"

@interface CWSUserSetAgeController ()
{
    NSString*_birthDay;
}
@end

@implementation CWSUserSetAgeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    [self.dataPicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem*rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(chooseAgeOk:)];
    self.navigationItem.rightBarButtonItem=rightBtn;
    
    CGRect ageFrame = self.ageView.frame;
    ageFrame.origin.y+=kTO_TOP_DISTANCE;
    self.ageView.frame = ageFrame;
}
-(void)chooseAgeOk:(UIBarButtonItem*)sender
{
    if (self.ageLabel.text.length) {
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"chooseAgeMsgBack" object:@{@"age":self.ageLabel.text,@"birthday":_birthDay}];
    }else{
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"还没有选择出生日期" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void)dateChanged:(UIDatePicker*)sender
{
    NSDate*date1=(NSDate*)sender.date;
    
    
    int age=[self getTimeWithDate:date1];
    if (age<0) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"选择日期不规范，请重新选择" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }else{
        self.ageLabel.text=[NSString stringWithFormat:@"%d",age];
    }
}
-(int)getTimeWithDate:(NSDate*)chooseDate
{
    NSDate *now = [NSDate date];
    NSTimeInterval time = [now timeIntervalSince1970];
    
    
    NSTimeInterval timeChoose=[chooseDate timeIntervalSince1970];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"YYYY-MM-DD"];
    _birthDay = [formatter1 stringFromDate:chooseDate];
    int age=0;
    if (timeChoose>=time) {
//        age=-1;
        [self.dataPicker setDate:now animated:YES];
    }else{
        int ageInt=time-timeChoose;
        age=ageInt/(60*60*24)/365;
    }
    
    return age;
    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
//    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
//    
//    NSDateComponents *dateComponent1 = [calendar components:unitFlags fromDate:chooseDate];
//    
//    int year = (int)[dateComponent year];
//    int month = (int)[dateComponent month];
//    int day = (int)[dateComponent day];
//    
//    int year1 = (int)[dateComponent1 year];
//    int month1 = (int)[dateComponent1 month];
//    int day1 = (int)[dateComponent1 day];
//    
//    _birthDay=[NSString stringWithFormat:@"%d-%d-%d",year1,month1,day1];
//    
//    int age;
//    if (year>year1) {//大于的情况
//        age=year-year1;
//        if (month>month1) {
////            age;
//        }else if(month<month1){
//            age=age-1;
//        }else{
//            if (day>=day1) {
//                age=age+1;
//            }else{
//                age=age-1;
//            }
//        }
//    }else if(year==year1){//等于和大于的情况
//        if (month>=month1) {
//            if (day>=day1) {
//                age=0;
//            }else{
//                age=-1;
//            }
//        }else{
//            age=-1;
//        }
//    }else{
//        age=-1;
//    }
//    return age;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
