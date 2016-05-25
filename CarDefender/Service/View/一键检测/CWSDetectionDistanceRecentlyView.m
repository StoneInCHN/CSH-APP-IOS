//
//  CWSDetectionDistanceRecentlyView.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/14.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSDetectionDistanceRecentlyView.h"
#import "CWSCarReportViewController.h"

@interface CWSDetectionDistanceRecentlyView(){
    NSDictionary *dataDic;
    UIViewController *rootController;
}

@end

@implementation CWSDetectionDistanceRecentlyView


- (instancetype)initWithFrame:(CGRect)frame controller:(UIViewController *)controller data:(NSDictionary *)data
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"CWSDetectionDistanceRecentlyView" owner:self options:nil] lastObject];
        self.frame = frame;
        rootController = controller;
        dataDic = [data mutableCopy];
        [self showUI];
    }
    return self;
}


- (void)showUI{
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int date = (long long int)time;
    date = date - 60*60*24;
    NSDate *dateNew = [NSDate dateWithTimeIntervalSince1970:date];
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"YYYY-MM-dd"];
    NSString *stringDate = [form stringFromDate:dateNew];
    self.dateLabel.text = stringDate;
    self.thisOilLabel.text = [self changeStringWithData:dataDic[@"fuelConsumption"]];
    self.avgSpeedLabel.text = [self changeStringWithData:dataDic[@"averageSpeed"]];
    self.avgConsumptionLabel.text = [NSString stringWithFormat:@"%@升/百公里",[self changeStringWithData:dataDic[@"averageFuelConsumption"]]];
    self.distanceLabel.text = [NSString stringWithFormat:@"%@公里",[self changeStringWithData:dataDic[@"mileAge"]]];
    self.timeLabel.text = [NSString stringWithFormat:@"%@分",[self changeStringWithData:dataDic[@"runningTime"]]];
    //    [self getData];
    
}
- (NSString *)changeStringWithData:(id)data {
    if ([data isKindOfClass:[NSNull class]]) {
        return @"-";
    }
    return [NSString stringWithFormat:@"%@",data];
}
#pragma mark - 日期选择

- (IBAction)selectDateButtonClicked:(UIButton *)sender {
    NSLog(@"选择日期了！");
    CWSCarReportViewController* reportVc = [CWSCarReportViewController new];
    reportVc.searchDate = self.dateLabel.text;
    [rootController.navigationController pushViewController:reportVc animated:YES];
    
}

- (NSString *)changeTime:(NSDate *)date
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    
    
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}



//后面的方法没有用到 
- (void)getData{
    [MBProgressHUD showMessag:@"正在加载..." toView:self];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:KUserManager.uid forKey:@"uid"];
    [dic setObject:KUserManager.mobile forKey:@"mobile"];
    [dic setObject:@"day" forKey:@"type"];
    [dic setObject:KUserManager.userCID forKey:@"cid"];
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int date = (long long int)time;
    date = date - 60*60*24;
    NSDate *dateNew = [NSDate dateWithTimeIntervalSince1970:date];
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"yyyy-MM-dd"];
    NSString *stringDate = [form stringFromDate:dateNew];
    [dic setObject:stringDate forKey:@"time"];
    
    [ModelTool getReportWithParameter:dic andSuccess:^(id object) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]) {
                [MBProgressHUD hideAllHUDsForView:self animated:YES];
                dataDic = [NSDictionary dictionaryWithDictionary:object[@"data"]];
                if ([self changeString:dataDic[@"oil"]]) {
                    self.thisOilLabel.text = [self changeString:dataDic[@"oil"]];
                }
                if ([self changeString:dataDic[@"avgSpeed"]]) {
                    self.avgSpeedLabel.text = [self changeString:dataDic[@"avgSpeed"]];
                }
                if ([self changeString:dataDic[@"avgOil"]]) {
                    self.avgConsumptionLabel.text = [NSString stringWithFormat:@"%@升/百公里",[self changeString:dataDic[@"avgOil"]]];
                }
                if ([self changeString:dataDic[@"mile"]]) {
                    self.distanceLabel.text = [NSString stringWithFormat:@"%@公里",[self changeString:dataDic[@"mile"]]];
                }
                if ([self changeString:dataDic[@"feeTime"]]) {
                    self.timeLabel.text = [NSString stringWithFormat:@"%@分",[self changeString:dataDic[@"feeTime"]]];
                }
                
            }
            else {
                [MBProgressHUD hideAllHUDsForView:self animated:YES];
                [[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                
            }
            
        });
        
    } andFail:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
}

- (NSString *)changeString:(NSString *)string{
    if (string == nil || [string isKindOfClass:[NSNull class]]){
        return @"-";
    }
    else {
        return string;
    }
}

@end
