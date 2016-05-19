//
//  CWSDetectionController.m
//  CarDefender
//  一键检测详情
//  Created by 周子涵 on 15/4/7.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSDetectionController.h"
#import "CWSDetectionCell.h"
#import "CWSDetectionDescriptionController.h"
#import "CWSMalfunctionController.h"

@interface CWSDetectionController ()<DetectionCellDelegate>
{
    UITableView* _tableView;
    
    NSMutableArray* _carStateArray;          //车辆状态
    NSMutableArray* _maintenanceStateArray;  //养护状态
    NSMutableArray* _faultDetectionArray;    //故障检测
    
    NSString*       _selectDay;
    BOOL            _isUploadTimel;
}
@end

@implementation CWSDetectionController
-(void)getData{
    

    for (int i = 0; i<[self.dataDic[@"list"] count]; i++) {
        NSDictionary*dic = self.dataDic[@"list"][i];
        if ([dic[@"type"] isEqualToString:@"1"]) {
            [_carStateArray insertObject:dic atIndex:_carStateArray.count];
        }else if ([dic[@"type"] isEqualToString:@"2"]){
            [_maintenanceStateArray insertObject:dic atIndex:_maintenanceStateArray.count];
        }else if ([dic[@"type"] isEqualToString:@"3"]){
            NSArray* lArray = dic[@"value"];
            int temp = (int)lArray.count;
            if (temp) {
                self.faultLabel.text = [NSString stringWithFormat:@"%i个故障",temp];
                self.faultLabel.textColor = kInsertRedColor;
                for (NSDictionary* lDic in dic[@"value"]) {
                    [_faultDetectionArray addObject:lDic];
                }
            }else{
                self.faultLabel.text = @"未发现故障";
                [_faultDetectionArray addObject:@{@"name":@"--",
                                                  @"type":@"3"}];
            }
        }
    }
    MyLog(@"检测结果：%@",self.dataDic);
    [self setLevelLabel];
    [self setCarStateLabel];
    [self setMaintainStateLabel];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    _isUploadTimel = YES;
    self.title = @"检测详情";
    _carStateArray = [NSMutableArray array];
    _maintenanceStateArray = [NSMutableArray array];
    _faultDetectionArray = [NSMutableArray array];
    [self getData];
    [self creatUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ModelTool stopAllOperation];
}

-(void)setLevelLabel{
    NSString* synthesis = self.dataDic[@"synthesis"];
    self.levelLabel.text = synthesis;
    if ([synthesis isEqualToString:@"优秀"] || [synthesis isEqualToString:@"良好"]) {
        self.levelLabel.textColor = kInsertGreenColor;
    }else if ([synthesis isEqualToString:@"一般"]){
        self.levelLabel.textColor = kInsertOrangeColor;
    }else{
        self.levelLabel.textColor = kInsertRedColor;
    }
}
-(void)setCarStateLabel{
    int carState = [self.dataDic[@"carState"] intValue];
    self.carStateLabel.text = [NSString stringWithFormat:@"%i分",carState];
    if (carState >= 80) {
        self.carStateLabel.textColor = kInsertGreenColor;
    }else if (carState >= 60 && carState < 80){
        self.carStateLabel.textColor = kInsertOrangeColor;
    }else{
        self.carStateLabel.textColor = kInsertRedColor;
    }
}
-(void)setMaintainStateLabel{
    int maintainState = [self.dataDic[@"maintainState"] intValue];
    self.maintainStateLabel.text = [NSString stringWithFormat:@"%i分",maintainState];
    if (maintainState >= 80) {
        self.maintainStateLabel.textColor = kInsertGreenColor;
    }else if (maintainState >= 60 && maintainState < 80){
        self.maintainStateLabel.textColor = kInsertOrangeColor;
    }else{
        self.maintainStateLabel.textColor = kInsertRedColor;
    }
}
#pragma mark - 创建视图
-(void)creatUI{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home_jiance.png"] style:UIBarButtonItemStyleDone target:self action:@selector(rightClick)];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height - kDockHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = self.headView;
    _tableView.tableFooterView = [[UIView alloc]init];
}
#pragma mark - 右侧按钮点击事件
-(void)rightClick
{
    CWSDetectionDescriptionController* detecVC = [[CWSDetectionDescriptionController alloc] init];
    [self.navigationController pushViewController:detecVC animated:YES];
}

#pragma mark - tableView数据源协议
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger i = 0;
    if (section == 0) {
        i = _carStateArray.count;
    }else if (section == 1){
        i = _maintenanceStateArray.count;
    }else if (section == 2){
        i = _faultDetectionArray.count;
    }
    return i;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 42;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 42)];
    view.backgroundColor = KBlackMainColor;
    if (section == 0) {
        view = self.carStateview;
    }else if (section == 1) {
        view = self.maintainStateView;
    }else if (section == 2) {
        view = self.faultDetectionView;
    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 0)];
    return view;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"detectionCell";
    CWSDetectionCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CWSDetectionCell" owner:self options:nil][0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.delegate = self;
    }
    
    if (indexPath.section == 0) {
        [cell reloadData:_carStateArray[indexPath.row]];
    }else if (indexPath.section == 1) {
        [cell reloadData:_maintenanceStateArray[indexPath.row]];
    }else if(indexPath.section == 2) {
        [cell reloadData:_faultDetectionArray[indexPath.row]];
    }
    
    return cell;
}

#pragma mark - tableView代理协议
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}

#pragma mark - tableViewCell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        NSDictionary* dic = _faultDetectionArray[indexPath.row];
        if ([dic[@"name"] rangeOfString:@"-"].location == NSNotFound) {
            CWSMalfunctionController* lController = [[CWSMalfunctionController alloc] init];
            lController.dataDic = dic;
            lController.title = @"故障详情";
            [self.navigationController pushViewController:lController animated:YES];
        }
    }
}

#pragma mark - Cell点击代理协议
-(void)detectionCellClick:(NSDictionary *)dicMsg{
    
    if ([dicMsg[@"name"] isEqualToString:@"距下次年检"]) {
        MyLog(@"距下次年检");
        if (self.nianjianView.tag != 1000) {
            [self.nianjianView setFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height - kDockHeight)];
            self.nianjianView.tag = 1000;
            UIView* lView = [self.nianjianView viewWithTag:1];
            
            
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
            [Utils setViewRiders:lView riders:6];
        }else{
            [self.view addSubview:self.nianjianView];
        }
    }else{
        MyLog(@"距离上次保养");
        if (self.baoyangView.tag != 1000) {
            [self.baoyangView setFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height - kDockHeight)];
            self.baoyangView.tag = 1000;
            UIView* lView = [self.baoyangView viewWithTag:1];
            [Utils setViewRiders:lView riders:6];
            [self.view addSubview:self.baoyangView];
        }else{
            [self.view addSubview:self.baoyangView];
        }
    }
}

#pragma mark - 日期改变事件
-(void)dateChanged:(UIDatePicker*)sender
{
    NSDate*date1=(NSDate*)sender.date;
    
    
    int age = [self getTimeWithDate:date1];
    if (age<0) {
        _isUploadTimel = YES;
    }else{
        _isUploadTimel = NO;
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"选择日期不规范，请重新选择" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}

#pragma mark - 获取时间选择时间控件的时间差异
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
        }else{
            age=-1;
        }
    }else{
        age=-1;
    }
    return age;
}

#pragma mark - 修改养护状态按钮点击事件
- (IBAction)submitBtnClick:(UIButton *)sender{
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
        [MBProgressHUD showMessag:@"数据请求中..." toView:self.view];
        [ModelTool httpAppModifyMileWithParameter:lDic success:^(id object) {
            NSDictionary* dic = object;
            if ([dic[@"operationState"] isEqualToString:@"SUCCESS"]) {
                MyLog(@"%@",dic);
                MyLog(@"%@",dic[@"data"][@"msg"]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary* lDic;
                    if ([self.lastMileageTextField.text intValue] < 5000) {
                        lDic =  @{@"name":@"距离上次保养",
                                  @"type":@"2",
                                  @"unit":@"(km)",
                                  @"fault":@"0",
                                  @"value":self.lastMileageTextField.text};
                    }else{
                        lDic =  @{@"name":@"距离上次保养",
                                  @"type":@"2",
                                  @"unit":@"(km)",
                                  @"fault":@"1",
                                  @"value":self.lastMileageTextField.text};
                    }
                    [_maintenanceStateArray replaceObjectAtIndex:0 withObject:lDic];
                    [_tableView reloadData];
                    [self.baoyangView removeFromSuperview];
                });
            }else{
                [[[UIAlertView alloc] initWithTitle:@"警告" message:dic[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }
            [self performSelector:@selector(dateLate) withObject:nil afterDelay:0.5];
        } faile:^(NSError *err) {
            [self performSelector:@selector(dateLate) withObject:nil afterDelay:0.5];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错,请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
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
        [MBProgressHUD showMessag:@"数据请求中..." toView:self.view];
        [ModelTool httpAppModifyInspectWithParameter:lDic success:^(id object) {
            NSDictionary* dic = object;
            if ([dic[@"operationState"] isEqualToString:@"SUCCESS"]) {
                MyLog(@"%@",dic);
                MyLog(@"%@",dic[@"data"][@"msg"]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString* time = dic[@"data"][@"time"];
                    NSDictionary* lDic;
                    if ([time intValue] > 15) {
                        lDic =  @{@"name":@"距下次年检",
                                  @"type":@"2",
                                  @"unit":@"(天)",
                                  @"fault":@"0",
                                  @"value":dic[@"data"][@"time"]};
                    }else{
                        lDic =  @{@"name":@"距下次年检",
                                  @"type":@"2",
                                  @"unit":@"(天)",
                                  @"fault":@"1",
                                  @"value":dic[@"data"][@"time"]};
                    }
                    [_maintenanceStateArray replaceObjectAtIndex:1 withObject:lDic];
                    [_tableView reloadData];
                    [self.nianjianView removeFromSuperview];
                });
            }else{
                [[[UIAlertView alloc] initWithTitle:@"警告" message:dic[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }
            [self performSelector:@selector(dateLate) withObject:nil afterDelay:0.5];
        } faile:^(NSError *err) {
            [self performSelector:@selector(dateLate) withObject:nil afterDelay:0.5];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错,请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }];
        return;
    }
    [self.baoyangView removeFromSuperview];
    [self.nianjianView removeFromSuperview];

}
-(void)dateLate
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
#pragma mark - 修改养护状态背景收键盘
- (IBAction)baoyangControlTouchDown {
    [self.currentMileageTextField resignFirstResponder];
    [self.lastMileageTextField resignFirstResponder];
}

- (IBAction)backPadTouchDown {
    [self.currentMileageTextField resignFirstResponder];
    [self.lastMileageTextField resignFirstResponder];
}
@end
