//
//  CWSIllegalCheckViewController.m
//  CarDefender
//
//  Created by 万茜 on 15/12/9.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSIllegalCheckViewController.h"
#import "MJRefresh.h"
#import "IllegalCheckTableViewCell.h"
#import "CWSCWSIllegalCheckDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "SFPopMenuViewManager.h"

@interface CWSIllegalCheckViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *_messagelabel;
    NSMutableArray*  _dataArray;
    UserInfo *_userInfo;
    NSMutableArray *_items;
    NSString *_currentCarPlate;
}
@end

@implementation CWSIllegalCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"违章查询";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    _userInfo = [UserInfo userDefault];
    _currentCarPlate = _userInfo.defaultVehiclePlate;
    _items = [NSMutableArray array];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"切换车辆" style:UIBarButtonItemStylePlain target:self action:@selector(changePlate)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blueColor]];
    [self getData];
}
#pragma mark - 数据源
-(void)getData
{
    _dataArray = [NSMutableArray array];
    [self getIllegalRecords];
    [self getMyCarList];
}
- (void)getIllegalRecords {
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    [HttpHelper getIllegalRecordsWithUserId:_userInfo.desc
                                      token:_userInfo.token
                                      plate:_currentCarPlate
                                    success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                        NSLog(@"get illegal records :%@",responseObjcet);
                                        NSDictionary *dict = (NSDictionary *)responseObjcet;
                                        if ([dict[@"code"] isEqualToString:SERVICE_SUCCESS]) {
                                            [self.view removeSubviews];
                                            _dataArray = dict[@"msg"];
                                            if ([_dataArray isKindOfClass:[NSNull class]]) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [self initUIWithoutData];
                                                });
                                            } else {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [self initUIWithData];
                                                });
                                            }
                                        } else if ([dict[@"code"] isEqualToString:SERVICE_TIME_OUT]) {
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                        } else {
                                            [MBProgressHUD showError:dict[@"desc"] toView:self.view];
                                        }
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        MyLog(@"%@",error);
                                        [MBProgressHUD showError:@"请求失败，请重试" toView:self.view];
                                    }];
}
- (void)getMyCarList {
    [HttpHelper myCarListWithUserId:_userInfo.desc
                              token:_userInfo.token
                            success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                NSLog(@"get my car list :%@",responseObjcet);
                                NSDictionary *dict = (NSDictionary *)responseObjcet;
                                NSString *code = dict[@"code"];
                                if ([code isEqualToString:SERVICE_SUCCESS]) {
                                    NSArray *msg = dict[@"msg"];
                                    for (NSDictionary *car in msg) {
                                        [_items addObject:[car objectForKey:@"plate"]];
                                    }
                                } else if ([code isEqualToString:SERVICE_TIME_OUT]) {
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                } else {
                                    [MBProgressHUD showError:dict[@"desc"] toView:self.view];
                                }
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                MyLog(@"%@",error);
                                [MBProgressHUD showError:@"请求失败，请重试" toView:self.view];
                            }];
}
#pragma mark - 界面
- (void)initUIWithData
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 0, [UIScreen mainScreen].bounds.size.width-10, 109*_dataArray.count) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    self.tableView.tableFooterView = view;
    [self.view addSubview:self.tableView];
    
    _messagelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableView.endY+70, [UIScreen mainScreen].bounds.size.width, 15)];
    _messagelabel.text = @"交管数据可能延时，查询结果仅供参考";
    _messagelabel.textColor = KBlackMainColor;
    _messagelabel.font = [UIFont systemFontOfSize:15];
    _messagelabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_messagelabel];
}
- (void)initUIWithoutData {
    _messagelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableView.endY+70, [UIScreen mainScreen].bounds.size.width, 15)];
     _messagelabel.text = @"您还没有违章记录";
    _messagelabel.textColor = KBlackMainColor;
    _messagelabel.font = [UIFont systemFontOfSize:15];
    _messagelabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_messagelabel];
}

- (void)changePlate {
    SFPopMenuViewManager *manager = [SFPopMenuViewManager manager];
    [manager showPopMenuViewWithFrame:CGRectMake(self.view.frame.size.width - 60, 0, 110, 40 * _items.count) item:_items didSelected:^(NSInteger index) {
        NSLog(@"index :%ld",(long)index);
        _currentCarPlate = _items[index];
        [self getIllegalRecords];
    }];
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
    
    return 109;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINib *nib = [UINib nibWithNibName:@"IllegalCheckTableViewCell" bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:@"illegalCheckTableViewCell"];
    IllegalCheckTableViewCell *cell = [[IllegalCheckTableViewCell alloc] init];
    cell = [tableView dequeueReusableCellWithIdentifier:@"illegalCheckTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dicMsg=_dataArray[indexPath.row];
    return cell; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = _dataArray[indexPath.row];
    CWSCWSIllegalCheckDetailViewController *vc = [[CWSCWSIllegalCheckDetailViewController alloc] initWithDic:dic];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
