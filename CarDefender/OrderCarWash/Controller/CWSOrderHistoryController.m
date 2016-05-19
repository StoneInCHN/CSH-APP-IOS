//
//  CWSOrderHistoryController.m
//  CarDefender
//
//  Created by 周子涵 on 15/10/12.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSOrderHistoryController.h"
#import "CWSHistoryOrderCell.h"
#import "CWSHistoryOrder.h"
#import "OrderWash.h"
#import "MJRefresh.h"
#import "CWSNoDataView.h"
#import "CWSCarWashDetileController.h"
#import "OrderConfirmView.h"
#import "CWSEvaluationViewController.h"
#import "MyOrderDetailModel.h"
#import "CWSPayViewController.h"

@interface CWSOrderHistoryController () <UITableViewDataSource,UITableViewDelegate,OrderConfirmDelegate,UIAlertViewDelegate,CWSTableViewButtonCellDelegate>
{
    NSMutableArray*       _dataArray;
    UITableView*          _tableView;
    int                   _page;
    CWSNoDataView*        _noDataView;
    CWSHistoryOrder*      _order;
    NSIndexPath*          _indexPath;
    UIBarButtonItem       *rightBarItem;
    NSIndexPath           *_currentIndex;
}
@property (nonatomic,strong)OrderConfirmView *orderConfirmView;
@end

@implementation CWSOrderHistoryController

-(void)initData{
    [Utils changeBackBarButtonStyle:self];
    _dataArray = [NSMutableArray array];
    _page = 1;
    _order = [[CWSHistoryOrder alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"我的订单";
    [Utils changeBackBarButtonStyle:self];
    self.view.backgroundColor = kCOLOR(245, 245, 245);
//    rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"message_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick:)];
//    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    //1.初始化数据
    [self initData];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [_dataArray removeAllObjects];
    _page = 1;
    [self getDataWithPage:_page];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.orderConfirmView  removeFromSuperview];
    [ModelTool stopAllOperation];
}

-(void)getDataWithPage:(int)page{
    
#if USENEWVERSION
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:KUserManager.uid forKey:@"uid"];
    [dic setValue:KUserManager.mobile forKey:@"mobile"];
    [dic setObject:@(_page) forKey:@"pageNumber"];
    [dic setObject:@20 forKey:@"pageSize"];
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];

    [ModelTool getMyOrderWithParameter:dic andSuccess:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MyLog(@"----------我的订单信息---------%@",object);
            if ([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSLog(@"%@",object);
                for (NSDictionary* lDic in object[@"data"]) {
                    CWSHistoryOrder* oredr = [[CWSHistoryOrder alloc] initWithDic:lDic];
                    [_dataArray addObject:oredr];
                }
                
                if (_dataArray.count == 0) {
                    
                    [self creatNoDataView];
                    self.navigationItem.rightBarButtonItem = nil;
                    
                }
                else {
                    [_noDataView removeFromSuperview];
                    //1.创建界面
                    [self creatTableView];
                }
                
            }
            else  {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                
            }
            
            [_tableView reloadData];
            [self loadShareDataInPage];
        });
        
        
    } andFail:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
        [WCAlertView showAlertWithTitle:@"提示" message:@"网络出错,请重新加载" customizationBlock:nil completionBlock:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
    }];
    

#else
    NSDictionary* dic = @{@"uid":KUserManager.uid,
                          @"key":KUserManager.key,
                          @"page":[NSString stringWithFormat:@"%i",page],
                          @"size":@"10"};
    MyLog(@"%@",dic);
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    [ModelTool httpAppGainWashListWithParameter:dic success:^(id object) {
        NSDictionary* dic = object;
        MyLog(@"%@",dic);
        if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
            for (NSDictionary* lDic in dic[@"data"][@"list"]) {
                CWSHistoryOrder* oredr = [[CWSHistoryOrder alloc] initWithDic:lDic];
                [_dataArray addObject:oredr];
            }
            if (_dataArray.count == 0) {
                if (_noDataView == nil) {
                    [self creatNoDataView];
                    self.navigationItem.rightBarButtonItem = nil;
                }
            }
            else {
                //1.创建界面
                [self creatTableView];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
                [self loadShareDataInPage];
            });
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } faile:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];

    
#endif
    
    
    
}
#pragma mark - 创建TableView
-(void)creatTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 18, kSizeOfScreen.width, kSizeOfScreen.height - 40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = kCOLOR(245, 245, 245);
    [self.view addSubview:_tableView];
//    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
}
-(void)creatNoDataView{
    _noDataView = [[CWSNoDataView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height)];
    _noDataView.noDataTitleLabel.text = @"亲，您还没有订单哦~";
    _noDataView.hidden = NO;
    [self.view addSubview:_noDataView];
}
#pragma mark - 上拉加载方法
-(void)footerRefreshing{
    MyLog(@"上拉加载");
    
    _page ++;
    [self getDataWithPage:_page];
    
}

#pragma mark - 下拉刷新方法
-(void)headerRefreshing
{
    MyLog(@"下拉刷新");
    [_dataArray removeAllObjects];
    _page = 1;
    [self getDataWithPage:_page];
    
}
#pragma mark - 更新数据源方法
-(void)loadShareDataInPage
{
    [_tableView.mj_footer endRefreshing];
    [_tableView.mj_header endRefreshing];
}

#pragma mark - 右键删除
- (void)rightBarButtonItemClick:(UIBarButtonItem *)item
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除已完成的订单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark - 订单确认
- (void)confimButtonPressed:(UIButton *)sender
{
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
//    [dataDic setValue:KUserManager.uid forKey:@"uid"];
//    [dataDic setValue:KUserManager.key forKey:@"key"];
//    CWSHistoryOrder *order = _dataArray[_indexPath.row];
//    [dataDic setValue:order.uno forKey:@"uno"];
//    [dataDic setValue:order.orderId forKey:@"carwashId"];
    self.orderConfirmView = [[OrderConfirmView alloc] initWithFrame:[UIScreen mainScreen].bounds controller:self data:dataDic];
    self.orderConfirmView.delegate = self;
    [self.view addSubview:self.orderConfirmView];
    
}

#pragma mark - OrderConfirmDelegate
- (void)alreadyWash:(NSDictionary *)dic
{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    NSDictionary *dict = @{@"uid":dic[@"uid"],
                           @"key":dic[@"key"],
                           @"uno":dic[@"uno"],
                           };
    [ModelTool httpAppGainConfirmOrderWithParameter:dict success:^(id object) {
        NSDictionary* dic = object;
        MyLog(@"%@",dic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"] && [object[@"data"][@"msg"] isEqualToString:@"确认成功！"]) {
                
                [self.orderConfirmView removeFromSuperview];
                [_dataArray removeAllObjects];
                _page = 1;
                [self getDataWithPage:_page];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
        });
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } faile:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:err.localizedDescription delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
}

#pragma mark - tableView数据源协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"historyOrderCell";
    CWSHistoryOrderCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CWSHistoryOrderCell" owner:self options:nil][0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    CWSHistoryOrder* currentOrder = (CWSHistoryOrder*)_dataArray[indexPath.row];
    [cell setOrder:currentOrder];
    cell.delegate = self;

    _order = _dataArray[indexPath.row];
    
    
    
//    effective_time:有效时间：
//    add_time：下单时间；
//    service_time：保养服务时间；
//    finished_time：完成时间；
    //    status：0: 取消; 1: 未付款; 2: 预约中; 3: 完成; 4:已过期
    //完成
    
   
    
    NSString* orderStatus = [NSString stringWithFormat:@"%@",currentOrder.status];
    

    
    

    
    if ([orderStatus isEqualToString:@"3"]) {
       cell.statueLabel.text = @"订单完成";
       cell.statueLabel.textColor = KOrangeColor;
//       [cell.actionButton setTitle:@"评价" forState:UIControlStateNormal];
        cell.actionButton.hidden = YES;
        if ([PublicUtils checkNSNullWithgetString:_order.finished_time] != nil) {
            cell.payTimeLabel.text = [PublicUtils checkNSNullWithgetString:_order.finished_time];
        }
        
        cell.payTimeTitleLabel.text= @"支付时间";
        
    }
    //预约中
    else if ([orderStatus isEqualToString:@"2"])
    {
        cell.statueLabel.text = @"预约中";
        cell.statueLabel.textColor = kCOLOR(54, 188, 153);

        cell.actionButton.hidden = YES;
        if ([PublicUtils checkNSNullWithgetString:_order.add_time] != nil) {
            cell.payTimeLabel.text = [PublicUtils checkNSNullWithgetString:_order.add_time];
        }
       
        cell.payTimeTitleLabel.text= @"下单时间";
    }
    //未付款
    else if ([orderStatus isEqualToString:@"1"])
    {
        cell.statueLabel.text = @"未付款";
        cell.statueLabel.textColor = kCOLOR(249, 98, 102);
        if ([PublicUtils checkNSNullWithgetString:_order.add_time] != nil) {
            cell.payTimeLabel.text = [PublicUtils checkNSNullWithgetString:_order.add_time];
        }
        
        [cell.actionButton setTitle:@"确认付款" forState:UIControlStateNormal];
        cell.payTimeTitleLabel.text= @"下单时间";
    }
    //取消
    else if ([orderStatus isEqualToString:@"0"])
        
    {
        cell.statueLabel.text = @"已取消";
        cell.statueLabel.textColor = [UIColor lightGrayColor];
        if ([PublicUtils checkNSNullWithgetString:_order.finished_time] != nil) {
            cell.payTimeLabel.text = [PublicUtils checkNSNullWithgetString:_order.finished_time];
        }
        
        cell.actionButton.hidden = YES;
        cell.payTimeTitleLabel.text= @"取消时间";
    }
    //过期
    else if ([orderStatus isEqualToString:@"4"]){
        cell.statueLabel.text = @"订单过期";
        cell.statueLabel.textColor = [UIColor lightGrayColor];
        cell.actionButton.hidden = YES;
        cell.payTimeTitleLabel.text= @"过期时间";
        if ([PublicUtils checkNSNullWithgetString:_order.finished_time] != nil) {
            cell.payTimeLabel.text = [PublicUtils checkNSNullWithgetString:_order.finished_time];
        }
        
    }
    //进行中
    else if ([orderStatus isEqualToString:@"12"]){
        cell.statueLabel.text = @"进行中";
        cell.statueLabel.textColor = kCOLOR(54, 188, 153);
        
        cell.actionButton.hidden = YES;
        if ([PublicUtils checkNSNullWithgetString:_order.add_time] != nil) {
            cell.payTimeLabel.text = [PublicUtils checkNSNullWithgetString:_order.add_time];
        }
        
        cell.payTimeTitleLabel.text= @"下单时间";
        
    }
    
    cell.titleLabel.text = _order.goods_name;
    cell.shopNameLabel.text = _order.seller_name;
    cell.moneyLabel.text = [NSString stringWithFormat:@"￥%@",_order.price];
    
    //普洗和精洗
    if ([_order.cate_id_2 integerValue] == 30 || [_order.cate_id_2 integerValue] == 31) {
        cell.headImageViewWidth.constant = 18;
        cell.headImageView.image = [UIImage imageNamed:@"dingdan_xiche"];
    }else if ([_order.cate_id_2 integerValue] == 25 ) {
        //养护
        cell.headImageViewWidth.constant = 18;
        cell.headImageView.image = [UIImage imageNamed:@"dingdan_baoyang"];
    }else if ([_order.cate_id_2 integerValue] == 23 ) {
        //美容
        cell.headImageView.image = [UIImage imageNamed:@"dingdan_meirong"];
    }
    
    
//    [cell.actionButton addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    _order = _dataArray[indexPath.row];
    
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - cell按钮点击事件

-(void)selectTableViewButtonClicked:(UIButton *)sender andOrderHistoryModel:(CWSHistoryOrder *)thyModel{

    if ([sender.currentTitle isEqualToString:@"评价"]) {
        CWSEvaluationViewController *vc = [[CWSEvaluationViewController alloc] init];
        vc.title = @"评价晒单";
        vc.order = thyModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([sender.currentTitle isEqualToString:@"查看详情"]){
        CWSCarWashDetileController* lController = [[CWSCarWashDetileController alloc] init];
        [self.navigationController pushViewController:lController animated:YES];
    }else if ([sender.currentTitle isEqualToString:@"确认付款"]){






        NSMutableDictionary* currentDataDict = @{}.mutableCopy;
        [currentDataDict setObject:thyModel.seller_id forKey:@"store_id"];
        [currentDataDict setObject:thyModel.goods_name forKey:@"goods_name"];
        [currentDataDict setObject:thyModel.orderId forKey:@"goods_id"];
        [currentDataDict setObject:thyModel.price forKey:@"price"];
        [currentDataDict setObject:@"0" forKey:@"is_discount_price"];
        [currentDataDict setObject:thyModel.price forKey:@"discount_price"];
        [currentDataDict setObject:thyModel.seller_name forKey:@"store_name"];
        CWSPayViewController* payVc = [CWSPayViewController new];
        [payVc setDataDict:currentDataDict];
        [self.navigationController pushViewController:payVc animated:YES];
        
        
    }

}


//- (void)actionButtonPressed:(UIButton *)sender
//{
//    if ([sender.currentTitle isEqualToString:@"评价"]) {
//        CWSEvaluationViewController *vc = [[CWSEvaluationViewController alloc] init];
//        vc.title = @"评价晒单";
//        vc.order = _order;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    else if ([sender.currentTitle isEqualToString:@"查看详情"]){
//        CWSCarWashDetileController* lController = [[CWSCarWashDetileController alloc] init];
//        [self.navigationController pushViewController:lController animated:YES];
//    }else if ([sender.currentTitle isEqualToString:@"确认付款"]){
//
//        
//       
//        
//        CWSHistoryOrder* currrentOrderModel = _dataArray[_currentIndex.row];
//        
//        NSMutableDictionary* currentDataDict = @{}.mutableCopy;
//        [currentDataDict setObject:currrentOrderModel.seller_id forKey:@"store_id"];
//        [currentDataDict setObject:currrentOrderModel.goods_name forKey:@"goods_name"];
//        [currentDataDict setObject:currrentOrderModel.orderId forKey:@"goods_id"];
//        [currentDataDict setObject:currrentOrderModel.price forKey:@"price"];
//        [currentDataDict setObject:@"0" forKey:@"is_discount_price"];
//        [currentDataDict setObject:currrentOrderModel.price forKey:@"discount_price"];
//        [currentDataDict setObject:currrentOrderModel.seller_name forKey:@"store_name"];
//        CWSPayViewController* payVc = [CWSPayViewController new];
//        [payVc setDataDict:currentDataDict];
//        [self.navigationController pushViewController:payVc animated:YES];
//        
//        
//    }
//}



#pragma mark - TabelView代理协议
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#if USENEWVERSION
    
    if (_dataArray.count>0) {
        _order = _dataArray[indexPath.row];
    }
    _currentIndex = indexPath;
    MyLog(@"%@",_order.orderId);
    
    NSDictionary* dic = @{@"uid":KUserManager.uid,
                          @"mobile":KUserManager.mobile,
                          @"orderId":_order.orderId};
    
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    [ModelTool getMyOrderDetaikWithParameter:dic andSuccess:^(id object) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]) {
                NSLog(@"%@",object);
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                MyOrderDetailModel *model = [[MyOrderDetailModel alloc] initWithDic:object[@"data"]];
                CWSCarWashDetileController* lController = [[CWSCarWashDetileController alloc] init];
                
                lController.myOrderDetailModel = model;
                
                [self.navigationController pushViewController:lController animated:YES];
            }else {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
        });
        
    } andFail:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
    
#else
    if (_dataArray.count>0) {
        _order = _dataArray[indexPath.row];
    }
    
    MyLog(@"%@",_order.orderId);
    
    NSDictionary* dic = @{@"uid":KUserManager.uid,
                          @"key":KUserManager.key,
                          @"id":_order.orderId};
    
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    [ModelTool httpAppGainWashWithParameter:dic success:^(id object) {
        NSDictionary* dic = object;
        MyLog(@"%@",dic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                OrderWash* orderWash = [[OrderWash alloc] initWithDic:object[@"data"]];
                CWSCarWashDetileController* lController = [[CWSCarWashDetileController alloc] init];
                if ([_order.status integerValue]==1 ) {
                    lController.state = 1;
                    orderWash.washID = _order.orderId;
                    //                    orderWash.uno = _order.uno;
                    //                    orderWash.time = _order.date;
                }
                else {
                    lController.state = 0;
                }
                lController.time = self.time;
                lController.orderWash = orderWash;
                [self.navigationController pushViewController:lController animated:YES];
            }
        });
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } faile:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
#endif
    
}
#pragma mark - tableView代理协议
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 174;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
    }
}

#pragma mark - delegate





@end
