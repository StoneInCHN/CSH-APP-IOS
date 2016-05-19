//
//  CWSAlarmController.m
//  CarDefender
//
//  Created by 李散 on 15/7/31.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSAlarmController.h"
#import "CWSAlarmCell.h"
#import "ModelTool.h"
@interface CWSAlarmController ()<UITableViewDataSource,UITableViewDelegate,CWSAlarmCellDelegate>
{
    UITableView*_tableView;
    
    NSMutableArray*_msgArray;
    NSArray*_alertMsgArray;
    NSArray*_titleArray;
}
@end

@implementation CWSAlarmController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    [self getData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [ModelTool stopAllOperation];
}

-(void)getData
{
    [self showHudInView:self.view hint:@"加载中..."];
    [ModelTool httpAppGainWarnWithParameter:@{@"uid":KUserManager.uid,@"key":KUserManager.key} success:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            MyLog(@"%@",object);
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                 NSString*stringMsg = object[@"data"][@"status"];
                _msgArray = [NSMutableArray arrayWithObjects:[stringMsg substringWithRange:NSMakeRange(0, 1)],[stringMsg substringWithRange:NSMakeRange(1, 1)],[stringMsg substringWithRange:NSMakeRange(2, 1)],[stringMsg substringWithRange:NSMakeRange(3, 1)],[stringMsg substringWithRange:NSMakeRange(6, 1)], nil];
                _alertMsgArray = @[@"打开震动报警，了解车辆异常震动状况",@"打开异常位移报警，了解车辆异常位移状况",@"打开水温异常报警，了解车辆水温异常状况",@"打开碰撞报警，了解车辆安全状况",@"打开供电系统异常报警，了解供电系统状况"];
                _titleArray = @[@"震动报警",@"异常位移报警",@"水温报警",@"碰撞报警",@"供电系统异常报警"];
                [self buildTableView];
            }
        });
    } faile:^(NSError *err) {
        [self hideHud];
    }];
   
}
-(void)buildTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height-kDockHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kCOLOR(245, 245, 245);
    [self.view addSubview:_tableView];
    _tableView.bounces = NO;
    
    [_tableView registerNib:[UINib nibWithNibName:@"CWSAlarmCell" bundle:nil] forCellReuseIdentifier:@"alarmID"];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _alertMsgArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20;
    }
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
        return 45;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 45)];
    view.backgroundColor = kCOLOR(245, 245, 245);
    UILabel*label = [Utils labelWithFrame:CGRectMake(15, 0, kSizeOfScreen.width-30, 45) withTitle:_alertMsgArray[section] titleFontSize:kFontOfSize(14) textColor:kCOLOR(153, 153, 153) alignment:NSTextAlignmentLeft];
    [view addSubview:label];
    if ([_msgArray[section] intValue]) {
        label.text = @"";
    }
    label.numberOfLines = 0;
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 0.1)];
    view.backgroundColor = kCOLOR(245, 245, 245);
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*alarmID = @"alarmID";
    CWSAlarmCell*cell = [tableView dequeueReusableCellWithIdentifier:@"alarmID" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CWSAlarmCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:alarmID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.currentPath = indexPath;
    cell.levelLabel.text = _titleArray[indexPath.section];
    cell.levelLabel.textColor = kCOLOR(51, 51, 51);
    cell.swithBtn.on = [_msgArray[indexPath.section] intValue];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(void)swithValueChange:(BOOL)swithOn with:(NSIndexPath *)currentPath
{
    int nubInt;
    if (currentPath.section == 4) {
        nubInt = 6;
    }else{
        nubInt = (int)currentPath.section;
    }
    [self showHudInView:self.view hint:@"加载中..."];
    [ModelTool httpAppUpWarnWithParameter:@{@"uid":KUserManager.uid,@"key":KUserManager.key,@"type":[NSString stringWithFormat:@"%d",nubInt],@"status":[NSString stringWithFormat:@"%d",swithOn]} success:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            MyLog(@"%@",object);
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                [_msgArray replaceObjectAtIndex:currentPath.section withObject:[NSString stringWithFormat:@"%d",swithOn]];
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:2];
                [_tableView reloadData];
                [UIView commitAnimations];
            }
        });
    } faile:^(NSError *err) {
        [self hideHud];
    }];
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
