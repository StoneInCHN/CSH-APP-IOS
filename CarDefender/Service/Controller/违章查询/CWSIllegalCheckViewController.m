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
#import "ChangeCarView.h"

@interface CWSIllegalCheckViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *_messagelabel;
    NSMutableArray*  _dataArray;
    UserInfo *_userInfo;
}
@end

@implementation CWSIllegalCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"违章查询";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    _userInfo = [UserInfo userDefault];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"切换车辆" style:UIBarButtonItemStylePlain target:self action:@selector(changePlate)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blueColor]];
    [self getData];
}
#pragma mark - 数据源
-(void)getData
{
    _dataArray = [NSMutableArray array];
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    [HttpHelper getIllegalRecordsWithUserId:_userInfo.desc
                                      token:_userInfo.token
                                      plate:_userInfo.defaultVehiclePlate
                                    success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                        NSLog(@"get illegal records :%@",responseObjcet);
                                        NSDictionary *dict = (NSDictionary *)responseObjcet;
                                        if ([dict[@"code"] isEqualToString:SERVICE_SUCCESS]) {
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
    NSLog(@"change plate");
    CGSize size  = [UIScreen mainScreen].bounds.size;
    ChangeCarView *view = [[ChangeCarView alloc] initWithFrame:CGRectMake(size.width - 70,64 , 60, 100)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderWidth = 1.0;
    [UIView animateWithDuration:5.0 animations:^{
        [self.view addSubview:view];
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
