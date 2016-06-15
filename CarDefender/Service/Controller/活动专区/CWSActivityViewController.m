//
//  CWSActivityViewController.m
//  CarDefender
//
//  Created by 万茜 on 15/12/17.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSActivityViewController.h"
#import "CWSNoDataView.h"
#import "CWSActivityTableViewCell.h"
#import "CWSActivityDetailViewController.h"
#import "SFActivityTableViewCell.h"
#import "SFActivityCellDelegate.h"

@interface CWSActivityViewController ()<UITableViewDelegate,UITableViewDataSource,SFActivityCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
     int                 _temp;
    CWSNoDataView*      _noDataView;//没数据视图
}
@end

@implementation CWSActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠劵中心";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = kCOLOR(245, 245, 245);
    [Utils changeBackBarButtonStyle:self];
    [self initalizeUserInterface];
    [self initData];
//    [self getDataWithPage:_temp];
}
- (void)initData {
    _temp = 1;
    _dataArray = [[NSMutableArray alloc] init];
    UserInfo *userInfo = [UserInfo userDefault];
    [HttpHelper couponListWithUserId:userInfo.desc
                               token:userInfo.token
                            pageSize:@"10"
                          pageNumber:@"1"
                             success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                 NSLog(@"优惠劵列表 :%@",responseObjcet);
                                 NSDictionary *dict = (NSDictionary *)responseObjcet;
                                 NSString *code = dict[@"code"];
                                 userInfo.token = dict[@"token"];
                                 if ([code isEqualToString:SERVICE_SUCCESS]) {
                                     _dataArray = dict[@"msg"];
                                     [_tableView reloadData];
                                 } else if ([code isEqualToString:SERVICE_TIME_OUT]) {
                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                 } else {
                                     [MBProgressHUD showError:dict[@"desc"] toView:self.view];
                                 }
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [MBProgressHUD showError:@"请求失败，请重试" toView:self.view];
                             }];
}
#pragma mark - 数据源
- (void)initDataSource
{
    _temp = 1;
    _dataArray = [[NSMutableArray alloc] init];
}

#pragma mark - 界面
- (void)initalizeUserInterface
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.height-5) style:UITableViewStylePlain];
    _tableView.backgroundColor = kCOLOR(245, 245, 245);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
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
//                           @"account":KUserManager.account.aid,
//                           @"page":[NSString stringWithFormat:@"%i",_temp],
//                           @"type":@"fee"};
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

-(void)getDataWithPage:(NSInteger)page{

//    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
//    NSDictionary* lDic = @{@"uid":KUserManager.uid,
//                           @"mobile":KUserManager.mobile,
//                           @"pageNumber":@(_temp),
//                           @"pageSize":@20,
//                           };
//    [ModelTool getRedDetaikWithParameter:lDic andSuccess:^(id object) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if ([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]) {
//                NSLog(@"%@",object);
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                _dataArray = object[@"data"][@"list"];;
//                [self initalizeUserInterface];
//                
//            }else {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
//            }
//            [_tableView reloadData];
//            [self loadShareDataInPage];
//        });
//    } andFail:^(NSError *err) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//    }];
}

#pragma mark - 更新数据源方法
-(void)loadShareDataInPage{
    [_tableView.mj_footer endRefreshing];
    [_tableView.mj_header endRefreshing];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
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
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINib *nib = [UINib nibWithNibName:@"SFActivityTableViewCell" bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:@"activityTableViewCell"];
    SFActivityTableViewCell *cell = [[SFActivityTableViewCell alloc] init];
    cell  = [tableView dequeueReusableCellWithIdentifier:@"activityTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.tag = indexPath.row;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CWSActivityDetailViewController *vc = [[CWSActivityDetailViewController alloc] init];
    vc.htmlString = _dataArray[indexPath.row][@"remark"];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark SFActivityCellDelegate
- (void)onDetailInfo:(id)sender {
    SFActivityTableViewCell *cell = (SFActivityTableViewCell *)sender;
    CWSActivityDetailViewController *vc = [[CWSActivityDetailViewController alloc] init];
    vc.htmlString = _dataArray[cell.tag][@"remark"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)getDiscountCoupon:(id)sender {
    SFActivityTableViewCell *cell = (SFActivityTableViewCell *)sender;
    cell.couponSelectedImageView.hidden = NO;
    [cell.discountCouponBtn removeFromSuperview];
    [cell.displayLabel removeFromSuperview];
    [cell.discountCouponCounter removeFromSuperview];
}
@end
