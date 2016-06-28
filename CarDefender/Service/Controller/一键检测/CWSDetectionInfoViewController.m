//
//  CWSDetectionDetailViewController.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/17.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSDetectionInfoViewController.h"

#define CELL_HEIGHT 45.0f
@interface CWSDetectionInfoViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView* myTableView;
    NSArray* detections;
    NSArray *normalValues;
}
@end

@implementation CWSDetectionInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"检测项说明";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [Utils changeBackBarButtonStyle:self];
    [self createTableView];
    detections = @[@"总里程(km)",@"空燃比系数",@"蓄电池电压(V)",@"节气门开度",@"发动机负荷(%)",
                  @"发动机运行时间(S)",@"百公里油耗(L/km)",@"剩余油量(L)",@"转速(rad/m)",@"(km/h)",
                  @"环境温度(ºC)",@"水温(ºC)",@"OBD时间",@"距上次保养(km)",@"距下次年审(天)",@"故障码"];
    normalValues = @[@"-",@"-",@"11.5~15.0",@"0~100",@"1~100",
                     @"-",@"-",@"-",@"0~6000",@"0~160",
                     @"-40~60",@"-40~110",@"-",@"5000",@"15",@"-"];
}
#pragma mark -CreateUI
-(void)createTableView{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height-kDockHeight) style:UITableViewStylePlain];
    myTableView.backgroundColor = KGrayColor3;
    myTableView.rowHeight = CELL_HEIGHT;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.bounces = YES;
    myTableView.showsHorizontalScrollIndicator = NO;
    myTableView.showsVerticalScrollIndicator = NO;
    [self setExtraCellLineHidden:myTableView];
    [self.view addSubview:myTableView];
}

#pragma mark -TableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return detections.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetectItemCell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DetectItemCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    cell.textLabel.text = detections[indexPath.row];
    cell.detailTextLabel.text = normalValues[indexPath.row];
    return cell;
}
#pragma mark -TableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CELL_HEIGHT;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, CELL_HEIGHT)];
    sectionHeaderView.backgroundColor = [UIColor whiteColor];
    
    UILabel* headerNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, kSizeOfScreen.width, 16)];
    headerNameLabel.textColor = KBlueColor;
    headerNameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    headerNameLabel.text = @"检测项";
    [sectionHeaderView addSubview:headerNameLabel];
    
    UILabel* delerationLabel = [[UILabel alloc]initWithFrame:CGRectMake(kSizeOfScreen.width-85, 15, 70, 16)];
    delerationLabel.textColor = KBlueColor;
    delerationLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    delerationLabel.text = @"正常范围";
    delerationLabel.textAlignment = NSTextAlignmentCenter;
    [sectionHeaderView addSubview:delerationLabel];
    
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, sectionHeaderView.frame.size.height-1, kSizeOfScreen.width, 1)];
    lineView.backgroundColor = KGrayColor2;
    [sectionHeaderView addSubview:lineView];
    
    return sectionHeaderView;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark -OtherCallBack
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
-(void)viewDidLayoutSubviews{
    if ([myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

@end
