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
#import "SFActivityModel.h"

@interface CWSActivityViewController ()<UITableViewDelegate,UITableViewDataSource,SFActivityCellDelegate>
{
    UITableView *_tableView;
    UIActivityIndicatorView *_activityIndicator;
    NSMutableArray *_dataArray;
     int                 _temp;
    CWSNoDataView*      _noDataView;//没数据视图
    UserInfo *userInfo;
}
@end

@implementation CWSActivityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"优惠劵中心";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = kCOLOR(245, 245, 245);
    [Utils changeBackBarButtonStyle:self];
     userInfo = [UserInfo userDefault];
    [self setupUI];
    [self initData];
}
- (void)setupUI
{
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(kSizeOfScreen.width/2, kSizeOfScreen.height/2, 20, 20)];
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
    
    _noDataView = [[CWSNoDataView alloc] initWithFrame:CGRectMake(8, 0, kSizeOfScreen.width-16, kSizeOfScreen.height)];
    [self.view addSubview:_noDataView];
}
- (void)initData
{
    _temp = 1;
    _dataArray = [[NSMutableArray alloc] init];
    [self getDataWithPage:_temp];
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
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
}
#pragma mark - 上拉获取更多
-(void)footerRefreshing
{
    _temp++;
    [self getDataWithPage:_temp];
    
}
#pragma mark - 下拉刷新
- (void)headerRefreshing
{
    [_dataArray removeAllObjects];
    [self getDataWithPage:1];
}
-(void)getDataWithPage:(NSInteger)page
{
    [HttpHelper couponListWithUserId:userInfo.desc
                               token:userInfo.token
                            pageSize:@"10"
                          pageNumber:[NSString stringWithFormat:@"%d",_temp]
                             success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                 [_activityIndicator stopAnimating];
                                 [_tableView.mj_header endRefreshing];
                                 [_tableView.mj_footer endRefreshing];
                                 NSLog(@"优惠劵列表 :%@",responseObjcet);
                                 NSDictionary *dict = (NSDictionary *)responseObjcet;
                                 NSString *code = dict[@"code"];
                                 userInfo.token = dict[@"token"];
                                 if ([code isEqualToString:SERVICE_SUCCESS]) {
                                     NSArray *coupons = dict[@"msg"];
                                     if (coupons.count == 0) {
                                         if (page > 1) {
                                             _temp = 1;
                                             [MBProgressHUD showError:@"没有更多数据了哦" toView:self.view.window];
                                         }
                                     }
                                     [_dataArray addObjectsFromArray:coupons];
                                     if (_dataArray.count > 0) {
                                         [self initalizeUserInterface];
                                         [_tableView reloadData];
                                     }
                                 } else if ([code isEqualToString:SERVICE_TIME_OUT]) {
                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                 } else {
                                     [MBProgressHUD showError:dict[@"desc"] toView:self.view];
                                 }
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [_activityIndicator stopAnimating];
                                 [MBProgressHUD showError:@"请求失败，请重试" toView:self.view];
                             }];
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
    return 96;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINib *nib = [UINib nibWithNibName:@"SFActivityTableViewCell" bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:@"activityTableViewCell"];
    SFActivityModel *model = [[SFActivityModel alloc] initWithData:_dataArray[indexPath.row]];
    SFActivityTableViewCell *cell = [[SFActivityTableViewCell alloc] init];
    cell  = [tableView dequeueReusableCellWithIdentifier:@"activityTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.activityModel = model;
    cell.tag = indexPath.row;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CWSActivityDetailViewController *vc = [[CWSActivityDetailViewController alloc] init];
    if ([_dataArray[indexPath.row][@"remark"] isKindOfClass:[NSNull class]]) {
        vc.htmlString = @"";
    } else {
        vc.htmlString = _dataArray[indexPath.row][@"remark"];
    }
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark SFActivityCellDelegate
- (void)onDetailInfo:(id)sender {
    SFActivityTableViewCell *cell = (SFActivityTableViewCell *)sender;
    CWSActivityDetailViewController *vc = [[CWSActivityDetailViewController alloc] init];
    if ([_dataArray[cell.tag][@"remark"] isKindOfClass:[NSNull class]]) {
        vc.htmlString = @"";
    } else {
        vc.htmlString = _dataArray[cell.tag][@"remark"];
    }
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)getDiscountCoupon:(id)sender {
    [MBProgressHUD showMessag:@"领取中..." toView:self.view.window];
    SFActivityTableViewCell *cell = (SFActivityTableViewCell *)sender;
    [HttpHelper applyCouponWithUserId:userInfo.desc
                                token:userInfo.token
                             couponId:cell.identify
                              success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                  [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
                                  NSLog(@"申请优惠劵 :%@",responseObjcet);
                                  NSDictionary *dict = (NSDictionary *)responseObjcet;
                                  NSString *code = dict[@"code"];
                                  userInfo.token = dict[@"token"];
                                  if ([code isEqualToString:SERVICE_SUCCESS]) {
                                      [MBProgressHUD showSuccess:@"领取成功" toView:self.view.window];
                                      cell.couponSelectedImageView.hidden = NO;
                                      [cell.discountCouponBtn removeFromSuperview];
                                      [cell.displayLabel removeFromSuperview];
                                      [cell.displayLabel2 removeFromSuperview];
                                      [cell.discountCouponCounter removeFromSuperview];
                                  } else if ([code isEqualToString:SERVICE_TIME_OUT]) {
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                  } else {
                                      [MBProgressHUD showError:dict[@"desc"] toView:self.view];
                                  }
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [_activityIndicator stopAnimating];
                                  [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
                                  [MBProgressHUD showError:@"请求失败，请重试" toView:self.view.window];
                              }];
}
@end
