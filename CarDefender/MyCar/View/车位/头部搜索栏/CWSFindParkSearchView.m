//
//  CWSFindParkSearchView.m
//  CarDefender
//
//  Created by 周子涵 on 15/7/31.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSFindParkSearchView.h"

@implementation CWSFindParkSearchView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //1.创建头部View
        [self creatHeadSearchView];
        //2.创建TableView
        [self creatTabelView];
        //3.设置百度搜索类
        _searcher =[[BMKSuggestionSearch alloc]init];
        _searcher.delegate = self;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
#pragma mark - 创建顶部View
-(void)creatHeadSearchView{
    //1.顶部背景
    UIView* headGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kDockHeight + kSTATUS_BAR)];
    headGroundView.backgroundColor = kMainColor;
    [self addSubview:headGroundView];
    //2.左边按钮
    UIImageView* banckImageView = [Utils imageViewWithFrame:CGRectMake(10, 33, 9, 16) withImage:[UIImage imageNamed:@"zhaochewei_jiantou.png"]];
    [headGroundView addSubview:banckImageView];
    [self getBtn:CGRectMake(0, 23, 35, 33) tag:1 forControlEvents:UIControlEventTouchUpInside fatherView:headGroundView];
    //3.右边按钮
    self.headLabel = [Utils labelWithFrame:CGRectMake(kSizeOfScreen.width - 55, 30, 45, 21) withTitle:@"我旁边" titleFontSize:kFontOfSize(15) textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
    [headGroundView addSubview:self.headLabel];
    self.headImageView = [Utils imageViewWithFrame:CGRectMake(kSizeOfScreen.width - 66, 34, 8, 13) withImage:[UIImage imageNamed:@"zhaochewei_wo.png"]];
    [headGroundView addSubview:self.headImageView];
    [self getBtn:CGRectMake(kSizeOfScreen.width - 73, 23, 73, 37) tag:2 forControlEvents:UIControlEventTouchUpInside fatherView:headGroundView];
    //4.创建Title
    UILabel* titleLabel = [Utils labelWithFrame:CGRectMake(0, 32, kSizeOfScreen.width, 18) withTitle:@"我旁边的车位" titleFontSize:kFontOfSize(18) textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
    [headGroundView addSubview:titleLabel];
    //5.创建默认搜索框
    [self creatNoramlSearchView:headGroundView];
    //6.创建搜索VIew
    [self creatSearchView];
}
#pragma mark - 创建默认搜索View
-(void)creatNoramlSearchView:(UIView*)fatherView{
    self.normalSearchView = [[UIView alloc] initWithFrame:CGRectMake(43, 25, kSizeOfScreen.width - 122, 31)];
    self.normalSearchView.backgroundColor = [UIColor whiteColor];
    [Utils setViewRiders:self.normalSearchView riders:4];
    [fatherView addSubview:self.normalSearchView];
    UIImageView* searImageView = [Utils imageViewWithFrame:CGRectMake(7, 10, 12, 12) withImage:[UIImage imageNamed:@"zhaochewei_sousuo.png"]];
    [self.normalSearchView addSubview:searImageView];
    UILabel* normalLabel = [Utils labelWithFrame:CGRectMake(27, 0, self.normalSearchView.frame.size.width - 27, self.normalSearchView.frame.size.height) withTitle:@"搜索目的地附近的车位" titleFontSize:kFontOfSize(13) textColor:[UIColor lightGrayColor] alignment:NSTextAlignmentLeft];
    [self.normalSearchView addSubview:normalLabel];
    [self getBtn:normalLabel.frame tag:3 forControlEvents:UIControlEventTouchDown fatherView:self.normalSearchView];
}
#pragma mark - 创建搜索View
-(void)creatSearchView{
    self.searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kSizeOfScreen.width, kDockHeight)];
    self.searchView.backgroundColor = kMainColor;
    self.searchView.hidden = YES;
    [self addSubview:self.searchView];
    UIView* groundView = [[UIView alloc] initWithFrame:CGRectMake(10, 6, kSizeOfScreen.width - 60, 31)];
    groundView.backgroundColor = [UIColor whiteColor];
    [Utils setViewRiders:groundView riders:4];
    [self.searchView addSubview:groundView];
    UIImageView* searImageView = [Utils imageViewWithFrame:CGRectMake(9, 9, 12, 12) withImage:[UIImage imageNamed:@"zhaochewei_sousuo.png"]];
    [groundView addSubview:searImageView];
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(35, 0, groundView.frame.size.width - 35, groundView.frame.size.height)];
    self.searchTextField.delegate = self;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.placeholder = @"搜索目的地附近的车位";
    self.searchTextField.font = kFontOfSize(13);
    [groundView addSubview:self.searchTextField];
    UIButton* cancelBtn = [Utils buttonWithFrame:CGRectMake(kSizeOfScreen.width - 56, 7, 56, 30) title:@"取消" titleColor:[UIColor whiteColor] font:kFontOfSize(17)];
    [cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = 4;
    [self.searchView addSubview:cancelBtn];
}
#pragma mark - 快速创建按钮
-(void)getBtn:(CGRect)frame tag:(int)tag forControlEvents:(UIControlEvents)controlEvents fatherView:(UIView*)fatherView{
    UIButton* btn = [[UIButton alloc] initWithFrame:frame];
    btn.tag = tag;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:controlEvents];
    [fatherView addSubview:btn];
}
#pragma mark - 创建TabelView
-(void)creatTabelView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kDockHeight+kSTATUS_BAR, kSizeOfScreen.width, kSizeOfScreen.height - kDockHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = kCOLOR(245, 245, 245);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
}
#pragma mark - tableview数据源协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@",_citysArray[indexPath.row],_districtArray[indexPath.row]];
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchTextField resignFirstResponder];
}
#pragma mark - 地图搜索代理协议
- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        _dataArray = result.keyList;
        _citysArray = result.cityList;
        _districtArray = result.districtList;
        [_tableView reloadData];
    }
    else {
        NSLog(@"抱歉，未找到结果");
        _dataArray = @[];
        [_tableView reloadData];
    }
}
#pragma mark - textField代理协议
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if (_option == nil) {
        _option = [[BMKSuggestionSearchOption alloc] init];
    }
    _option.cityname = @"重庆";
    _option.keyword  = textField.text;
    BOOL flag = [_searcher suggestionSearch:_option];
    if(flag)
    {
        NSLog(@"建议检索发送成功");
    }
    else
    {
        NSLog(@"建议检索发送失败");
    }
    return YES;
}
#pragma mark - 按钮点击事件
-(void)btnClick:(UIButton*)sender{
    [self.delegate findParkSearchViewBtnClick:(int)sender.tag];
    switch (sender.tag) {
        case 2:
        {
            
        }
            break;
        case 3:
        {
            self.searchView.hidden = NO;
            [self.searchTextField becomeFirstResponder];
        }
            break;
        case 4:
        {
            
            self.searchView.hidden = YES;
            [self.searchTextField resignFirstResponder];
        }
            break;
            
        default:
            break;
    }
}
@end
