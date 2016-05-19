//
//  CWSParkTabelView.m
//  CarDefender
//
//  Created by 周子涵 on 15/8/6.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSParkTabelView.h"

@implementation CWSParkTabelView
- (id)initWithFrame:(CGRect)frame DataArray:(NSArray*)dataArray;
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = dataArray;
        [self creatTableView];
    }
    return self;
}
- (void)reloadData:(NSArray*)dataArray{
    _dataArray = dataArray;
    [_tableView reloadData];
}
#pragma mark - 创建tableView
-(void)creatTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height - kDockHeight-40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = kCOLOR(245, 245, 245);
    [self addSubview:_tableView];
}
#pragma mark - tableView数据源协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"findParkCell";
    FindParkCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FindParkCell" owner:self options:nil][0];
        cell.delegate = self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    Park* park = _dataArray[indexPath.row];
//    cell.park = park;
    [cell reloadCell:park];
    return cell;
}
#pragma mark - TabelView代理协议
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Park* park = _dataArray[indexPath.row];
    [self.delegate parkTabelViewCellClick:park];
}
#pragma mark - tableView代理协议
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 87;
}
#pragma mark - Cell代理协议
-(void)cellNavBtnClick:(Park *)park{
    [self.delegate parkTabelViewNavClick:park];
}
-(void)cellOrderBtnClick:(Park *)park{
    [self.delegate parkTabelViewOrderClick:park];
}
@end
