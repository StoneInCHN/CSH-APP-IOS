//
//  CWSQueryResultController.m
//  LHPTextDemo
//
//  Created by 李散 on 15/6/30.
//  Copyright (c) 2015年 Mr Li. All rights reserved.
//

#import "CWSQueryResultController.h"
#import "CWSQueryResultCellCell.h"
@interface CWSQueryResultController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*_tableView;
    NSMutableArray*_dataArray;
}
@end

@implementation CWSQueryResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查询结果";
    [Utils changeBackBarButtonStyle:self];
    [self getData];
    [self buildUI];
}
-(void)getData
{
    _dataArray = [NSMutableArray arrayWithObjects:@[ @{@"first":@"驾驶中型以上载客载货汽车、校车危险物品运输车连刚以为的其他机动车在高速公路以外的道路上行驶超过规定时速以上未达型以上载客载货汽车。"}]
                                                    ,
                                                    @[
                                                    @{@"first":@"驾驶中型以上载客载货汽车、校车危险物品运输车连刚以"}
                                                    ]
                                                    ,
                                                    nil];
}
-(void)buildUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = self.topView;
    _tableView.tableFooterView = self.downLabel;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CWSQueryResultCellCell heightForCellWithContentForCellDict:_dataArray[indexPath.section][indexPath.row]];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 23;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1]
;
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0.1)];
    view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1]
    ;
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellID = @"resultID";
    CWSQueryResultCellCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CWSQueryResultCellCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.typeDic = _dataArray[indexPath.section][indexPath.row];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
