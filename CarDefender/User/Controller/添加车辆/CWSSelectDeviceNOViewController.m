//
//  CWSSelectDeviceNOViewController.m
//  CarDefender
//
//  Created by DRiPhion on 16/6/28.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "CWSSelectDeviceNOViewController.h"
#import "CWSQRScanViewController.h"//扫一扫
#import "CWSSelectDeviceTableViewCell.h"
@interface CWSSelectDeviceNOViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    UITableView   * _tableView;
    NSMutableArray* _dataArr;
    
}

@end

@implementation CWSSelectDeviceNOViewController

-(void)viewWillAppear:(BOOL)animated{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];//mycar_icon
    // Do any additional setup after loading the view.
    self.title = @"选择设备";
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self getAvailabelDevice];
    _dataArr = [NSMutableArray array];
  
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
}

-(void)creatTabelView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-10)];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 40;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    UIView *headerView = [ [UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 40)];
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(10, headerView.frame.size.height-1, headerView.frame.size.width-20, 1)];
    line.backgroundColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];
    [headerView addSubview:line];
    UILabel *shanghuLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, headerView.frame.size.width/2,headerView.frame.size.height )];
    shanghuLabel.text = @"商业名称";
    shanghuLabel.textAlignment = NSTextAlignmentCenter;
    shanghuLabel.font = [UIFont systemFontOfSize:18];
    [headerView addSubview:shanghuLabel];
    
    UILabel *deviceLabel = [[UILabel alloc]initWithFrame:CGRectMake(headerView.frame.size.width/2, 0, headerView.frame.size.width/2,headerView.frame.size.height )];
    deviceLabel.text = @"设备号";
    deviceLabel.textAlignment = NSTextAlignmentCenter;
    deviceLabel.font = [UIFont systemFontOfSize:18];
    [headerView addSubview:deviceLabel];
    
    _tableView.tableHeaderView = headerView;
  
    
}
-(void)buildButtonView{
    UIButton *myCarBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 61, 61)];
    myCarBtn.center = CGPointMake(self.view.center.x, self.view.center.y-30);
    [myCarBtn setImage:[UIImage imageNamed:@"mycar_icon"] forState:UIControlStateNormal];
    [myCarBtn addTarget:self action:@selector(btnClickErWeiMar:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myCarBtn];
    
    UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, myCarBtn.frame.origin.y+myCarBtn.frame.size.height, self.view.frame.size.width-30, 60)];
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.text = @"您还没有可以绑定的设备，点击图标购买设备";
    alertLabel.textColor = [UIColor colorWithRed:150.0/255 green:150.0/255 blue:150.0/255 alpha:1.0];
    alertLabel.numberOfLines = 3;
    [self.view addSubview:alertLabel];
    
    
}

-(void)btnClickErWeiMar:(UIButton*)sender{
    CWSQRScanViewController* qrScanVc = [CWSQRScanViewController new];
    qrScanVc.identifier = 158;
    [self.navigationController pushViewController:qrScanVc animated:YES];
}

#pragma mark tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    CWSSelectDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell =  [[CWSSelectDeviceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSDictionary *dic = _dataArr[indexPath.row];
    cell.shanghuLabel.text = dic[@"tenantName"];
    cell.deviceLabel.text = dic[@"deviceNo"];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [ [UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 50)];
    UILabel *shanghuLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, headerView.frame.size.width/2,headerView.frame.size.height )];
    shanghuLabel.text = @"商业名称";
    shanghuLabel.textAlignment = NSTextAlignmentCenter;
    shanghuLabel.font = [UIFont systemFontOfSize:18];
    [headerView addSubview:shanghuLabel];
    
    UILabel *deviceLabel = [[UILabel alloc]initWithFrame:CGRectMake(headerView.frame.size.width/2, 0, headerView.frame.size.width/2,headerView.frame.size.height )];
    deviceLabel.text = @"设备号";
    deviceLabel.textAlignment = NSTextAlignmentCenter;
    deviceLabel.font = [UIFont systemFontOfSize:18];
    [headerView addSubview:deviceLabel];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataArr[indexPath.row];
    NSString *deviceNo = dic[@"deviceNo"];
    NSString *defaultVehicleId = [NSString string];
    if ([self.identifier isEqualToString:@"添加或编辑车辆时"]) {
        defaultVehicleId = self.carId;
    }else{
        defaultVehicleId = KUserInfo.defaultVehicleId;
    }
    NSMutableDictionary *bindDeviceDic = [NSMutableDictionary dictionary];
    [bindDeviceDic setObject:KUserInfo.desc forKey:@"userId"];
    [bindDeviceDic setObject:KUserInfo.token forKey:@"token"];
    [bindDeviceDic setObject:defaultVehicleId forKey:@"vehicleId"];
    [bindDeviceDic setObject:deviceNo forKey:@"deviceNo"];
    NSLog(@"datadic%@",bindDeviceDic);
    [MBProgressHUD showMessag:@"正在绑定..." toView:self.view];
    [HttpHelper insertBindDeviceWithUserDic:bindDeviceDic success:^(AFHTTPRequestOperation *operation,id object){
        NSLog(@"decic=%@",object);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *objectDict = (NSDictionary*)object;
        
        if ([objectDict[@"code"] isEqualToString:SERVICE_SUCCESS]) {
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"绑定成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 102;
            [alert show];
        }else{
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:[PublicUtils checkNSNullWithgetString:objectDict[@"desc"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络出错,请重新加载" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];

}


-(void)getAvailabelDevice{
    
    NSDictionary*dic = @{@"userId":KUserInfo.desc,@"token":KUserInfo.token};
    [HttpHelper getAvailableDeviceWithUserDic:dic success:^(AFHTTPRequestOperation*operation, id object){
        
        NSLog(@"可用设备列表＝＝%@",object);
        NSDictionary *dic = (NSDictionary*)object;
        if ([SERVICE_SUCCESS isEqualToString:dic[@"code"]]) {
            _dataArr = dic[@"msg"];
            if (_dataArr.count>0) {
                if (_tableView==nil) {
                    [self creatTabelView];
                    
                }else{
                    [_tableView reloadData];
                }
            }else{
                [self buildButtonView];
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *Operation,NSError *error){
        
    }];
}

#pragma mark alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag==102) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
