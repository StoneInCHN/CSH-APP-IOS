//
//  CWSRightController.m
//  CarDefender
//
//  Created by 周子涵 on 15/3/24.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSRightController.h"
#import "CWSRightCell.h"
#import "UIImageView+WebCache.h"
#import "CWSAddCarController.h"
@interface CWSRightController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*_tableView;
    NSMutableArray*_dataArray;
    NSMutableDictionary*_dataDic;
}
@end

@implementation CWSRightController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableView];
    _dataDic=[NSMutableDictionary dictionary];
    _dataArray=[NSMutableArray array];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goRightRefreshMsg:) name:@"goRightRefreshMsg" object:nil];
    
    if (KUserManager.uid!=nil) {
        [self getData];
    }else{
        _dataArray=[NSMutableArray arrayWithArray:@[]];
        [_dataDic setObject:@{@"boundJson":@"",@"plate":@"登录"} forKey:@"默认车辆"];
        [_dataDic setObject:_dataArray forKey:@"绑定车辆列表"];
        [_tableView reloadData];
    }
    //mycar界面点击了右上角按钮
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(itemRigthClic:) name:@"itemRigthClic" object:nil];
}
-(void)itemRigthClic:(NSNotification*)sender
{
    if (KUserManager.uid!=nil) {
        [self getData];
    }
}
-(void)goRightRefreshMsg:(NSNotification*)sender
{
    if (KUserManager.uid!=nil) {
        [self getData];
    }else{
        _dataArray=[NSMutableArray arrayWithArray:@[]];
        [_dataDic setObject:@{@"boundJson":@"",@"plate":@"登录"} forKey:@"默认车辆"];
        [_dataDic setObject:_dataArray forKey:@"绑定车辆列表"];
        [_tableView reloadData];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    MyLog(@"显示");
    //    self.navigationController.hideHud
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addCarBack:) name:@"addCarBack" object:nil];
}
-(void)addCarBack:(NSNotification*)sender
{
    [self getData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [ModelTool stopAllOperation];
}
#pragma mark - 创建tableView
-(void)creatTableView{
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"info_bj.png"]];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-200, 100, 200, self.view.frame.size.height-200) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"CWSRightCell" bundle:nil] forCellReuseIdentifier:@"CWSCarManagerCell1"];
    _tableView.tableFooterView=[[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=[UIColor clearColor];
}
#pragma mark - 获取数据
-(void)getData
{
    //新接口
    [self getCarData];
    /*[MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    if (KUserManager.uid!=nil) {//登录
        [ModelTool httpGetAppGainCarsWithParameter:@{@"uid":KUserManager.uid,@"key":KUserManager.key,@"page":@"1"} success:^(id object) {
            MyLog(@"%@",object);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
                if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                    _dataArray = [NSMutableArray arrayWithArray:object[@"data"][@"cars"]];
                    if (_dataArray.count>0) {
                        [_dataDic setObject:_dataArray forKey:@"绑定车辆列表"];
                        for (NSDictionary*dic in _dataArray) {
                            if ([[NSString stringWithFormat:@"%@",dic[@"isDefault"]] isEqualToString:@"1"]) {
                                [_dataDic setObject:dic forKey:@"默认车辆"];
                            }
                        }
                        [_tableView reloadData];
                        //                    [self uploadPoint];
                    }else{
                        _dataArray=[NSMutableArray arrayWithArray:@[]];
                        [_dataDic setObject:@{@"boundJson":@"sdklfjal",@"plate":@"绑定"} forKey:@"默认车辆"];
                        [_dataDic setObject:_dataArray forKey:@"绑定车辆列表"];
                        [_tableView reloadData];
                    }
                }else{
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            });
        } faile:^(NSError *err) {
            [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"获取失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }else{
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"recoverNormal" object:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
//        [self showHint:@"请先登录后再使用本功能"];
    }
    */
}
//新接口
-(void)getCarData{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    [HttpHelper searchVehicleListWithUserID:KUserInfo.desc token:KUserInfo.token success:^(AFHTTPRequestOperation *operation,id object){
        
        MyLog(@"%@",object);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
            if ([object[@"code"] isEqualToString:SERVICE_SUCCESS]) {
                _dataArray = [NSMutableArray arrayWithArray:object[@"msg"]];
                if (_dataArray.count>0) {
                    [_dataDic setObject:_dataArray forKey:@"绑定车辆列表"];
                    for (NSDictionary*dic in _dataArray) {
                        if (dic[@"isDefault"] ) {
                            [_dataDic setObject:dic forKey:@"默认车辆"];
                        }
                    }
                    [_tableView reloadData];
                    //                    [self uploadPoint];
                }else{
                    _dataArray=[NSMutableArray arrayWithArray:@[]];
                    [_dataDic setObject:@{@"boundJson":@"sdklfjal",@"plate":@"绑定"} forKey:@"默认车辆"];
                    [_dataDic setObject:_dataArray forKey:@"绑定车辆列表"];
                    [_tableView reloadData];
                }
            }else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        });

    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"获取失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}
#pragma mark - tableView数据源协议
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *key = [@[@"默认车辆",@"绑定车辆列表"] objectAtIndex:section];
    
    // create the parent view that will hold header Label
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(40.0, 0.0, 200.00, 30.00)];
    
    customView.backgroundColor=[UIColor clearColor];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.highlightedTextColor = [UIColor redColor];
    headerLabel.font = [UIFont italicSystemFontOfSize:14];
    headerLabel.frame = CGRectMake(15, 0, 200.0, 30.00);
    headerLabel.text = key;
    [customView addSubview:headerLabel];
    
    return customView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;//section头部高度
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else
        return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"CWSCarManagerCell1";
    CWSRightCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[CWSRightCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
//    cell.viewDownLine.hidden=YES;
    NSDictionary*dic;
    if (indexPath.section==0) {
        dic=_dataDic[@"默认车辆"];
    }else if(indexPath.section==1){
        dic=_dataDic[@"绑定车辆列表"][indexPath.row];
    }
    cell.carNubLabel.font=kFontOfLetterMedium;
//    cell.noBangLabel.hidden=YES;
    cell.carNubLabel.text=dic[@"plate"];
    if (KUserManager.uid!=nil) {
        NSString*imagName=@"servicezhanwei";
        if ([dic[@"plate"] isEqualToString:@"绑定"]) {
            imagName=@"right_tianjia@2x";
            cell.carImgView.image=[UIImage imageNamed:imagName];
        }else if ([dic[@"plate"] isEqualToString:@"登陆"]){
            imagName=@"";
            cell.carImgView.image=[UIImage imageNamed:nil];
        }else{
            NSString*url=[NSString stringWithFormat:@"%@%@",kBaseUrl, dic[@"brandIcon"]];
            NSURL*logoImgUrl=[NSURL URLWithString:url];
            [cell.carImgView setImageWithURL:logoImgUrl placeholderImage:[UIImage imageNamed:imagName] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
        }
    }
   
     [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:self];
    return cell;
}
#pragma mark - tableView代理协议
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* lDictionary;
    if (indexPath.section==0) {
        lDictionary=_dataDic[@"默认车辆"];
        if (KUserManager.uid==nil) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"recoverNormal" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        }else{
            if ([lDictionary[@"plate"] isEqualToString:@"绑定"]) {
                //在appdelegate 调用的代理
                [[NSNotificationCenter defaultCenter]postNotificationName:@"rightAddCar" object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"recoverNormal" object:nil];
            }
        }
    }else if(indexPath.section==1){
        lDictionary=_dataDic[@"绑定车辆列表"][indexPath.row];
        UserDefaultCarNew* lCar = [[UserDefaultCarNew alloc] initWithDic:lDictionary];
        NSDictionary* dic = @{@"uid":KUserManager.uid,
                              @"key":KUserManager.key,
                              @"cid":lCar.cid,
                              @"re_cid":KUserManager.car.cid};
        
        [MBProgressHUD showMessag:@"切换中..." toView:self.view];
        [ModelTool httpUpDefaultCarWithParameter:dic success:^(id object) {
            NSDictionary* lDic = object;
            MyLog(@"%@",lDic);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([lDic[@"operationState"] isEqualToString:@"SUCCESS"]) {
                [_dataDic setObject:lDictionary forKey:@"默认车辆"];
                KUserManager.car = lCar;
                [_dataArray exchangeObjectAtIndex:0 withObjectAtIndex:indexPath.row];
                [tableView reloadData];
            }else{
                [[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }
        } faile:^(NSError *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark - 试图将要显示
-(void)rightViewWillAppear
{
    NSLog(@"右视图将要显示");
}
#pragma mark - 试图显示完成
-(void)rightViewDidAppear
{
    NSLog(@"右视图显示");
}
#pragma mark - 试图将要消失
-(void)rightViewWillDisappear
{
    NSLog(@"右侧试图将要消失");
}
#pragma mark - 试图消失完成
-(void)rightViewDidDisappear
{
    NSLog(@"右侧试图消失");
}
@end
