//
//  CWSSelectCarViewController.m
//  CarDefender
//
//  Created by DRiPhion on 16/6/6.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "CWSSelectCarViewController.h"
#import "CWSCarManagerCell.h"
#import "CWSNoDataView.h"
#import "CWSCarManageController.h"
@interface CWSSelectCarViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    NSMutableArray*  _dataArray;
    NSMutableArray *cellArray;
    CWSNoDataView* _noCarView;
    UITableView*     _tableView;
    UIBarButtonItem* backItem2;
}

@end

@implementation CWSSelectCarViewController
-(void)viewWillAppear:(BOOL)animated
{
    backItem2.enabled = NO;
    backItem2.title = @"";
    [self getData];
    [_tableView reloadData];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    //移除
    
    [ModelTool stopAllOperation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    backItem2 = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(myCarList)];
    [backItem2 setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.149f green:0.698f blue:0.898f alpha:1.00f],NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    backItem2.enabled = NO;
    self.navigationItem.rightBarButtonItem = backItem2;
    [Utils changeBackBarButtonStyle:self];
   
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    cellArray = [[NSMutableArray alloc] init];
    [self creatTableView];
    //获取数据
    [self initialData];
    
}
#pragma mark - 创建tableView
-(void)creatTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60.0f;
    _tableView.allowsSelectionDuringEditing = YES; //编辑状态下可以选中
    [self.view addSubview:_tableView];
    [self setExtraCellLineHidden:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"CWSCarManagerCell" bundle:nil] forCellReuseIdentifier:@"CWSCarManagerCell"];
    
    _tableView.backgroundColor = [UIColor whiteColor];
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
#pragma mark -车辆管理列表
-(void)myCarList{
    CWSCarManageController *carManager = [[CWSCarManageController alloc]init];
    [self.navigationController pushViewController:carManager animated:YES];
}
#pragma mark - 获取数据

-(void)initialData{
    if(!_dataArray){
        _dataArray = @[].mutableCopy;
    }
    [self getData];
    
}
-(void)getData{

    
    [MBProgressHUD showMessag:@"获取车辆列表..." toView:self.view];
    [HttpHelper searchVehicleListWithUserID:KUserInfo.desc token:KUserInfo.token success:^(AFHTTPRequestOperation *operation,id object){
        
        MyLog(@"--------车辆管理获取信息-------%@",object);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if([object[@"code"] isEqualToString:SERVICE_SUCCESS]){
                _dataArray = object[@"msg"];
                
                if(_dataArray.count > 0){
                    if(_dataArray.count == 3){
                        self.navigationItem.rightBarButtonItem.title = @"";
                        self.navigationItem.rightBarButtonItem.enabled = NO;
                    }else{
                        self.navigationItem.rightBarButtonItem.title = @"添加";
                        self.navigationItem.rightBarButtonItem.enabled = YES;
                    }
                    //获取默认车辆
                    NSString* userCid = [NSString string];
                    NSLog(@"%@",_dataArray);
                    for(NSDictionary *dateDic in _dataArray){
                        if ([dateDic[@"isDefault"]integerValue]==1) {
                            userCid = dateDic[@"id"];
                        }
                    }
                    
                    
                    NSMutableDictionary *userDefaultVehicle = [NSMutableDictionary dictionaryWithDictionary:_dataArray[0]];
                  
                   
                    KUserManager.userCID = userCid;
                    MyLog(@"我的CID：%@",KUserManager.userCID);
                    //创建车辆列表
                    if(_noCarView.subviews.count){
                        [_noCarView removeFromSuperview];
                    }
                   
                    [_tableView reloadData];
                    backItem2.title = @"";
                    backItem2.enabled = NO;
                    //[self uploadPoint];
                }else{
                    
                    
                    _noCarView = [[CWSNoDataView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height-kSTATUS_BAR)];
                    _noCarView.noDataImageView.frame = CGRectMake((kSizeOfScreen.width-75)/2, 100, 75, 55);
                    _noCarView.noDataImageView.image = [UIImage imageNamed:@"mycar_icon"];
                    
                    _noCarView.noDataTitleLabel.text = @"您还没有添加车辆，请点击进入我的车辆进行绑定车辆";
                    _noCarView.noDataTitleLabel.frame = CGRectMake((kSizeOfScreen.width-150)/2, CGRectGetMaxY(_noCarView.noDataImageView.frame)+30, 150, 20);
                    _noCarView.noDataTitleLabel.textColor = [UIColor colorWithRed:0.733f green:0.733f blue:0.733f alpha:1.00f];
                    _noCarView.backgroundColor = [UIColor colorWithRed:0.961f green:0.961f blue:0.961f alpha:1.00f];
                    backItem2.title = @"我的车辆";
                    backItem2.enabled = YES;
                    [self.view addSubview:_noCarView];
                }
            }else {
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"desc"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        });
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络出错,请重新加载" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}
#pragma mark - tableView数据源协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"CWSCarManagerCell";
    CWSCarManagerCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[CWSCarManagerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.dicMsg=_dataArray[indexPath.row];
    cell.defaultLabel.hidden = YES;
    cell.selectButton.hidden = YES;
    [cellArray addObject:cell];
    return cell;
}

#pragma mark - tableView代理协议

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *carDic = _dataArray[indexPath.row];
    NSString *diviceNo = [NSString stringWithFormat:@"%@",carDic[@"deviceNo"]];
    if([self.title isEqualToString:@"绑定设备"]){
        if ([diviceNo isEqualToString:@"<null>"]) {
            [self boundCarDivice:carDic[@"id"]];
        }else{
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:nil message:@"此辆车已经绑定设备" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    if ([self.title isEqualToString:@"绑定租户"]) {
        [self vehicleBindTenant:carDic[@"id"]];
    }
}
#pragma mark - 绑定租户
-(void)vehicleBindTenant:(NSString *)carId{
    [MBProgressHUD showMessag:@"正在绑定..." toView:self.view];
    if(self.dataDic[@"tenantInfo"]){
        NSDictionary * dic = @{@"userId":KUserInfo.desc,@"token":KUserInfo.token,@"vehicleId":carId,@"tenantId":self.dataDic[@"tenantInfo"]};
        [HttpHelper insertVehicleBindTenantWithUserDic:dic success:^(AFHTTPRequestOperation *operation,id object){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            MyLog(@"boject=%@",object);
            NSDictionary * bindDic = (NSDictionary *)object;
            if ([bindDic[@"code"] isEqualToString:SERVICE_SUCCESS]) {
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:nil message:@"绑定成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alertView.tag = 101;
                [alertView show];
            }else{
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:nil message:bindDic[@"desc"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络出错,请重新加载" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }else{
    
    }
   
}
#pragma mark - 绑定设备
-(void)boundCarDivice:(NSString*)carId{
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:KUserInfo.desc forKey:@"userId"];
    [dataDic setObject:KUserInfo.token forKey:@"token"];
    [dataDic setObject:carId forKey:@"vehicleId"];
    [dataDic setObject:self.dataDic[@"flag"] forKey:@"deviceNo"];
    NSLog(@"datadic%@",dataDic);
    [MBProgressHUD showMessag:@"正在绑定..." toView:self.view];
    [HttpHelper insertBindDeviceWithUserDic:dataDic success:^(AFHTTPRequestOperation *operation,id object){
        NSLog(@"decic=%@",object);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *objectDic = (NSDictionary*)object;
        
        if ([objectDic[@"code"] isEqualToString:SERVICE_SUCCESS]) {
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"绑定成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 102;
            [alert show];
        }else{
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"desc"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络出错,请重新加载" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
}
#pragma mark alerView - delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag==101||alertView.tag==102) {
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
