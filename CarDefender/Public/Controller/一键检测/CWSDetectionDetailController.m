//
//  CWSDetectionDetailController.m
//  CarDefender
//
//  Created by 周子涵 on 15/4/24.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSDetectionDetailController.h"

@interface CWSDetectionDetailController ()
{
    NSDictionary* _dic;
    NSString*     _selectDay;
    BOOL          _isUploadTimel;
}
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIView *dataView;

@end

@implementation CWSDetectionDetailController
-(void)reloadData{
    for (int i = 0; i < self.dataArray.count; i++) {
        UILabel* lLabel = (UILabel*)[self.dataView viewWithTag:i+1];
        UILabel* lLabel2 = (UILabel*)[self.dataView viewWithTag:i+51];
        if ([self.dataArray[i][@"date"] isKindOfClass:[NSString class]]) {
            NSString* lString = self.dataArray[i][@"date"];
            if (i == 3) {
                lString = [NSString stringWithFormat:@"%.2f",[lString floatValue]];
            }
            NSRange lRang=[lString rangeOfString:@"null"];
            if (lRang.location==NSNotFound) {
                lLabel.text = lString;
            }else{
                lLabel.text = @"-";
            }
        }else{
            _dic = self.dataArray[i][@"date"];
            if ([[NSString stringWithFormat:@"%@",_dic[@"total"]] isEqualToString:@"0"]) {
                lLabel.text = @"-";
                [self.checkBtn setTitle:@"" forState:UIControlStateNormal];
                self.checkBtn.userInteractionEnabled = NO;
            }else{
                lLabel.text = _dic[@"total"];
            }
        }
        if ([self.dataArray[i][@"type"] isEqualToString:@"2"]) {
            if (i < 2) {
                UIView* lView = [self.view viewWithTag:102 + i];
                lView.hidden = NO;
            }
            lLabel.textColor = [UIColor redColor];
            lLabel2.textColor = [UIColor redColor];
            NSString* lStr = lLabel2.text;
            NSRange lRang=[lStr rangeOfString:@"!"];
            if (lRang.location == NSNotFound) {
                lLabel2.text = [NSString stringWithFormat:@"%@ !",lLabel2.text];
            }
        }else{
            lLabel.textColor = [UIColor blackColor];
            lLabel2.textColor = kCOLOR(253, 127, 22);
            NSString* lStr = lLabel2.text;
            NSRange lRang=[lStr rangeOfString:@"!"];
            if (lRang.location != NSNotFound) {
                lLabel2.text = [lStr substringToIndex:lRang.location];
            }
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _isUploadTimel = YES;
    UIView* groundView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, kSizeOfScreen.width - 20, kSizeOfScreen.height - kDockHeight - 20)];
    groundView.backgroundColor = kCOLOR(245, 245, 245);
    [self.headView setFrame:CGRectMake(0, 0, groundView.frame.size.width, self.headView.frame.size.height)];
    [groundView addSubview:self.headView];
    UIScrollView* lScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.headView.frame.size.height + 1, groundView.frame.size.width, groundView.frame.size.height - self.headView.frame.size.height - 1)];
    [groundView addSubview:lScrollerView];
    [self.dataView setFrame:CGRectMake(0, 0, groundView.frame.size.width, self.dataView.frame.size.height)];
    lScrollerView.contentSize = CGSizeMake(0, self.dataView.frame.size.height);
    [lScrollerView addSubview:self.dataView];
    [PrivateUtils setViewRiders:groundView riders:6];
    [PrivateUtils setBianKuang:kCOLOR(204, 204, 204) Wide:1 view:groundView];
    [self.view addSubview:groundView];
    [self reloadData];
}

- (IBAction)btnClick {
    MyLog(@"ajkdha");
    NSMutableString* markStr = [NSMutableString string];
    for (NSDictionary* lDic in _dic[@"rows"]) {
        [markStr appendString:[NSString stringWithFormat:@"%@/n",lDic[@"DTC_NAME"]]];
    }
    [[[UIAlertView alloc] initWithTitle:@"故障码" message:markStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
}

- (IBAction)questions:(UIButton *)sender {
    if (sender.tag == 100) {
//        MyLog(@"保养");
        if (self.baoyangView.tag != 1000) {
            [self.baoyangView setFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height - kDockHeight)];
            self.baoyangView.tag = 1000;
            UIView* lView = [self.baoyangView viewWithTag:1];
            [PrivateUtils setViewRiders:lView riders:6];
            [self.view addSubview:self.baoyangView];
        }else{
            [self.view addSubview:self.baoyangView];
        }
        
        
    }else{
//        MyLog(@"年检");
        if (self.nianjianView.tag != 1000) {
            [self.nianjianView setFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height - kDockHeight)];
            self.nianjianView.tag = 1000;
            UIView* lView = [self.nianjianView viewWithTag:1];
//            MyLog(@"%@",[self getCurrentDate]);
//            NSDate* date1 = [NSDate date];
            
            
            NSDate* currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:3600*24*365*2];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
            
            NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:currentDate];
            int year = (int)[dateComponent year];
            int month = (int)[dateComponent month];
            int day = (int)[dateComponent day];
            _selectDay=[NSString stringWithFormat:@"%d-%02d-%02d",year,month,day];
            self.dataPicker.date = currentDate;
            [self.dataPicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
            [PrivateUtils setViewRiders:lView riders:6];
        }else{
            [self.view addSubview:self.nianjianView];
        }
    }
}

- (IBAction)submitBtnClick:(UIButton *)sender {
    if (sender.tag == 10) {
        MyLog(@"修改里程");
        if ([self.currentMileageTextField.text isEqualToString:@""] || [self.lastMileageTextField.text isEqualToString:@""]) {
            [[[UIAlertView alloc] initWithTitle:@"警告" message:@"有未填项" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return;
        }
        NSDictionary* lDic = @{@"uid":KUserManager.uid,
                               @"key":KUserManager.key,
                               @"cid":KUserManager.car.cid,
                               @"mileage":self.currentMileageTextField.text,
                               @"m_mile":self.lastMileageTextField.text};
        [ModelTool httpAppModifyMileWithParameter:lDic success:^(id object) {
            NSDictionary* dic = object;
            if ([dic[@"operationState"] isEqualToString:@"SUCCESS"]) {
                MyLog(@"%@",dic);
                MyLog(@"%@",dic[@"data"][@"msg"]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary* lDic;
                    if ([self.lastMileageTextField.text intValue] < 5000) {
                        lDic = @{@"name":@"保养状态",
                                 @"type":@"1",
                                 @"date":self.lastMileageTextField.text};
                    }else{
                        lDic = @{@"name":@"保养状态",
                                 @"type":@"2",
                                 @"date":self.lastMileageTextField.text};
                    }
                    
                    
                    [self.dataArray replaceObjectAtIndex:0 withObject:lDic];
                    [self reloadData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"jianceDataBack" object:self.dataArray];
                    [self.baoyangView removeFromSuperview];
                });
            }else{
                [[[UIAlertView alloc] initWithTitle:@"警告" message:dic[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }
            
        } faile:^(NSError *err) {
            
        }];
        return;
    }
    if (sender.tag == 11) {
        if (!_isUploadTimel) {
            [[[UIAlertView alloc] initWithTitle:@"警告" message:@"请选择今天以后的日期" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return;
        }
        NSDictionary* lDic = @{@"uid":KUserManager.uid,
                               @"key":KUserManager.key,
                               @"cid":KUserManager.car.cid,
                               @"inspect":_selectDay};
        [ModelTool httpAppModifyInspectWithParameter:lDic success:^(id object) {
            NSDictionary* dic = object;
            if ([dic[@"operationState"] isEqualToString:@"SUCCESS"]) {
                MyLog(@"%@",dic);
                MyLog(@"%@",dic[@"data"][@"msg"]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString* time = dic[@"data"][@"time"];
                    NSDictionary* lDic;
                    if ([time intValue] > 15) {
                       lDic = @{@"name":@"年检状态",
                                @"type":@"1",
                                @"date":dic[@"data"][@"time"]};
                    }else{
                        lDic = @{@"name":@"年检状态",
                                 @"type":@"2",
                                 @"date":dic[@"data"][@"time"]};
                    }
                    [self.dataArray replaceObjectAtIndex:1 withObject:lDic];
                    [self reloadData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"jianceDataBack" object:self.dataArray];
                    [self.nianjianView removeFromSuperview];
                });
            }else{
                [[[UIAlertView alloc] initWithTitle:@"警告" message:dic[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }
        } faile:^(NSError *err) {
            
        }];
        return;
    }
    [self.baoyangView removeFromSuperview];
    [self.nianjianView removeFromSuperview];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults*user=[[NSUserDefaults alloc]init];
    [user setObject:@"CWSDetectionDetailController" forKey:@"currentController"];
    [NSUserDefaults resetStandardUserDefaults];
}
-(void)viewDidDisappear:(BOOL)animated
{
    NSUserDefaults*user=[[NSUserDefaults alloc]init];
    [user setObject:@"" forKey:@"currentController"];
    [NSUserDefaults resetStandardUserDefaults];
}
-(void)dateChanged:(UIDatePicker*)sender
{
    [PrivateUtils getTime];
    NSDate*date1=(NSDate*)sender.date;
    
    
    int age=[self getTimeWithDate:date1];
    if (age<0) {
        _isUploadTimel = YES;
    }else{
        _isUploadTimel = NO;
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"选择日期不规范，请重新选择" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}
-(int)getTimeWithDate:(NSDate*)chooseDate
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
            if (day>=day1) {
                return 1;
            }else{
                age=-1;
            }
        }
    }else{
        age=-1;
    }
    return age;
    
    
}
- (IBAction)baoyangControlTouchDown {
    [self.currentMileageTextField resignFirstResponder];
    [self.lastMileageTextField resignFirstResponder];
}

- (IBAction)backPadTouchDown {
    [self.currentMileageTextField resignFirstResponder];
    [self.lastMileageTextField resignFirstResponder];
}
@end
