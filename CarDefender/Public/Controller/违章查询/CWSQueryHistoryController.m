//
//  CWSQueryHistoryController.m
//  CarDefender
//
//  Created by 李散 on 15/6/30.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSQueryHistoryController.h"
#import "CWSQueryHistoryCell.h"
#import "CWSQueryResultController.h"
@interface CWSQueryHistoryController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*_tableView;
    NSMutableArray*_dataArray;
    
    NSIndexPath *deleIndexPath;
}
@end

@implementation CWSQueryHistoryController
//记录当前正在执行的操作，0代表删除，1代表插入
NSUInteger action;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查询历史";
    [Utils changeBackBarButtonStyle:self];
    [self buildUI];
    [self getData];
}
-(void)getData
{
    _dataArray = [NSMutableArray arrayWithArray:@[
                                                  @{@"carImg":@"",@"carNub":@"渝A12345",@"time":@"一天前"},
                                                  @{@"carImg":@"",@"carNub":@"渝A12345",@"time":@"一天前"},
                                                  @{@"carImg":@"",@"carNub":@"渝A12345",@"time":@"一天前"},
                                                  @{@"carImg":@"",@"carNub":@"渝A12345",@"time":@"一天前"}
                                                  ]];
    if (_dataArray.count) {
       
    }
}
-(void)buildUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = kCOLOR(245, 245, 245);
    [_tableView registerNib:[UINib nibWithNibName:@"CWSQueryHistoryCell" bundle:nil] forCellReuseIdentifier:@"historyCell"];
    _tableView.tableHeaderView = self.topView;
    _tableView.tableFooterView = self.downView;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(clearAllMsgClick)];
}
-(void)clearAllMsgClick
{
    [_dataArray removeAllObjects];
    [_tableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellID = @"historyCell";
    CWSQueryHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CWSQueryHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CWSQueryResultController*resultVC = [[CWSQueryResultController alloc]initWithNibName:@"CWSQueryResultController" bundle:nil];
    [self.navigationController pushViewController:resultVC animated:YES];
}
#pragma mark -
#pragma mark Table view delegate
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_dataArray removeObjectAtIndex:indexPath.row];
    [_tableView reloadData];
    if (!_dataArray.count) {
        _tableView.tableHeaderView = nil;
        _tableView.tableFooterView = nil;
    }
    deleIndexPath=indexPath;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
