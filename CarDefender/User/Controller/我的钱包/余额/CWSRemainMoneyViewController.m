//
//  CWSRemainMoneyViewController.m
//  CarDefender
//
//  Created by 万茜 on 15/12/3.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSRemainMoneyViewController.h"
#import "RemainMoneyTableViewCell.h"
#import "CWSPurchaseViewController.h"
#import "MJRefresh.h"
#import "Helper.h"
#import "CWSQRScanViewController.h"//扫一扫

@interface CWSRemainMoneyViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int                 _temp;
    NSMutableArray*     _dataArray;//数据源
    CWSNoDataView*      _noDataView;//没数据视图
    
    BOOL isRefreshing;  //是否正在刷新
    
    UserInfo *userInfo;
    NSDictionary *_dataDic;
}
@end

@implementation CWSRemainMoneyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"余额";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _temp = 1;
    _dataArray = [NSMutableArray array];
    [Utils changeBackBarButtonStyle:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.identifier ==111) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    _temp = 1;
    userInfo = [UserInfo userDefault];
    
    [_dataArray removeAllObjects];
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
//    [self getDataWithPage:_temp];
    [self getData];
}


#pragma mark - 界面
- (void)initalizeUserInterface
{
    self.moneyLabel = (UILabel *)[self.view viewWithTag:1];
//    self.moneyLabel.text = KUserManager.account.cash;
    self.moneyLabel.text = self.moneyString;
    
    self.moneyButton.layer.borderWidth = 1.0;
    self.moneyButton.layer.borderColor = [UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1].CGColor;
    
    self.buyButton.layer.borderWidth = 1.0;
    self.buyButton.layer.borderColor = [UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1].CGColor;

    
    self.tableView = (UITableView *)[self.view viewWithTag:3];
    self.tableView.hidden = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];

    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
}

#pragma mark - 数据

- (void)getData{
    [HttpHelper getMoneyOrRedPacketWithUserId:userInfo.desc
                                        token:userInfo.token
                                   walletType:@"MONEY"
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

//-(void)getDataWithPage:(int)page{
//    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setValue:KUserManager.uid forKey:@"uid"];
//    [dic setValue:KUserManager.mobile forKey:@"mobile"];
//    [dic setValue:@(_temp) forKey:@"pageNumber"];
//    [dic setValue:@20 forKey:@"pageSize"];
//    
//    [ModelTool getWalletDetailListWithParameter:dic andSuccess:^(id object) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            if ([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]) {
//                MyLog(@"-----------我的余额明细----------%@",object);
//                [_dataArray addObjectsFromArray:object[@"data"][@"walletRecordList"]];
//                if ([PublicUtils checkNSNullWithgetString:object[@"data"][@"balance"]] != nil) {
//                    self.moneyLabel = (UILabel *)[self.view viewWithTag:1];
//                    self.moneyLabel.text = [NSString stringWithFormat:@"%.1f",[[PublicUtils checkNSNullWithgetString:object[@"data"][@"balance"]] floatValue]];
//                }
//                if(!isRefreshing){
//                    [self initalizeUserInterface];
//                }
//            }
//            else  {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
//            }
//            
//            [_tableView reloadData];
//            [self loadShareDataInPage];
//        });
//    } andFail:^(NSError *err) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//    }];
//}

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
#pragma mark - 充值和购买按钮
- (IBAction)moneyButtonAndBuyButtonPressed:(id)sender {
    UIButton *button = (UIButton*)sender;
    //购买
    if(button.tag == 101){
        CWSPurchaseViewController* myPurchaseVc = [CWSPurchaseViewController new];
        myPurchaseVc.remainMoneyVc = self;
        [self.navigationController pushViewController:myPurchaseVc animated:YES];
    }else{
    
        CWSQRScanViewController* qrScanVc = [CWSQRScanViewController new];
        qrScanVc.identifier = 158;
        [self.navigationController pushViewController:qrScanVc animated:YES];
        
    }
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
    
    UINib *nib = [UINib nibWithNibName:@"RemainMoneyTableViewCell" bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:@"remainMoneyTableViewCell"];
    RemainMoneyTableViewCell *cell = [[RemainMoneyTableViewCell alloc] init];
    cell = [tableView dequeueReusableCellWithIdentifier:@"remainMoneyTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary* dic = _dataArray[indexPath.row];
//    cell.titleLabel.text = [NSString stringWithFormat:@"%@",dic[@"describe"]];
    NSString *type = dic[@"balanceType"];
    if ([type isEqualToString:@"OUTCOME"]) {
        cell.titleLabel.text = [NSString stringWithFormat:@"消费"];
        cell.moneyLabel.text = [NSString stringWithFormat:@"-%@",dic[@"money"]];
        cell.moneyLabel.textColor = kCOLOR(57, 197, 30);
    }else if ([type isEqualToString:@"INCOME"]){
        cell.titleLabel.text = [NSString stringWithFormat:@"充值"];
        cell.moneyLabel.text = [NSString stringWithFormat:@"+%@",dic[@"money"]];
        cell.moneyLabel.textColor = kCOLOR(254, 98, 112);
    }
    double createTimeStamp = [dic[@"createDate"] doubleValue];
    NSString *dateString = [Helper convertDateViaTimeStamp:createTimeStamp];
    cell.dateLabel.text = dateString;
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

-(void)createNoDataView{
    _noDataView = [[CWSNoDataView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height-kSTATUS_BAR)];
    _noDataView.noDataImageView.frame = CGRectMake((kSizeOfScreen.width-75)/2, 100, 75, 55);
    _noDataView.noDataImageView.image = [UIImage imageNamed:@"mycar_icon"];

    _noDataView.noDataTitleLabel.text = @"暂无明细";
    _noDataView.noDataTitleLabel.frame = CGRectMake((kSizeOfScreen.width-150)/2, CGRectGetMaxY(_noDataView.noDataImageView.frame)+30, 150, 20);
    _noDataView.noDataTitleLabel.textColor = [UIColor colorWithRed:0.733f green:0.733f blue:0.733f alpha:1.00f];
    _noDataView.backgroundColor = [UIColor colorWithRed:0.961f green:0.961f blue:0.961f alpha:1.00f];

    [self.view addSubview:_noDataView];
}

@end
