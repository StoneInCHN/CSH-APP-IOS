//
//  CWSFindParkSearchView.m
//  CarDefender
//
//  Created by 周子涵 on 15/7/31.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSFindParkSearchView.h"
#import "FindParkSearchCell.h"

@implementation CWSFindParkSearchView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //1.创建头部View
        [self creatHeadSearchView];
        //2.创建TableView
        [self creatTabelView];
        //3.获取历史数据
        [self getHistoryArray];
        //4.设置百度搜索类
        _searcher =[[BMKSuggestionSearch alloc]init];
        _searcher.delegate = self;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
#pragma mark - 获取历史数据
-(void)getHistoryArray{
    NSUserDefaults*user=[[NSUserDefaults alloc]init];
    _dataArray = [NSMutableArray arrayWithArray:[user arrayForKey:@"history"]];
    _historyArray = [NSMutableArray arrayWithArray:[user arrayForKey:@"history"]];
}
#pragma mark - 创建顶部View
-(void)creatHeadSearchView{
    //1.顶部背景
    UIView* headGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kDockHeight + kSTATUS_BAR)];
    headGroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:headGroundView];
    //2.左边按钮
    UIImageView* banckImageView = [Utils imageViewWithFrame:CGRectMake(10, 33, 9, 16) withImage:[UIImage imageNamed:@"jianyou"]];
    [headGroundView addSubview:banckImageView];
    self.headLeftLabel = [Utils labelWithFrame:CGRectMake(26, 33, 32, 18) withTitle:@"返回" titleFontSize:kFontOfSize(18) textColor:[UIColor grayColor] alignment:NSTextAlignmentCenter];
    [headGroundView addSubview:self.headLeftLabel];
    [self getBtn:CGRectMake(0, 23, 35, 33) tag:1 forControlEvents:UIControlEventTouchUpInside fatherView:headGroundView];
    //3.右边按钮
    self.headLabel = [Utils labelWithFrame:CGRectMake(kSizeOfScreen.width - 55, 30, 45, 21) withTitle:@"目的地" titleFontSize:kFontOfSize(15) textColor:KBlackMainColor alignment:NSTextAlignmentCenter];
    [headGroundView addSubview:self.headLabel];
    self.headImageView = [Utils imageViewWithFrame:CGRectMake(kSizeOfScreen.width - 66, 34, 8, 13) withImage:[UIImage imageNamed:@"zhaochewei_mudidi"]];
    [headGroundView addSubview:self.headImageView];
    [self getBtn:CGRectMake(kSizeOfScreen.width - 73, 23, 73, 37) tag:2 forControlEvents:UIControlEventTouchUpInside fatherView:headGroundView];
    //4.创建Title
    UILabel* titleLabel = [Utils labelWithFrame:CGRectMake(0, 32, kSizeOfScreen.width, 18) withTitle:@"我身边的车位" titleFontSize:kFontOfSize(18) textColor:KBlackMainColor alignment:NSTextAlignmentCenter];
    [headGroundView addSubview:titleLabel];
    //5.创建默认搜索框
    [self creatNoramlSearchView:headGroundView];
    //6.创建搜索VIew
    [self creatSearchView];
}
#pragma mark - 创建默认搜索View
-(void)creatNoramlSearchView:(UIView*)fatherView{
    self.normalSearchView = [[UIView alloc] initWithFrame:CGRectMake(43, 25, kSizeOfScreen.width - 122, 31)];
    self.normalSearchView.hidden = YES;
    self.normalSearchView.backgroundColor = [UIColor whiteColor];
    [Utils setViewRiders:self.normalSearchView riders:4];
    [fatherView addSubview:self.normalSearchView];
    UIImageView* searImageView = [Utils imageViewWithFrame:CGRectMake(7, 10, 12, 12) withImage:[UIImage imageNamed:@"zhaochewei_sousuo.png"]];
    [self.normalSearchView addSubview:searImageView];
    self.normalLabel = [Utils labelWithFrame:CGRectMake(27, 0, self.normalSearchView.frame.size.width - 27, self.normalSearchView.frame.size.height) withTitle:@"搜索目的地附近的车位" titleFontSize:kFontOfSize(13) textColor:[UIColor lightGrayColor] alignment:NSTextAlignmentLeft];
    [self.normalSearchView addSubview:self.normalLabel];
    [self getBtn:self.normalLabel.frame tag:3 forControlEvents:UIControlEventTouchDown fatherView:self.normalSearchView];
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
    //1.创建TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kDockHeight+kSTATUS_BAR, kSizeOfScreen.width, kSizeOfScreen.height - kDockHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = kCOLOR(245, 245, 245);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    //2.创建TabelView的头部View
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 35)];
    headView.backgroundColor = kCOLOR(245, 245, 245);
    UILabel* markLabel = [Utils labelWithFrame:CGRectMake(10, 10, kSizeOfScreen.width - 20, 13) withTitle:@"最近搜过" titleFontSize:kFontOfSize(13) textColor:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft];
    [headView addSubview:markLabel];
    _tableView.tableHeaderView = headView;
    //3.创建TabelView的底部View
    UIView* footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 45)];
    footView.backgroundColor = [UIColor whiteColor];
    UIButton* deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 45)];
    [deleteBtn setTitle:@" 清除历史数据" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = kFontOfSize(17);
    [deleteBtn setImage:[UIImage imageNamed:@"zhaochewei_qingchu.png"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(delegateHistory) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:deleteBtn];
    _tableView.tableFooterView = footView;
}
#pragma mark - tableview数据源协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"FindParkSearchCell";
    FindParkSearchCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FindParkSearchCell" owner:self options:nil][0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSDictionary* dic = _dataArray[indexPath.row];
    cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",dic[@"city"],dic[@"district"]];
    cell.nameLabel.text = dic[@"key"];
    if (_tableView.tableHeaderView == nil) {
        cell.imageView.image = [UIImage imageNamed:@"zhaochewei_sousuo.png"];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"zhaochewei_time"];
    }
    return cell;
}
#pragma mark - tableView代理协议
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchTextField resignFirstResponder];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.searchView.hidden = YES;
    [self.searchTextField resignFirstResponder];
//    NSValue* value = _dataArray[indexPath.row][@"pt"];
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){[_dataArray[indexPath.row][@"lat"] floatValue], [_dataArray[indexPath.row][@"lng"] floatValue]};
    [self.delegate destinationClickWithPt:pt City:_dataArray[indexPath.row][@"city"]];
    
//    [_historyArray addObject:_dataArray[indexPath.row]];
    [_historyArray insertObject:_dataArray[indexPath.row] atIndex:0];
    NSUserDefaults*user=[[NSUserDefaults alloc]init];
    [user setObject:_historyArray forKey:@"history"];
    [NSUserDefaults resetStandardUserDefaults];
}
#pragma mark - 地图搜索代理协议
- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        [_dataArray removeAllObjects];
        for (int i = 0; i < result.keyList.count; i++) {
            NSValue* value = result.ptList[i];
            NSDictionary* dataDic = @{@"key":result.keyList[i],
                                      @"city":result.cityList[i],
                                      @"district":result.districtList[i],
                                      @"lat":[NSString stringWithFormat:@"%f",value.CGPointValue.x],
                                      @"lng":[NSString stringWithFormat:@"%f",value.CGPointValue.y]};
            [_dataArray addObject:dataDic];
        }
    }else {
        NSLog(@"抱歉，未找到结果");
        [WCAlertView showAlertWithTitle:@"提示" message:@"抱歉，未找到结果" customizationBlock:nil completionBlock:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    }
    [_tableView reloadData];
}
#pragma mark - textField代理协议
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    _tableView.tableHeaderView = nil;
    _tableView.tableFooterView = nil;
    if (_option == nil) {
        _option = [[BMKSuggestionSearchOption alloc] init];
    }
    _option.cityname = KManager.currentCity;
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
            if (self.normalSearchView.hidden) {
                self.normalSearchView.hidden = NO;
                self.headLeftLabel.hidden = YES;
                self.headImageView.image = [UIImage imageNamed:@"zhaochewei_wo"];
                self.headLabel.text = @"我身边";
            }else{
                self.normalSearchView.hidden = YES;
                self.headLeftLabel.hidden = NO;
                self.headImageView.image = [UIImage imageNamed:@"zhaochewei_mudidi"];
                self.headLabel.text = @"目的地";
            }
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
#pragma mark - 删除历史记录
-(void)delegateHistory{
    [_historyArray removeAllObjects];
    [_dataArray removeAllObjects];
    NSUserDefaults*user=[[NSUserDefaults alloc]init];
    [user setObject:_historyArray forKey:@"history"];
    [NSUserDefaults resetStandardUserDefaults];
    [_tableView reloadData];
}
@end
