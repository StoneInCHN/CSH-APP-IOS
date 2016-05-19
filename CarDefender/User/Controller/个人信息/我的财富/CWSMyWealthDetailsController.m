//
//  CWSMyWealthDetailsController.m
//  CarDefender
//
//  Created by 周子涵 on 15/6/3.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSMyWealthDetailsController.h"
#import "IntegralCell.h"
#import "MJRefresh.h"
#import "CWSProtectView.h"

#import "CWSAccountSafeController.h"
@interface CWSMyWealthDetailsController ()<UITableViewDataSource,UITableViewDelegate,CWSProtectViewDelegate>
{
    int                 _temp;
    UITableView*        _tableView;
    NSMutableArray*     _dataArray;
    CWSNoDataView*      _noDataView;
    CWSProtectView *    _protextView;
    
    NSDictionary* _insurDic;
}
@end

@implementation CWSMyWealthDetailsController
-(void)buildProtectView
{
    if (_protextView == nil) {
        _protextView = [[CWSProtectView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 70)];
        _protextView.protectType = [KUserManager.account.insurance boolValue];
        _protextView.delegate = self;
    }
    _tableView.tableHeaderView = _protextView;
}
-(void)viewWillAppear:(BOOL)animated
{
//    [self performSelector:@selector(aaaaa) withObject:self afterDelay:10.0f];
    if ([self.buyBack isEqualToString:@"back"]) {
        self.buyBack = @"";
        _temp = 1;
        _protextView.protectType = YES;
        [_dataArray removeAllObjects];
        [self getData];
        [self getDataWithAccountMsg];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [ModelTool stopAllOperation];
}

//- (void)aaaaa
//{
//    _temp = 1;
//    [_dataArray removeAllObjects];
//    [self getData];
//}
//获取参保数据
-(void)getDataWithAccountMsg
{
    [self showHudInView:self.view hint:@"正在加载..."];
    [ModelTool httpAppGainPolicyWithParameter:@{@"uid":KUserManager.uid,@"key":KUserManager.key,@"aid":KUserManager.account.aid,@"type":KUserManager.account.insurance} success:^(id object) {
        MyLog(@"%@",object);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary*dicMsg1 = (NSDictionary*)object[@"data"];
            _insurDic = [NSDictionary dictionaryWithDictionary:dicMsg1];
            if ([KUserManager.account.insurance boolValue]) {
//                _arrayMsg = @[@"保障开始时间",@"保障结束时间",@"保障金额",@"可赔次数",@"支付金额"];
//                _dicMsg = @{@"保障开始时间":dicMsg1[@"start"],@"保障结束时间":dicMsg1[@"end"],@"保障金额":dicMsg1[@"desc"],@"可赔次数":dicMsg1[@"num"],@"支付金额":dicMsg1[@"total"]};
                _protextView.timeString = dicMsg1[@"end"];
            }else{
                NSString*stringMsg = [NSString stringWithFormat:@"保当前金额|%@|%@/年",dicMsg1[@"num"],dicMsg1[@"total"]];
                _protextView.timeString = stringMsg;

//                _arrayMsg = @[@"保障金额",@"赔付次数",@"保障期限",@"支付金额"];
//                _dicMsg = @{@"保障金额":dicMsg1[@"desc"],@"赔付次数":dicMsg1[@"num"],@"保障期限":dicMsg1[@"time"],@"支付金额":dicMsg1[@"total"]};
            }
        });
    } faile:^(NSError *err) {
        [self hideHud];
    }];
}

-(void)getData{
    if ([self.type isEqualToString:@"fee"]) {
        self.title = @"余额详情";
    }
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    NSDictionary* lDic = @{@"uid":KUserManager.uid,
                           @"key":KUserManager.key,
                           @"account":KUserManager.account.aid,
                           @"page":[NSString stringWithFormat:@"%i",_temp],
                           @"type":self.type};
    [ModelTool httpGetFeeWithParameter:lDic success:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MyLog(@"%@",object);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSDictionary* dic = object[@"data"];
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                [_dataArray addObjectsFromArray:dic[@"list"]];
                _temp ++;
                [_tableView reloadData];
                if (_dataArray.count == 0) {
                    if (_noDataView == nil) {
                        _noDataView = [[CWSNoDataView alloc] initWithFrame:CGRectMake(0, 70, kSizeOfScreen.width, kSizeOfScreen.height)];
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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    _temp = 1;
    _dataArray = [NSMutableArray array];

    _insurDic = [NSDictionary dictionary];
    [self getData];
    [self getDataWithAccountMsg];
    [self creatTableView];
    if ([self.type isEqualToString:@"fee"]) {
        [self buildProtectView];
    }
}
-(void)creatTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height - kDockHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view insertSubview:_tableView atIndex:0];
//    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
}
#pragma mark - 上拉加载
-(void)footerRefreshing{
    NSDictionary* lDic = @{@"uid":KUserManager.uid,
                           @"key":KUserManager.key,
                           @"account":KUserManager.account.aid,
                           @"page":[NSString stringWithFormat:@"%i",_temp],
                           @"type":self.type};
    [ModelTool httpGetFeeWithParameter:lDic success:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MyLog(@"%@",object);
            [self hideHud];
            NSDictionary* dic = object[@"data"];
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                [_dataArray addObjectsFromArray:dic[@"list"]];
                [_tableView reloadData];
                [self loadShareDataInPage];
                _temp ++;
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
        [self hideHud];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadShareDataInPage];
        });
    }];
}
#pragma mark - 更新数据源方法
-(void)loadShareDataInPage{
    [_tableView.mj_footer endRefreshing];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"scoreCell";
    IntegralCell* cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"IntegralCell" owner:self options:nil][0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSDictionary* dic = _dataArray[indexPath.row];
    cell.nameLabel.text = dic[@"type"];
    cell.dateLabel.text = dic[@"time"];
    if ([dic[@"rule"] isEqualToString:@"0"]) {
        cell.scoreLabel.text = [NSString stringWithFormat:@"+%@",dic[@"total"]];
        cell.scoreLabel.textColor = kCOLOR(57, 197, 30);
    }else{
        cell.scoreLabel.text = [NSString stringWithFormat:@"-%@",dic[@"total"]];
        cell.scoreLabel.textColor = kCOLOR(254, 98, 112);
    }
    return cell;
}
#pragma mark - tableView代理协议
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

-(void)protectViewWitchClick:(BOOL)proBool
{
    CWSAccountSafeController *accountSafeVC = [[CWSAccountSafeController alloc]init];
    accountSafeVC.protectType = proBool;
    accountSafeVC.insurDicMsg = _insurDic;
    [self.navigationController pushViewController:accountSafeVC animated:YES];
}
@end
