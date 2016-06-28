//
//  SFDetectionDetailViewController.m
//  CarDefender
//
//  Created by sicnu_ifox on 16/6/27.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "SFDetectionDetailViewController.h"
#import "CWSDetectionInfoViewController.h"

@interface SFDetectionDetailViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSArray *_details;
    NSMutableArray *_detailsInfo;
    UITableView *table;
}

@end

@implementation SFDetectionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"检测详情";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [Utils changeBackBarButtonStyle:self];
    _details = @[@"总里程(k)",@"空燃比系数",@"气节门开度",@"发动机负荷",
                 @"发动机运行时间",@"百公里油耗",@"剩余油量",@"转速",
                 @"车速",@"环境温度",@"水温",@"生成odb纪录时间",];
    [self stepUI];
    [self loadData];
    
}
- (void)stepUI {
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    UIButton *infoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [infoBtn setBackgroundImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
    [infoBtn addTapTarget:self action:@selector(detectionDescription)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoBtn];
}
- (void)loadData {
    UserInfo *userInfo = [UserInfo userDefault];
    [HttpHelper scanDetailWithUserId:userInfo.desc
                               token:userInfo.token
                            deviceNo:userInfo.defaultDeviceNo
                             success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                 NSLog(@"扫描车辆－查看详情 :%@",responseObjcet);
                                 NSDictionary *dict = (NSDictionary *)responseObjcet;
                                 NSString *code = dict[@"code"];
                                 userInfo.token = dict[@"token"];
                                 if ([code isEqualToString:SERVICE_SUCCESS]) {
                                    NSDictionary *msg = dict[@"msg"];
                                     _detailsInfo = [NSMutableArray array];
                                     [self parser:msg];
                                 }else if ([code isEqualToString:SERVICE_TIME_OUT]) {
                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                 } else {
                                     [MBProgressHUD showError:dict[@"desc"] toView:self.view];
                                 }
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [MBProgressHUD showError:@"请求失败，请重试" toView:self.view];
                             }];
}
- (void)parser:(NSDictionary *)msg {
    _detailsInfo[0] = [PublicUtils checkNSNullWithgetString:[msg objectForKey:@"totalMileAge"]];
    _detailsInfo[1] = [PublicUtils checkNSNullWithgetString:[msg objectForKey:@"totalMileAge"]];
    _detailsInfo[2] = [PublicUtils checkNSNullWithgetString:[msg objectForKey:@"totalMileAge"]];
    _detailsInfo[3] = [PublicUtils checkNSNullWithgetString:[msg objectForKey:@"totalMileAge"]];
    
    _detailsInfo[4] = [PublicUtils checkNSNullWithgetString:[msg objectForKey:@"obdEngRuntime"]];
    _detailsInfo[5] = [PublicUtils checkNSNullWithgetString:[msg objectForKey:@"totalMileAge"]];
    _detailsInfo[6] = [PublicUtils checkNSNullWithgetString:[msg objectForKey:@"totalMileAge"]];
    _detailsInfo[7] = [PublicUtils checkNSNullWithgetString:[msg objectForKey:@"totalMileAge"]];
    
    _detailsInfo[8] = [PublicUtils checkNSNullWithgetString:[msg objectForKey:@"obdspeed"]];
    _detailsInfo[9] = [PublicUtils checkNSNullWithgetString:[msg objectForKey:@"obdTemp"]];
    _detailsInfo[10] = [PublicUtils checkNSNullWithgetString:[msg objectForKey:@"obdWaterTemp"]];
    _detailsInfo[11] = [Helper convertDateViaTimeStamp:[[msg objectForKey:@"obdDate"] doubleValue]];
    [table reloadData];
}
- (void)detectionDescription {
    CWSDetectionInfoViewController *detectionDesc = [[CWSDetectionInfoViewController alloc] init];
    [self.navigationController pushViewController:detectionDesc animated:YES];
}
#pragma mark table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _details.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentify = @"detectionDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentify];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    cell.textLabel.text = _details[indexPath.row];
    cell.detailTextLabel.text = _detailsInfo[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
