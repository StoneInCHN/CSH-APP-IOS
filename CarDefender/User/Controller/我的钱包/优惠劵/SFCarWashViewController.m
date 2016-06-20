//
//  SFCarWashViewController.m
//  CarDefender
//
//  Created by sicnu_ifox on 16/6/19.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "SFCarWashViewController.h"
#import "SFActivityTableViewCell.h"
#import "SFWashCarModel.h"
#import "CWSActivityDetailViewController.h"
#import "SFActivityCellDelegate.h"

@interface SFCarWashViewController ()<UITableViewDelegate,UITableViewDataSource,SFActivityCellDelegate> {
    NSMutableArray *_washingCoupons;
    UITableView *_table;
    UserInfo *userInfo;
}

@end

@implementation SFCarWashViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    _washingCoupons = [NSMutableArray array];
    [self setupUI];
    [self loadData];
}
- (void)setupUI
{
    _table = [[UITableView alloc] initWithFrame:CGRectMake(8, 0, kSizeOfScreen.width-16, kSizeOfScreen.height) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_table];
}
#pragma mark -load data
- (void)loadData
{
    userInfo = [UserInfo userDefault];
    [MBProgressHUD showMessag:@"正在加载中..." toView:self.view.window];
    [HttpHelper myWashingCouponWithUserId:userInfo.desc
                                    token:userInfo.token
                                  success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                      [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
                                      NSLog(@"洗车劵列表 :%@",responseObjcet);
                                      NSDictionary *dict = (NSDictionary *)responseObjcet;
                                      NSString *code = dict[@"code"];
                                      userInfo.token = dict[@"token"];
                                      if ([code isEqualToString:SERVICE_SUCCESS]) {
                                         _washingCoupons = dict[@"msg"];
                                          [_table reloadData];
                                      } else if ([code isEqualToString:SERVICE_TIME_OUT]) {
                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                      } else {
                                          [MBProgressHUD showError:dict[@"desc"] toView:self.view.window];
                                      }
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
                                      [MBProgressHUD showError:@"请求失败，请重试" toView:self.view.window];
                                  }];
    
}
#pragma mark -UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _washingCoupons.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINib *nib = [UINib nibWithNibName:@"SFActivityTableViewCell" bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:@"activityTableViewCell"];
    SFWashCarModel *model = [[SFWashCarModel alloc] initWithData:_washingCoupons[indexPath.row]];
    SFActivityTableViewCell *cell = [[SFActivityTableViewCell alloc] init];
    cell  = [tableView dequeueReusableCellWithIdentifier:@"activityTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.washCarModel = model ;
    cell.tag = indexPath.row;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CWSActivityDetailViewController *vc = [[CWSActivityDetailViewController alloc] init];
    if ([_washingCoupons[indexPath.row][@"carWashingCoupon"][@"remark"] isKindOfClass:[NSNull class]]) {
        vc.htmlString = @"";
    } else {
        vc.htmlString = _washingCoupons[indexPath.row][@"remark"];
    }
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark SFActivityCellDelegate
- (void)onDetailInfo:(id)sender {
    SFActivityTableViewCell *cell = (SFActivityTableViewCell *)sender;
    CWSActivityDetailViewController *vc = [[CWSActivityDetailViewController alloc] init];
    if ([_washingCoupons[cell.tag][@"carWashingCoupon"][@"remark"] isKindOfClass:[NSNull class]]) {
        vc.htmlString = @"";
    } else {
        vc.htmlString = _washingCoupons[cell.tag][@"remark"];
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
                                  [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
                                  [MBProgressHUD showError:@"请求失败，请重试" toView:self.view.window];
                              }];
}
@end
