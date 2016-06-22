//
//  CWSCarWashDetileController.m
//  CarDefender
//
//  Created by 周子涵 on 15/8/20.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSCarWashDetileController.h"
#import "UIImageView+WebCache.h"
#import "OrderStatusView.h"
#import "OrderProcessView.h"
#import "ShopNameView.h"
#import "ShopFootView.h"
#import "OrderCancleProcessView.h"
#import "RecordTableViewCell.h"
#import "CWSCancleOrderViewController.h"


#define kDistanceNomarl 10

@interface CWSCarWashDetileController ()<UITableViewDataSource,UITableViewDelegate>
{
    OrderStatusView *orderStatusView;
    OrderProcessView *orderProcessView;
    OrderCancleProcessView *orderCancleProcessView;
    ShopNameView *shopNameView;
    ShopFootView *shopFootView;
    UITableView *_tableView;
    UIScrollView *scrollView;
    UIBarButtonItem*rightBtn;
    NSDictionary *dataDic ;
    NSArray *goodArray;
    float screenWidth;
}

@end

@implementation CWSCarWashDetileController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    
    [self initalizeUserInterface];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"cancleOrder" object:nil];
}

#pragma mark - 通知事件
- (void)notification:(NSNotification *)info
{
    NSDictionary* dic;
    //重新调用详情接口，刷新数据
    if (self.myOrderDetailModel != nil) {
        dic = @{@"uid":KUserManager.uid,
                @"mobile":KUserManager.mobile,
                @"orderId":self.myOrderDetailModel.orderId};
    }
    else {
        dic = @{@"uid":KUserManager.uid,
                @"mobile":KUserManager.mobile,
                @"orderId":self.dataDict[@"orderId"]};
    }
    
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    [ModelTool getMyOrderDetaikWithParameter:dic andSuccess:^(id object) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
               
                
                
                orderStatusView.statusImageView.image = [UIImage imageNamed:@"dingdanxiangqing_cancel"];
                orderStatusView.statusLabel.text = @"订单已取消";
                orderStatusView.centerConstraint.constant += 60;
                orderStatusView.statusLabel.textColor = kCOLOR(247, 71, 82);
                self.navigationItem.rightBarButtonItem = nil;
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
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancleOrder" object:nil];
}

#pragma mark - 导航栏返回按钮点击事件
-(void)barButtonClick{

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 界面
- (void)initalizeUserInterface
{
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    scrollView.pagingEnabled = YES;
    scrollView.userInteractionEnabled = YES;
    [self.view addSubview:scrollView];
    
    if (self.myOrderDetailModel != nil) {
        
        dataDic = @{@"add_time":self.myOrderDetailModel.add_time,@"address":self.myOrderDetailModel.address,
                    @"effective_time":self.myOrderDetailModel.effective_time,
                    @"finished_time":self.myOrderDetailModel.finished_time,
                    @"goodsName":@"",@"im_lat":self.myOrderDetailModel.im_lat,
                    @"im_lng":@"",@"mobile":self.myOrderDetailModel.im_lng,
                    @"orderGoodsList":self.myOrderDetailModel.orderGoodsList,
                    @"orderId":self.myOrderDetailModel.orderId,
                    @"order_sn":self.myOrderDetailModel.order_sn,
                    @"owner_name":self.myOrderDetailModel.owner_name,
                    @"reputation":self.myOrderDetailModel.reputation,
                    @"service_time":self.myOrderDetailModel.service_time,
                    @"status":[NSString stringWithFormat:@"%ld",(long)self.myOrderDetailModel.status],
                    @"store_name":self.myOrderDetailModel.store_name,
                    @"image_1":self.myOrderDetailModel.image_1,
                    @"barcodes":self.myOrderDetailModel.barcodes,
                    };
        
        
        
    }
    else {
        dataDic = [NSDictionary dictionaryWithDictionary:self.dataDict];
    }
    
    
    
    NSString * orserID = [NSString string];
    
    if (self.order) {
        //历史订单条状获取orderID
        orserID = self.order.orderId;
    }else if (self.tag==101){
        //支付成功页面，成功后 tag设置101
        orserID = self.dataDict[@"orderId"];
    }else{
        //预约跳转此页后  直接获取orderID
        orserID = self.orderID;
    }
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    NSDictionary* dic= @{@"userId":KUserInfo.desc,
                         @"token":KUserInfo.token,
                         @"recordId":orserID};
    NSLog(@"%@",self.dataDict);
    NSLog(@"dic====%@",dic);
    [HttpHelper searchCarServiceRecordDetailWithUserDic:dic success:^(AFHTTPRequestOperation *operation,id object){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"object=%@",object);
            if ([object[@"code"] isEqualToString:SERVICE_SUCCESS]) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                dataDic = [NSDictionary dictionaryWithDictionary:object[@"msg"]];
                
                [self createUI];
            }else {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
        });
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
    
    
    
}

-(void)createUI{
    
    goodArray = [NSArray arrayWithArray:dataDic[@"orderGoodsList"]];
    
    
    //状态视图
    orderStatusView = [[OrderStatusView alloc] initWithFrame:CGRectMake(0, 0,screenWidth ,45 ) Data:dataDic];
    [scrollView addSubview:orderStatusView];
    
    //过程视图
    orderProcessView = [[OrderProcessView alloc] initWithFrame:CGRectMake(0, orderStatusView.endY+20,screenWidth ,76 ) Data:dataDic];
    [scrollView addSubview:orderProcessView];
    
    
    
    NSString *categoryName = [NSString stringWithFormat:@"%@",self.dataDict[@"categoryName"]];
    if ([self.order.categoryName isEqualToString:@"洗车"]||[categoryName isEqualToString:@"洗车"]) {
        orderProcessView.hidden = YES;
        orderCancleProcessView.hidden= NO;
        orderCancleProcessView = [[OrderCancleProcessView alloc] initWithFrame:CGRectMake(0, orderStatusView.endY+20,screenWidth ,76 ) Data:dataDic];
        [scrollView addSubview:orderCancleProcessView];
        [scrollView bringSubviewToFront:orderCancleProcessView];
    }else{
        orderProcessView.hidden = NO;
        orderCancleProcessView.hidden= YES;
    }
    
    //    status：0: 取消; 1: 未付款; 2: 预约中; 3: 完成 4:已过期 12进行中
    if (self.myOrderDetailModel != nil) {
        switch (self.myOrderDetailModel.status) {
            case 0:{
                [orderProcessView removeFromSuperview];
                orderCancleProcessView = [[OrderCancleProcessView alloc] initWithFrame:CGRectMake(0, orderStatusView.endY+20,[UIScreen mainScreen].bounds.size.width ,76 ) Data:dataDic];
                [scrollView addSubview:orderCancleProcessView];
                [scrollView bringSubviewToFront:orderCancleProcessView];
                orderStatusView.centerConstraint.constant += 60;
                orderStatusView.statusImageView.image = [UIImage imageNamed:@"dingdanxiangqing_cancel"];
                orderStatusView.statusLabel.text = @"订单已取消";
                orderStatusView.statusLabel.textColor = kCOLOR(247, 71, 82);
                self.navigationItem.rightBarButtonItem = nil;
            }
                break;
            case 1:{
                //                orderStatusView.statusLabel.text = @"已到店洗车,等待用户确认付款...";
                orderStatusView.statusLabel.text = @"请在15分钟之内确认付款";
            }
                break;
            case 2:{
                
                rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"取消订单" style:UIBarButtonItemStylePlain target:self action:@selector(cancleOrderButtonPressed:)];
                rightBtn.tintColor = [UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1];
                //self.navigationItem.rightBarButtonItem=rightBtn;
                
            }
                break;
            case 3:{
                orderStatusView.statusLabel.text = @"已完成";
                orderStatusView.centerConstraint.constant += 60;
            }
                break;
            case 4:{
                [orderProcessView removeFromSuperview];
                orderCancleProcessView = [[OrderCancleProcessView alloc] initWithFrame:CGRectMake(0, orderStatusView.endY+20,[UIScreen mainScreen].bounds.size.width ,76 ) Data:dataDic];
                
                orderCancleProcessView.secondTitleLabel.text = @"已过期";
                [scrollView addSubview:orderCancleProcessView];
                [scrollView bringSubviewToFront:orderCancleProcessView];
                
                orderStatusView.centerConstraint.constant += 60;
                orderStatusView.statusImageView.image = [UIImage imageNamed:@"dingdanxiangqing_cancel"];
                orderStatusView.statusLabel.text = @"订单已过期";
                orderStatusView.statusLabel.textColor = kCOLOR(247, 71, 82);
                self.navigationItem.rightBarButtonItem = nil;
                
            }
                break;
            case 12:{
//                rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"取消订单" style:UIBarButtonItemStylePlain target:self action:@selector(cancleOrderButtonPressed:)];
//                rightBtn.tintColor = [UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1];
//                self.navigationItem.rightBarButtonItem=rightBtn;
                orderStatusView.statusLabel.text = @"请在72小时之内到店洗车";
            }
                break;
            default:
                break;
        }
        
    }else {
        //预约和美容点过来的  订单详情查询
        NSString *chargeStatus = self.dataDict[@"chargeStatus"];
        if([chargeStatus isEqualToString:@"RESERVATION_FAIL"]){
            [orderProcessView removeFromSuperview];
            
            
            orderStatusView.centerConstraint.constant += 60;
            orderStatusView.statusImageView.image = [UIImage imageNamed:@"dingdanxiangqing_cancel"];
            orderStatusView.statusLabel.text = @"预约失败";
            orderStatusView.statusLabel.textColor = kCOLOR(247, 71, 82);
            self.navigationItem.rightBarButtonItem = nil;
        }else if ([chargeStatus isEqualToString:@"UNPAID"])
        {
            orderStatusView.statusLabel.text = @"请在15分钟之内确认付款";
        }
        
        else if([chargeStatus isEqualToString:@"RESERVATION"]){
            
            rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"取消订单" style:UIBarButtonItemStylePlain target:self action:@selector(cancleOrderButtonPressed:)];
            rightBtn.tintColor = [UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1];
            //self.navigationItem.rightBarButtonItem=rightBtn;
        }
        
        else if([chargeStatus isEqualToString:@"FINISH"]){
            orderStatusView.statusLabel.text = @"已完成";
            orderStatusView.centerConstraint.constant += 60;
        }else if ([chargeStatus isEqualToString:@"OVERDUE"])
            
        {
            
            
            orderStatusView.centerConstraint.constant += 60;
            orderStatusView.statusLabel.text = @"订单已过期";
            orderStatusView.statusLabel.textColor = kCOLOR(247, 71, 82);
            self.navigationItem.rightBarButtonItem = nil;
        }
        
        else if([chargeStatus isEqualToString:@"RESERVATION_SUCCESS"]){
            
            orderStatusView.statusLabel.text = @"预约成功";
        }
        
        
        
    }
    
    
    //店铺视图
    shopNameView = [[ShopNameView alloc] initWithFrame:CGRectMake(0, orderProcessView.endY+20,screenWidth ,70 ) Data:dataDic controller:self];
  
    [scrollView addSubview:shopNameView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, shopNameView.endY+20, screenWidth, (goodArray.count+1)*40) style:UITableViewStylePlain];
    _tableView.rowHeight = 40;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = kCOLOR(225, 225, 225);
    [scrollView addSubview:_tableView];
    
    //下方视图
    shopFootView = [[ShopFootView alloc] initWithFrame:CGRectMake(0, _tableView.endY, screenWidth, 403) Data:dataDic];
    [scrollView addSubview:shopFootView];
    
    scrollView.contentSize = CGSizeMake(screenWidth, shopFootView.endY+80);

}


#pragma mark - 取消订单
- (void)cancleOrderButtonPressed:(UIBarButtonItem *)item
{
     CWSCancleOrderViewController *vc = [[CWSCancleOrderViewController alloc] init];
    if (self.myOrderDetailModel) {
       
        vc.orderId = [self.myOrderDetailModel.orderId integerValue];
        
    }
    else {
        vc.orderId = [self.dataDict[@"orderId"] integerValue];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return goodArray.count+1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    UINib *nib = [UINib nibWithNibName:@"RecordTableViewCell" bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:@"recordTableViewCell"];
    RecordTableViewCell *cell = [[RecordTableViewCell alloc] init];
    cell = [tableView dequeueReusableCellWithIdentifier:@"recordTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
//    if (indexPath.row == 0) {
//        cell.recordLabel.alpha = 0;
//        cell.dateLabel.alpha = 0;
//        cell.titleLabel.textColor = KBlackMainColor;
//        cell.titleLabel.text = @"现代 朗动保养套餐";
//    }
//    else if (indexPath.row == 5) {
//        cell.recordLabel.alpha = 0;
//        cell.dateLabel.textColor = kCOLOR(254, 98, 112);
//        cell.dateLabel.text = @"￥580";
//        cell.titleLabel.textColor = KBlackMainColor;
//        cell.titleLabel.text = @"订单金额";
//    }
//    else {
//        cell.recordLabel.alpha = 0;
//        cell.dateLabel.textColor = KBlackMainColor;
//        cell.titleLabel.text = @"更换机油";
//        cell.dateLabel.text = @"￥580";
//    }
    
    //最后一行订单总金额
    if (indexPath.row == goodArray.count) {
        cell.recordLabel.alpha = 0;
        cell.dateLabel.textColor = kCOLOR(254, 98, 112);
//        NSInteger count = 0;
//        for (NSDictionary *dic in goodArray) {
//            count += [dic[@"price"] integerValue];
//        }
//        NSLog(@"%ld",count);
        NSString *price = self.dataDict[@"price"];
        cell.dateLabel.text = [NSString stringWithFormat:@"￥%@",price];
        cell.titleLabel.textColor = KBlackMainColor;
        cell.titleLabel.text = @"订单金额";
    }else {
        cell.recordLabel.alpha = 0;
        cell.dateLabel.textColor = KBlackMainColor;
        cell.titleLabel.text = self.dataDict[@"tenantInfo"][@"tenantName"];
        cell.dateLabel.text = [NSString stringWithFormat:@"￥%@",self.dataDict[@"price"]];

    }
    
    return cell;
    
}



#pragma mark - TabelView代理协议
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -设置tableView分割线
-(void)viewDidLayoutSubviews
{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


@end
