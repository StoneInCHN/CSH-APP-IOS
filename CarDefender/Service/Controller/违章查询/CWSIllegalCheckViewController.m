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

@interface CWSIllegalCheckViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *_messagelabel;
    NSMutableArray*     _dataArray;
    UserInfo *_userInfo;
}
@end

@implementation CWSIllegalCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"违章查询";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    _dataArray = [NSMutableArray array];
    _userInfo = [UserInfo userDefault];
    [self initalizeUserInterface];
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
                                            _dataArr = dict[@"msg"];
                                            if ([_dataArr isKindOfClass:[NSNull class]]) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    _messagelabel.text = @"您还没有违章记录";
                                                });
                                            }
                                            [self.tableView reloadData];
                                        } else if ([dict[@"code"] isEqualToString:SERVICE_TIME_OUT]) {
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                        } else {
                                            [MBProgressHUD showError:dict[@"desc"] toView:self.view];
                                        }
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        MyLog(@"%@",error);
                                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络出错,请重新加载" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                        [alert show];
                                    }];

}

#pragma mark - 界面
- (void)initalizeUserInterface
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 90*_dataArray.count) style:UITableViewStylePlain];
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"切换车辆" style:UIBarButtonItemStylePlain target:self action:@selector(changePlate)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blueColor]];
}

- (void)changePlate {
    NSLog(@"change plate");
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
    
    return 90;
    
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
    CWSCWSIllegalCheckDetailViewController *vc = [[CWSCWSIllegalCheckDetailViewController alloc] init];
    NSDictionary *dic = _dataArray[indexPath.row];
//    NSString*url=[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"baseUrl"],dic[@"brand"][@"brandIcon"]];
//    NSURL*logoImgUrl=[NSURL URLWithString:url];
//    [vc.headCarImageView setImageWithURL:logoImgUrl placeholderImage:[UIImage imageNamed:@"servicezhanwei"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
//    
//    vc.headCarBrandLabel.text = dic[@"plate"];
    vc.dic = dic;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
