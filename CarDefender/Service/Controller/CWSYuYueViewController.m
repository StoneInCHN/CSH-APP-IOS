//
//  CWSYuYueViewController.m
//  CarDefender
//
//  Created by DRiPhion on 16/6/16.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "CWSYuYueViewController.h"
#import "UIImageView+WebCache.h"
#import "CWSServiceBYTableViewCell.h"
#import "CWSSlelectBaoYangViewController.h"
#import "CWSCarWashDetileController.h"

@interface CWSYuYueViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSDictionary  *dataDic;
    NSMutableArray*baoyangArray;
    NSArray       *baoyangGoodsArray;
    UITableView   *mytableView;
    CGFloat       price;
    NSDictionary  *mybyOptionDic;
    UILabel       *moneyLabel;
    NSDictionary  *carInfoDic;
}

@end

@implementation CWSYuYueViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [mytableView reloadData];
    NSLog(@"%@",baoyangArray);
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [ModelTool stopAllOperation];
}

-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"viewDidDisappear");

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.title = @"车保养";
    [Utils changeBackBarButtonStyle:self];
    
    //dataDic = @{@"desc":@"2015款   GT 3.6L 双离合 基本型",@"code":@"0000",@"page":@"null",@"msg":@[@{@"itemParts":@[@{@"id":@3,@"isDefault":@"true",@"serviceItemPartName":@"米其林轮胎1",@"price":@200},@{@"id":@3,@"isDefault":@"true",@"serviceItemPartName":@"米其林轮胎2",@"price":@200},@{@"id":@3,@"isDefault":@"true",@"serviceItemPartName":@"米其林轮胎3",@"price":@200},@{@"id":@3,@"isDefault":@"true",@"serviceItemPartName":@"米其林轮胎4",@"price":@200},@{@"id":@3,@"isDefault":@"true",@"serviceItemPartName":@"米其林轮胎5",@"price":@200},@{@"id":@3,@"isDefault":@"true",@"serviceItemPartName":@"米其林轮胎6",@"price":@200}],@"serviceItemName":@"轮胎养护"},@{@"itemParts":@[@{@"id":@1,@"isDefault":@"true",@"serviceItemPartName":@"嘉实多机油1",@"price":@200},@{@"id":@1,@"isDefault":@"true",@"serviceItemPartName":@"嘉实多机油2",@"price":@200},@{@"id":@1,@"isDefault":@"true",@"serviceItemPartName":@"嘉实多机油3",@"price":@200},@{@"id":@1,@"isDefault":@"true",@"serviceItemPartName":@"嘉实多机油4",@"price":@200},@{@"id":@1,@"isDefault":@"true",@"serviceItemPartName":@"嘉实多机油5",@"price":@200}],@"serviceItemName":@"机油养护"},@{@"itemParts":@[@{@"id":@1,@"isDefault":@"true",@"serviceItemPartName":@"嘉实多机油1",@"price":@200},@{@"id":@1,@"isDefault":@"true",@"serviceItemPartName":@"嘉实多机油2",@"price":@200},@{@"id":@1,@"isDefault":@"true",@"serviceItemPartName":@"嘉实多机油3",@"price":@200},@{@"id":@1,@"isDefault":@"true",@"serviceItemPartName":@"嘉实多机油4",@"price":@200},@{@"id":@1,@"isDefault":@"true",@"serviceItemPartName":@"嘉实多机油5",@"price":@200}],@"serviceItemName":@"机芯过滤"}],@"token":@"5226f560-2de2-417f-b697-8b513297088b__1466139849536"};
    baoyangArray = [NSMutableArray array];
    NSLog(@"%@",dataDic);
    [self getMyDefautCarInfo];
    [self getTenantInfo];
    [self buildUI];
    [self createTableView];
    
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTabelView:) name:@"refreshTabelView" object:nil];
    
  
}
-(void)buildUI{
    self.view.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1];
    UIView *carView =[[UIView alloc]initWithFrame:CGRectMake(0, 3, kSizeOfScreen.width ,100 )];
    carView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:carView];
    carView.tag = 100;
    //
    UIImageView * carImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 80)];
    carImageView.contentMode =UIViewContentModeScaleAspectFit;
    
    carImageView.tag = 1001;
    [carImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/csh-interface%@",SERVERADDRESS,KUserInfo.defaultVehicleIcon]] placeholderImage:[UIImage imageNamed:@"logo"] options:SDWebImageLowPriority | SDWebImageRetryFailed | SDWebImageProgressiveDownload];
    
    [carView addSubview:carImageView];
    //
    UILabel *carNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(carImageView.frame.origin.x+carImageView.frame.size.width+20, 20, kSizeOfScreen.width-carImageView.frame.origin.x-carImageView.frame.size.width-40, 20)];
    carNameLabel.tag = 1002;
    carNameLabel.text = KUserInfo.defaultVehicle;
    carNameLabel.textAlignment = NSTextAlignmentLeft;
    carNameLabel.font = [UIFont boldSystemFontOfSize:18];
    [carView addSubview:carNameLabel];
    
    UILabel *carDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(carImageView.frame.origin.x+carImageView.frame.size.width+20, carNameLabel.frame.origin.y+carNameLabel.frame.size.height, kSizeOfScreen.width-carImageView.frame.origin.x-carImageView.frame.size.width-40, 45)];
    carDetailLabel.numberOfLines = 3;
    carDetailLabel.tag = 1003;
    carDetailLabel.textColor = kTextlightGrayColor;
    
    carDetailLabel.font = [UIFont systemFontOfSize:15];
    carDetailLabel.text = dataDic[@"desc"];
    [carView addSubview:carDetailLabel];
    
    //穿件button
    
    UIView *moneyAndSureView = [[UIView alloc]initWithFrame:CGRectMake(0, kSizeOfScreen.height-64-60*kSizeOfScreen.height/667+20, kSizeOfScreen.width, 60*kSizeOfScreen.height/667)];
    moneyAndSureView.backgroundColor = [UIColor whiteColor];
    moneyAndSureView.tag = 101;
    [self.view addSubview:moneyAndSureView];
    //￥
    moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, (moneyAndSureView.frame.size.height-20)/2, 200, 20)];
    
    NSString *money = [NSString stringWithFormat:@"合计:￥%.2f元",price];
    moneyLabel.text = money;
    moneyLabel.textAlignment = NSTextAlignmentLeft;
    [moneyAndSureView addSubview:moneyLabel];
    
    UIButton * yuyueBtn = [[UIButton alloc]initWithFrame:CGRectMake(kSizeOfScreen.width-90, 0, 90, moneyAndSureView.frame.size.height)];
    [yuyueBtn setTitle:@"预约" forState:UIControlStateNormal];
    [yuyueBtn addTarget:self action:@selector(makeAppointmentService:) forControlEvents:UIControlEventTouchUpInside];
    yuyueBtn.backgroundColor = kMainColor;
    
    
    [moneyAndSureView addSubview:yuyueBtn];
    
}
//预约事件
-(void)makeAppointmentService:(UIButton*)sender{
    
    price = [self calculationPrice:baoyangArray];
    NSString *priceStr = [NSString stringWithFormat:@"%.2f",price];
    NSArray *idArray = [self saveBYId];
    NSDictionary *dic = @{@"userId":KUserInfo.desc,@"token":KUserInfo.token,@"serviceId":self.goodDic[@"service_id"],@"price":priceStr,@"itemIds":idArray};
    NSLog(@"idc ====%@",dic);
    [MBProgressHUD showMessag:@"正在预约" toView:self.view];
    
    [HttpHelper insertVehicleSubscribeServiceWithUserDic:dic success:^(AFHTTPRequestOperation *operation,id object){
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dataDictionary = (NSDictionary *)object;
        NSLog(@"dataDictionary=%@",dataDictionary);
        
        if ([dataDictionary[@"code"] isEqualToString:SERVICE_SUCCESS]) {
            CWSCarWashDetileController* carWashDetailVc = [CWSCarWashDetileController new];
           
            carWashDetailVc.orderID = dataDictionary[@"desc"];
            //订单详情
            
            
            [self.navigationController pushViewController:carWashDetailVc animated:YES];
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"desc"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];





}
//创建图标

-(void)createTableView{
    UIView *carView = [self.view viewWithTag:100];
    UIView *moneyAndSureView = [self.view viewWithTag:101];
    mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, carView.frame.origin.y+carView.frame.size.height+3, kSizeOfScreen.width,moneyAndSureView.frame.origin.y-( carView.frame.origin.y+carView.frame.size.height+6))];
    mytableView.backgroundColor = [UIColor whiteColor];
    mytableView.delegate =self;
    mytableView.dataSource =self;
    mytableView.separatorStyle=UITableViewCellAccessoryNone;
    mytableView.rowHeight = 45;
    [self.view addSubview:mytableView];
    //创建headerView
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 50)];
    UILabel *baoyangLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 80, 30)];
    baoyangLabel.text= @"常规保养";
    baoyangLabel.font = [UIFont boldSystemFontOfSize:17];
    baoyangLabel.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:baoyangLabel];
    
    UIButton *selectParts = [[UIButton alloc]initWithFrame:CGRectMake(kSizeOfScreen.width-75, 10, 60, 30)];
    
    [selectParts setTitle:@"选配件" forState:UIControlStateNormal];
    [selectParts setTitleColor:kMainColor forState:UIControlStateNormal];
    [selectParts addTarget:self action:@selector(selectParts:) forControlEvents:UIControlEventTouchUpInside];
    selectParts.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [headerView addSubview:selectParts];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(13, headerView.frame.size.height-1, kSizeOfScreen.width-26, 1)];
    
    line.backgroundColor =[UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];
    [headerView addSubview:line];
    
    mytableView.tableHeaderView = headerView;

}

#pragma mark 计算价格
-(CGFloat)calculationPrice:(NSArray *)optionArray{
    
    CGFloat total;
    
    for(NSDictionary *dic in optionArray){
        NSString *priceStr = dic[@"price"];
        CGFloat i = [priceStr floatValue];
        total+=i;
    }
    
    return total;
}
#pragma mark存储id 
-(NSArray*)saveBYId{
    NSMutableArray *idArr = [NSMutableArray array];
    for(NSDictionary *dic in baoyangArray){
        [idArr addObject:dic[@"id"]];
    }
    
    
    return idArr.copy;
}
#pragma mark 通知事件刷新选择的配件
-(void)refreshTabelView:(NSNotification*)sender{
    NSDictionary * baoyangOption = sender.userInfo;
    
    NSArray *arr1 = baoyangOption[@"saveDataArr1"];
    baoyangArray = arr1.mutableCopy;
    NSArray *arr2 = baoyangOption[@"saveCellArr1"];
    NSMutableArray *saveCellArr = arr2.mutableCopy;
    NSLog(@"%@",baoyangArray);
    CGFloat  iii = [self calculationPrice:baoyangArray];
    NSString *money = [NSString stringWithFormat:@"合计:%.2f元",iii];
    moneyLabel.text = money;
    mybyOptionDic = @{@"saveDataArr1":baoyangArray,@"saveCellArr1":saveCellArr};
    [mytableView reloadData];
    
}
#pragma mark 选择配件
-(void)selectParts:(UIButton*)sender{
    
    CWSSlelectBaoYangViewController *selectBaoYang = [[CWSSlelectBaoYangViewController alloc]init];
    selectBaoYang.byDataArr = dataDic[@"msg"];
    selectBaoYang.byOptionDic = mybyOptionDic;
    NSLog(@"dic===%@",mybyOptionDic);
    [self.navigationController pushViewController:selectBaoYang animated:YES];

}
#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return baoyangArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    CWSServiceBYTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[CWSServiceBYTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *byDic = baoyangArray[indexPath.row];
    
    NSString *priceStr = [NSString stringWithFormat:@"%@",byDic[@"price"]];
    
    cell.byPrice.text = [NSString stringWithFormat:@"￥%.2f元",[priceStr doubleValue]];
    cell.byName.text = [NSString stringWithFormat:@"%@",byDic[@"serviceItemPartName"]];
    return cell;
}
#pragma mark 获取产品列表
-(void)getTenantInfo{
    NSDictionary *dic = @{@"userId":KUserInfo.desc,@"token":KUserInfo.token,@"serviceId":self.goodDic[@"service_id"]};
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    [HttpHelper getTenantInfiServiceByldWithUserDic:dic success:^(AFHTTPRequestOperation*operation,id object){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *objectDic = (NSDictionary*)object;
        NSLog(@"--------获取产品列表-------%@",objectDic);
        if ([objectDic[@"code"] isEqualToString:SERVICE_SUCCESS]) {
            dataDic = objectDic;
            
            [self updateCarDetailLbabel:[NSString stringWithFormat:@"%@",objectDic[@"desc"]]];
        }else{
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",objectDic[@"desc"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}
#pragma mark 获取车辆信息
-(void)getMyDefautCarInfo{
    [HttpHelper searchVehicleListWithUserID:KUserInfo.desc token:KUserInfo.token success:^(AFHTTPRequestOperation *operation,id object){
        
        MyLog(@"--------车辆管理获取信息-------%@",object);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if([object[@"code"] isEqualToString:SERVICE_SUCCESS]){
                NSArray *_dataArray = object[@"msg"];
                
                if(_dataArray.count > 0){
                    
                    //获取默认车辆
                  
                    for(NSDictionary *carDateDic in _dataArray){
                        if ([carDateDic[@"isDefault"]integerValue]==1) {
                            carInfoDic = carDateDic;
                            NSLog(@"%@",carInfoDic);
                            [self updateUI];
                        }
                    }
            
                }
            }else {
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",object[@"desc"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        });
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];

}
-(void)updateUI{
    UIImageView *carIcon = [self.view viewWithTag:1001];
    UILabel     *carNameLabel = [self.view viewWithTag:1002];
    
    
    [carIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/csh-interface%@",SERVERADDRESS,carInfoDic[@"brandIcon"]]] placeholderImage:[UIImage imageNamed:@"logo"] options:SDWebImageLowPriority | SDWebImageRetryFailed | SDWebImageProgressiveDownload ];
    carNameLabel.text = carInfoDic[@"vehicleFullBrand"];
    
}
-(void)updateCarDetailLbabel:(NSString *)text{
    UILabel     *carDetailLbabel = [self.view viewWithTag:1003];
    carDetailLbabel.text = text;
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
