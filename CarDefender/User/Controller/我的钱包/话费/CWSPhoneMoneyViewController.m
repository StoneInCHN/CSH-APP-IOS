//
//  CWSPhoneMoneyViewController.m
//  CarDefender
//
//  Created by 万茜 on 15/12/3.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSPhoneMoneyViewController.h"
#import "MJRefresh.h"
#import "IntegralCell.h"
#import "RemainMoneyTableViewCell.h"

@interface CWSPhoneMoneyViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    int                 _temp;
    NSMutableArray*     _dataArray;//数据源
    CWSNoDataView*      _noDataView;//没数据视图
}
@end

@implementation CWSPhoneMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"话费余额";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    _temp = 1;
    _dataArray = [NSMutableArray array];
    [self getDataWithPage:_temp];
    [self initalizeUserInterface];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_dataArray removeAllObjects];
}

#pragma mark - 界面
- (void)initalizeUserInterface
{
    _monLabel = (UILabel *)[self.view viewWithTag:1];
    _monLabel.text = KUserManager.account.cash;
    
    _tableView = (UITableView *)[self.view viewWithTag:2];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc] init];
//    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
}

#pragma mark - 数据
-(void)getDataWithPage:(int)page
{
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
//                    [self creatTableView];
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
                           @"account":KUserManager.account.aid,
                           @"page":[NSString stringWithFormat:@"%i",_temp],
                           @"type":@"call"};
    
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
#endif
    
    
}

#pragma mark - 上拉加载
-(void)footerRefreshing{
//    NSDictionary* lDic = @{@"uid":KUserManager.uid,
//                           @"key":KUserManager.key,
//                           @"account":KUserManager.account.aid,
//                           @"page":[NSString stringWithFormat:@"%i",_temp],
//                           @"type":@"call"};
//    [ModelTool httpGetFeeWithParameter:lDic success:^(id object) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            MyLog(@"%@",object);
//            [self hideHud];
//            NSDictionary* dic = object[@"data"];
//            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
//                [_dataArray addObjectsFromArray:dic[@"list"]];
//                [_tableView reloadData];
//                [self loadShareDataInPage];
//                _temp ++;
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
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UINib *nib = [UINib nibWithNibName:@"RemainMoneyTableViewCell" bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:@"remainMoneyTableViewCell"];
    RemainMoneyTableViewCell *cell = [[RemainMoneyTableViewCell alloc] init];
    cell = [tableView dequeueReusableCellWithIdentifier:@"remainMoneyTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary* dic = _dataArray[indexPath.row];
    cell.titleLabel.text = dic[@"type"];
    if ([dic[@"rule"] isEqualToString:@"0"]) {
        cell.moneyLabel.text = [NSString stringWithFormat:@"+%@",dic[@"total"]];
        cell.moneyLabel.textColor = kCOLOR(254, 98, 112);
    }else{
        cell.moneyLabel.text = [NSString stringWithFormat:@"-%@",dic[@"total"]];
        cell.moneyLabel.textColor = kCOLOR(57, 197, 30);
    }
    cell.dateLabel.text = dic[@"time"];
    return cell;
    
    return cell;
}
#pragma mark - tableView代理协议
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
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
