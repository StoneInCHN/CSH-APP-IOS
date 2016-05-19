//
//  CWSRecordViewController.m
//  CarDefender
//
//  Created by 万茜 on 15/12/3.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSRecordViewController.h"
#import "RecordTableViewCell.h"
#import "MJRefresh.h"

#import "CWSChangeRecordViewController.h"
#import "RemainMoneyTableViewCell.h"
#import "CWSShopLuckyDrawViewController.h"

@interface CWSRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int                 _temp;
    NSMutableArray*     _dataArray;
    CWSNoDataView*      _noDataView;
    
    BOOL isRefreshing;  //是否正在刷新
    UserInfo *userInfo;
    NSDictionary *_dataDic;
}
@end

@implementation CWSRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"积分";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    _dataArray = [NSMutableArray array];
    _temp = 1;
    userInfo = [UserInfo userDefault];
//    [self getDataWithPage:_temp];
    [self getData];
    [self initalizeUserInterface];
}

#pragma mark - 界面
- (void)initalizeUserInterface
{
    self.recordLabel = (UILabel *)[self.view viewWithTag:1];
//    self.recordLabel.text = KUserManager.score.now;
    //积分抽奖
    self.recordShopButton = (UIButton *)[self.view viewWithTag:2];
    self.recordShopButton.layer.borderWidth = 1;
    self.recordShopButton.layer.borderColor = [UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1.00f].CGColor;
    [self.recordShopButton addTarget:self action:@selector(recordShopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.changeRecordButton = (UIButton *)[self.view viewWithTag:3];
    self.changeRecordButton.layer.borderWidth = 1;
    self.changeRecordButton.layer.borderColor = [UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1.00f].CGColor;
    [self.changeRecordButton addTarget:self action:@selector(changeRecordButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = (UITableView *)[self.view viewWithTag:4];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
}

#pragma mark -数据源

- (void)getData{
    [HttpHelper getMoneyOrRedPacketWithUserId:userInfo.desc
                                        token:userInfo.token
                                   walletType:@"SCORE"
                                     walletId:self.walletId
                                   pageNumber:[NSString stringWithFormat:@"%d", _temp]
                                     pageSize:@"10"
                                      success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                          NSLog(@"my money response :%@", responseObjcet);
                                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                          NSDictionary *resultDic = (NSDictionary *)responseObjcet;
                                          if ([resultDic[@"code"] isEqualToString:SERVICE_SUCCESS]) {
                                              //                                              _dataDic = (NSDictionary *)resultDic[@"msg"];
                                              [_dataArray addObjectsFromArray:resultDic[@"msg"]];
                                              userInfo.token = resultDic[@"token"];
                                              if(!isRefreshing){
                                                  [self initalizeUserInterface];
                                              }
                                          }else if ([resultDic[@"code"] isEqualToString:SERVICE_TIME_OUT]) {
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                          }else{
                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:resultDic[@"desc"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                              [alert show];
                                          }
                                          [_tableView reloadData];
                                          [self loadShareDataInPage];
                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络请求错误,请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                          [alert show];
                                      }];
    
}

-(void)getDataWithPage:(int)page{
    
#if USENEWVERSION
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setValue:KUserManager.uid forKey:@"uid"];
//    [dic setValue:KUserManager.mobile forKey:@"mobile"];
//    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
//    
//    [ModelTool getMyOrderWithParameter:dic andSuccess:^(id object) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if ([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]) {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                NSLog(@"%@",object);
//                for (NSDictionary* lDic in object[@"data"]) {
//                    CWSHistoryOrder* oredr = [[CWSHistoryOrder alloc] initWithDic:lDic];
//                    [_dataArray addObject:oredr];
//                }
//                
//                if (_dataArray.count == 0) {
//                    if (_noDataView == nil) {
//                        [self creatNoDataView];
//                        self.navigationItem.rightBarButtonItem = nil;
//                    }
//                }
//                else {
//                    //1.创建界面
//                    [self initalizeUserInterface];
//                }
//                
//            }
//            else  {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
//            }
//            
//            [_tableView reloadData];
//            [self loadShareDataInPage];
//        });
//        
//        
//    } andFail:^(NSError *err) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//    }];
#else
    
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    NSDictionary* lDic = @{@"uid":KUserManager.uid,
                           @"key":KUserManager.key,
                           @"score":KUserManager.score.cid,
                           @"page":[NSString stringWithFormat:@"%i",_temp]};
    [ModelTool httpGetScoreWithParameter:lDic success:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MyLog(@"%@",object);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSDictionary* dic = object[@"data"];
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                [_dataArray addObjectsFromArray:dic[@"list"]];
                self.recordLabel.text = KUserManager.score.now;
                
                _temp ++;
                [_tableView reloadData];
                if (_dataArray.count == 0) {
                    if (_noDataView == nil) {
                        _noDataView = [[CWSNoDataView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height)];
                    }
                    [self.view addSubview:_noDataView];
                }else{
                    if (_noDataView != nil) {
                        [_noDataView removeFromSuperview];
                    }
                }
            }
        });
    } faile:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
#endif
    
    
}

#pragma mark - 上拉加载
-(void)footerRefreshing{
    _temp ++;
    isRefreshing = YES;
    //    [self getDataWithPage:_temp];
    [self getData];
}

#pragma mark - 下拉刷新方法
-(void)headerRefreshing
{
    MyLog(@"下拉刷新");
    [_dataArray removeAllObjects];
    _temp = 1;
    isRefreshing = YES;
    //    [self getDataWithPage:_temp];
    [self getData];
}

#pragma mark - 更新数据源方法
-(void)loadShareDataInPage{
    isRefreshing = NO;
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}


#pragma mark - 积分抽奖按钮
- (void)recordShopButtonPressed:(UIButton *)sender
{
//    CWSShopLuckyDrawViewController *vc = [[CWSShopLuckyDrawViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 兑换记录
- (void)changeRecordButtonPressed:(UIButton *)sender
{
//    CWSChangeRecordViewController *vc = [[CWSChangeRecordViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
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
    
    NSDictionary* dic = _dataArray[indexPath.row];
    NSString *type = dic[@"balanceType"];
    if ([type isEqualToString:@"OUTCOME"]) {
        cell.titleLabel.text = [NSString stringWithFormat:@"消费"];
        cell.moneyLabel.text = [NSString stringWithFormat:@"-%@分",dic[@"score"]];
        cell.moneyLabel.textColor = kCOLOR(57, 197, 30);
    }else if ([type isEqualToString:@"INCOME"]){
        cell.titleLabel.text = [NSString stringWithFormat:@"充值"];
        cell.moneyLabel.text = [NSString stringWithFormat:@"+%@分",dic[@"score"]];
        cell.moneyLabel.textColor = kCOLOR(254, 98, 112);
    }
    double createTimeStamp = [dic[@"createDate"] doubleValue];
    NSString *dateString = [Helper convertDateViaTimeStamp:createTimeStamp];
    cell.dateLabel.text = dateString;
    
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
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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
