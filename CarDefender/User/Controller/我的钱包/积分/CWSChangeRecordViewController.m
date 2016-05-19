//
//  CWSChangeRecordViewController.m
//  CarDefender
//
//  Created by 万茜 on 15/12/7.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSChangeRecordViewController.h"
#import "MJRefresh.h"
#import "RecordTableViewCell.h"
#import "CWSNoDataView.h"
#import "MBProgressHUD.h"
#import "RemainMoneyTableViewCell.h"
#import "CWSNoDataView.h"

@interface CWSChangeRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    CWSNoDataView *_noDataView;
    NSMutableArray *_dataArray;
    int                 _temp;
}
@end

@implementation CWSChangeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"兑换记录";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _dataArray = [NSMutableArray array];
    _temp = 1;
    [self getDataWithPage:_temp];
    
    [self creatNoDataView];
    
}

- (void)creatNoDataView
{
    _noDataView = [[CWSNoDataView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height-kSTATUS_BAR)];
    _noDataView.noDataImageView.frame = CGRectMake((kSizeOfScreen.width-75)/2, 100, 75, 105);
    _noDataView.noDataImageView.image = [UIImage imageNamed:@"duihuan_icon"];
    
    _noDataView.noDataTitleLabel.text = @"您还没有兑换记录";
    _noDataView.noDataTitleLabel.frame = CGRectMake((kSizeOfScreen.width-150)/2, CGRectGetMaxY(_noDataView.noDataImageView.frame)+30, 150, 20);
    _noDataView.noDataTitleLabel.textColor = [UIColor colorWithRed:0.733f green:0.733f blue:0.733f alpha:1.00f];
    _noDataView.backgroundColor = [UIColor colorWithRed:0.961f green:0.961f blue:0.961f alpha:1.00f];
    [self.view addSubview:_noDataView];
}



#pragma mark - 数据源
-(void)getDataWithPage:(int)page
{
//    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
//    NSDictionary* lDic = @{@"uid":KUserManager.uid,
//                           @"key":KUserManager.key,
//                           @"score":KUserManager.score.cid,
//                           @"page":[NSString stringWithFormat:@"%i",_temp]};
//    [ModelTool httpGetScoreWithParameter:lDic success:^(id object) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            MyLog(@"%@",object);
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            NSDictionary* dic = object[@"data"];
//            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
//                [_dataArray addObjectsFromArray:dic[@"list"]];
//                
//                
//                if (_dataArray.count == 0) {
//                    if (_noDataView == nil) {
//                        _noDataView = [[CWSNoDataView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height)];
//                    }
//                    [self.view addSubview:_noDataView];
//                }else{
//                    if (_noDataView != nil) {
//                        [_noDataView removeFromSuperview];
//                    }
//                }
//    [self creatTableView];
//            }
//            [_tableView reloadData];
//            [self loadShareDataInPage];
//        });
//    } faile:^(NSError *err) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    }];
}

- (void)creatTableView
{
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_tableView];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
}

#pragma mark - 下拉刷新方法
-(void)headerRefreshing
{
    MyLog(@"下拉刷新");
    [_dataArray removeAllObjects];
    _temp = 1;
    [self getDataWithPage:_temp];
    
}

#pragma mark - 上拉加载
-(void)footerRefreshing{
//    NSDictionary* lDic = @{@"uid":KUserManager.uid,
//                           @"key":KUserManager.key,
//                           @"score":KUserManager.score.cid,
//                           @"page":[NSString stringWithFormat:@"%i",_temp]};
//    [ModelTool httpGetScoreWithParameter:lDic success:^(id object) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            MyLog(@"%@",object);
//            [self hideHud];
//            NSDictionary* dic = object[@"data"];
//            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
//                [_dataArray addObjectsFromArray:dic[@"list"]];
//                [_tableView reloadData];
//                [self loadShareDataInPage];
//                _temp ++;
//            }
//        });
//    } faile:^(NSError *err) {
//        [self hideHud];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self loadShareDataInPage];
//        });
//    }];
    _temp ++;
    [self getDataWithPage:_temp];
}

#pragma mark - 更新数据源方法
-(void)loadShareDataInPage{
    [_tableView.mj_footer endRefreshing];
    [_tableView.mj_header endRefreshing];
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 75;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    UINib *nib = [UINib nibWithNibName:@"RecordTableViewCell" bundle:[NSBundle mainBundle]];
//    [tableView registerNib:nib forCellReuseIdentifier:@"recordTableViewCell"];
//    RecordTableViewCell *cell = [[RecordTableViewCell alloc] init];
//    cell = [tableView dequeueReusableCellWithIdentifier:@"recordTableViewCell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor];
    
    UINib *nib = [UINib nibWithNibName:@"RemainMoneyTableViewCell" bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:@"remainMoneyTableViewCell"];
    RemainMoneyTableViewCell *cell = [[RemainMoneyTableViewCell alloc] init];
    cell = [tableView dequeueReusableCellWithIdentifier:@"remainMoneyTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLabel.text = @"兑换商品A17582";
   
    cell.moneyLabel.text = @"-10分";
    cell.moneyLabel.textColor = kCOLOR(57, 197, 30);
    
    cell.dateLabel.text = @"2015-10-10";
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -设置tableView分割线
-(void)viewDidLayoutSubviews
{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
