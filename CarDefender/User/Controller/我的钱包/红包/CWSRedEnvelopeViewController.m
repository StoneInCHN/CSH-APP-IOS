//
//  CWSRedEnvelopeViewController.m
//  CarDefender
//
//  Created by 万茜 on 15/12/3.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSRedEnvelopeViewController.h"
#import "MJRefresh.h"
#import "RedEnvelopeTableViewCell.h"

@interface CWSRedEnvelopeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger                 _temp;
    NSMutableArray*     _dataArray;//数据源
    CWSNoDataView*      _noDataView;//没数据视图
}
@end

@implementation CWSRedEnvelopeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"红包";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    _temp = 1;
    _dataArray = [NSMutableArray array];
    [self getDataWithPage:_temp];
    
}


#pragma mark - 界面
- (void)initalizeUserInterface
{
    self.moneyLabe = (UILabel *)[self.view viewWithTag:1];
    self.moneyLabe.text = [NSString stringWithFormat:@"￥%@",self.moneyString];
    
    self.tableView = (UITableView *)[self.view viewWithTag:2];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
}

#pragma mark - 数据源
-(void)getDataWithPage:(NSInteger)page{
#if USENEWVERSION
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    NSDictionary* lDic = @{@"uid":KUserManager.uid,
                           @"mobile":KUserManager.mobile,
                           @"pageNumber":@(_temp),
                           @"pageSize":@20,
                           };
    [ModelTool getRedDetaikWithParameter:lDic andSuccess:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]) {
                NSLog(@"%@",object);
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [_dataArray addObjectsFromArray:object[@"data"][@"list"]];
                [self initalizeUserInterface];
                
            }else {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
            [_tableView reloadData];
            [self loadShareDataInPage];
        });
    } andFail:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
#else
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    NSDictionary* lDic = @{@"uid":KUserManager.uid,
                           @"key":KUserManager.key,
                           @"account":KUserManager.account.aid,
                           @"page":[NSString stringWithFormat:@"%i",_temp],
                           @"type":@"fee"};
    
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
    
#if USENEWVERSION
    _temp ++;
    [self getDataWithPage:_temp];
    
    
#else
    NSDictionary* lDic = @{@"uid":KUserManager.uid,
                           @"key":KUserManager.key,
                           @"account":KUserManager.account.aid,
                           @"page":[NSString stringWithFormat:@"%i",_temp],
                           @"type":@"fee"};
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
    
#endif
    
    
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
    return _dataArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UINib *nib = [UINib nibWithNibName:@"RedEnvelopeTableViewCell" bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:@"redEnvelopeTableViewCell"];
    RedEnvelopeTableViewCell *cell = [[RedEnvelopeTableViewCell alloc] init];
    cell = [tableView dequeueReusableCellWithIdentifier:@"redEnvelopeTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.moneyLabel.text = [NSString stringWithFormat:@"￥%.1f",[_dataArray[indexPath.row][@"money"] floatValue]];
    //这里解析出来多了“”，强制使用转义字符
    cell.timeLabel.text = [NSString stringWithFormat:@"%@-%@",_dataArray[indexPath.row][@"add_time"],_dataArray[indexPath.row][@"effect"]];
    cell.messageLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"code"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
