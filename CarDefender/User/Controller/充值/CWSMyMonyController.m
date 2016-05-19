//
//  CWSMyMonyController.m
//  CarDefender
//
//  Created by 李散 on 15/8/29.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSMyMonyController.h"
//#import "Order.h"
//#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "CWSMyWealthDetailsController.h"
//#import "APAuthV2Info.h"
#import "ModelTool.h"


#import "CWSPurchaseViewController.h"


@interface CWSMyMonyController ()
{
    UIView*_backAlphView;
    int _selectBtn;
    BOOL _protectBool;
}
@end

@implementation CWSMyMonyController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.backString isEqualToString:@"back"]) {
        self.backString = @"";
        if (_protectBool) {//买了保险
            self.protectLabel.text = @"账户安全险保障中";
            //        self.protectLabel.textColor = kCOLOR(98, 206, 73);
        }else{//没有买保险
            self.protectLabel.text = @"保险购买通道";
            //        self.protectLabel.textColor = kCOLOR(254, 98, 112);
        }
        [self loadData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    [self buildUI];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ModelTool stopAllOperation];
}

-(void)loadData
{
//    self.yeLable.text = KUserManager.account.cash;
    [self.yeButton setTitle:KUserManager.account.cash forState:UIControlStateNormal];
    self.yjLabel.text = KUserManager.account.freeze;
    self.zjeLabel.text = KUserManager.account.total;
    self.hfLabel.text = KUserManager.account.calling;
}
- (void)buildUI
{
    //red color :254 98 112;
    //green color :98 206 73
    _protectBool = [KUserManager.account.insurance boolValue];
    self.protectLabel.font = [UIFont fontWithName:@"icomoon" size:12];
    self.protectLabel.textColor = kCOLOR(98, 206, 73);
    if (_protectBool) {//买了保险
        self.protectLabel.text = @"账户安全险保障中";
//        self.protectLabel.textColor = kCOLOR(98, 206, 73);
    }else{//没有买保险
        self.protectLabel.text = @"保险购买通道";
//        self.protectLabel.textColor = kCOLOR(254, 98, 112);
    }
    _selectBtn = 12;
    self.view300.hidden = NO;
    self.title = @"我的财富";
    [Utils setViewRiders:self.notiView riders:4];
    [Utils setViewRiders:self.czBtn riders:4];
    [Utils setViewRiders:self.cancelBtn riders:4];
    
    _backAlphView = [[UIView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_backAlphView];
    [self.view bringSubviewToFront:self.notiView];
    _backAlphView.backgroundColor = KBlackMainColor;
    _backAlphView.alpha = 0.5;
    _backAlphView.hidden = YES;
    self.notiView.hidden = YES;
    self.notiView.center = CGPointMake(kSizeOfScreen.width/2, (kSizeOfScreen.height-kDockHeight)/2);
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    
    //给self.view添加一个手势监测；
    [_backAlphView addGestureRecognizer:singleRecognizer];
    
    [Utils setViewRiders:self.view1 riders:10];
    [Utils setBianKuang:kCOLOR(61, 154, 250) Wide:1 view:self.view1];
    [Utils setViewRiders:self.view2 riders:10];
    [Utils setBianKuang:kCOLOR(61, 154, 250) Wide:1 view:self.view2];
    [Utils setViewRiders:self.view3 riders:10];
    [Utils setBianKuang:kCOLOR(61, 154, 250) Wide:1 view:self.view3];
    [Utils setViewRiders:self.view4 riders:10];
    [Utils setBianKuang:kCOLOR(61, 154, 250) Wide:1 view:self.view4];
    
    [Utils setViewRiders:self.view100 riders:5];
    [Utils setViewRiders:self.view200 riders:5];
    [Utils setViewRiders:self.view300 riders:5];
    [Utils setViewRiders:self.view400 riders:5];
    [Utils setViewRiders:self.sureBtn riders:4];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)btnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1://余额详情
        {
            CWSMyWealthDetailsController* lController = [[CWSMyWealthDetailsController alloc] init];
            lController.title = @"话费详情";
            lController.type = @"fee";
            [self.navigationController pushViewController:lController animated:YES];
        }
            break;
        case 2://话费详情
        {
            CWSMyWealthDetailsController* lController = [[CWSMyWealthDetailsController alloc] init];
            lController.title = @"话费详情";
            lController.type = @"call";
            [self.navigationController pushViewController:lController animated:YES];
        }
            break;
        case 3://账户充值
        {
            //self.notiView.hidden = NO;
            //_backAlphView.hidden = NO;
            CWSPurchaseViewController* myPurchaseVc = [CWSPurchaseViewController new];
            myPurchaseVc.remainMoneyVc = self;
            [self.navigationController pushViewController:myPurchaseVc animated:YES];
            
        }
            break;
        case 4://充值
        {
//            if (_selectBtn) {
//                NSString*totleMoney;
//                if (_selectBtn == 10) {
//                    totleMoney = @"100";
//                }else if (_selectBtn == 11){
//                    totleMoney = @"300";
//                }else if (_selectBtn == 12){
//                    totleMoney = @"600";
//                }else if (_selectBtn==13) {
//                    totleMoney = @"1000";
//                }
//                //                totleMoney = @"0.01";
//                
//                NSString*nameDescri = [[NSString stringWithFormat:@"车生活-%@元充值",totleMoney] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
//                [ModelTool httpAppGainPgyOrderWithParameter:@{@"uid":KUserManager.uid,@"total_fee":totleMoney,@"key":KUserManager.key,@"quantity":@"1",@"price":totleMoney,@"subject":nameDescri,@"body":nameDescri,@"payment_type":@"1"} success:^(id object) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        MyLog(@"%@",object);
//                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                        if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
//                            [self userZhiFuBaoWithPrice:totleMoney withTradNo:[NSString stringWithFormat:@"%@",object[@"data"][@"out_trade_no"]]];
//                        }
//                    });
//                } faile:^(NSError *err) {
//                    MyLog(@"%@",err);
//                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                }];
//            }else{
//                UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择充值金额" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
//            }
        }
            break;
        case 5://取消充值
        {
            self.notiView.hidden = YES;
            _backAlphView.hidden = YES;
            if (_selectBtn) {
                UIView*view = [self.notiView viewWithTag:_selectBtn+10];
                view.hidden = YES;
                _selectBtn = 12;
                self.view300.hidden = NO;
            }
        }
            break;
        default:
            break;
    }
}
-(void)SingleTap:(UITapGestureRecognizer*)sender
{
    self.notiView.hidden = YES;
    _backAlphView.hidden = YES;
    if (_selectBtn) {
        UIView*view = [self.notiView viewWithTag:_selectBtn+10];
        view.hidden = YES;
        _selectBtn = 12;
        self.view300.hidden = NO;
    }
}
- (IBAction)btnEvent:(UIButton *)sender {
    if (_selectBtn) {
        UIView*view = [self.notiView viewWithTag:_selectBtn+10];
        view.hidden = YES;
    }
    _selectBtn = (int)sender.tag;
    UIView*view1 = [self.notiView viewWithTag:sender.tag + 10];
    view1.hidden = NO;
}
-(void)userZhiFuBaoWithPrice:(NSString*)price withTradNo:(NSString*)tadeNo
{
//    NSString *partner = @"2088021552530780";
//    NSString *seller = @"chcws@chcws.com";
//    NSString *privateKey =@"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAL4Lx8cgCyPVKxjdr3IBch3JG+/AreSbjhLqN0pM4HlPEkQGmoihzptSVe+o1ywALgkul/1e5fUljqAGAbtyhmxk9dRs3QddKposOzStoX9ReTWmMJPtC5cNXbclg7QbYKrzw25sUkxGHMP9KInZV7qAnhwFg5TDmk87Lab5JrmPAgMBAAECgYBJ0uWuEmKBbuMo66Slkq4zp9W0UpK6RTrxWg5UTHy+YtrjlfUdsk1BxMAhMuMy8nbvlivwfpaxnf9DZlHx8NEKSY+vpj/jZyir1Nscf9Dya7ak5EgvBPBE/5KtJqpx7WD1qJjAoaumTh0ljy9B5G88RcLFNA2U27NjchCO9SjmIQJBAPn/g8omfRGHJoBJHXsIBYripnCld7J1V/Ekyjb8r4rQtH8bS/NK30CR1ToPD0gjcEDTgYkLkONqUUmJ9EWBwOcCQQDCm80BkFTt0TxjxqLSpyEJcsZdp7dHFVUDaHEci/WVVwldcaPdw9THkHybB3KvwzIVzuClq2QYvRptZ+qN6qUZAkA+sHYp0PD33j4nWS5NVbueEivOf4++bnJ5A9K5ay/RzXgVj5DCF3pYRLmFb5VTb5+Mgf0vknjorhZoLHHWpCztAkEAosXuEwDGCKSZ/lqGlet0lpKJmIxPoAUXtmIFOftWzjKegqoqhbLmpoUTtBfmtVxu6A7Bl9BjSM3i7N+eMFWzAQJAIfUnYgTQ8RKBZ0gkK98FuGcsYU6aPvKzyGaPeczKdsp4xZgEdlppCzwxn/Kd9kKRrL2PKkgBzQ5Vaygvu8dqNg==";
//    //partner和seller获取失败,提示
//    if ([partner length] == 0 ||
//        [seller length] == 0 ||
//        [privateKey length] == 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"缺少partner或者seller或者私钥。"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
//    /*
//     *生成订单信息及签名
//     */
//    //将商品信息赋予AlixPayOrder的成员变量
//    Order *order = [[Order alloc] init];
//    order.partner = partner;
//    order.seller = seller;
//    order.tradeNO = tadeNo; //订单ID（由商家自行制定）
//    order.productName = [NSString stringWithFormat:@"车生活-%@元充值",price]; //商品标题
//    order.productDescription = [NSString stringWithFormat:@"车生活-%@元充值",price]; //商品描述
//    order.amount = price; //商品价格
//    order.notifyURL =  @"http://115.28.161.11:8080/XAI/app/pgy/notify_url.do"; //回调URL
//    
//    order.service = @"mobile.securitypay.pay";
//    order.paymentType = @"1";
//    order.inputCharset = @"utf-8";
//    order.itBPay = @"30m";
//    order.showUrl = @"m.alipay.com";
//    
//    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
//    NSString *appScheme = @"cheweishiAlisdk";
//    
//    //将商品信息拼接成字符串
//    NSString *orderSpec = [order description];
//    NSLog(@"orderSpec = %@",orderSpec);
//    
//    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//    id<DataSigner> signer = CreateRSADataSigner(privateKey);
//    NSString *signedString = [signer signString:orderSpec];
//    
//    //将签名成功字符串格式化为订单字符串,请严格按照该格式
//    NSString *orderString = nil;
//    if (signedString != nil) {
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
//
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"reslut = %@",resultDic);
//            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
//                MyLog(@"成功");
//                if (_selectBtn) {
//                    UIView*view = [self.notiView viewWithTag:_selectBtn+10];
//                    view.hidden = YES;
//                    self.notiView.hidden = YES;
//                    _backAlphView.hidden = YES;
//                    _selectBtn = 12;
//                    self.view300.hidden = NO;
//                }
//                [self checkLoginOrNo];
//            }else {
//                UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:resultDic[@"memo"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
//            }
//        }];
//    }
}


#pragma mark - 获取用户数据
-(void)checkLoginOrNo
{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    [ModelTool httpAppGainNewLoginWithParameter:@{@"uid":KUserManager.uid,@"key":KUserManager.key} success:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                NSDictionary*dic=object[@"data"];
                NSMutableDictionary*dicMsg=[NSMutableDictionary dictionaryWithDictionary:dic];
                NSDictionary*dic1=dicMsg[@"car"];
                NSMutableDictionary*carMsgDic=[NSMutableDictionary dictionaryWithDictionary:dic1];
                [carMsgDic setObject:[Utils checkNSNullWithgetString:carMsgDic[@"isDefault"]] forKey:@"isDefault"];
                [dicMsg setObject:carMsgDic forKey:@"car"];
                UserNew* lUser = [[UserNew alloc] initWithDic:dic];
                KUserManager = lUser;
                NSUserDefaults*user=[[NSUserDefaults alloc]init];
                [user setObject:dicMsg forKey:@"user"];
                [NSUserDefaults resetStandardUserDefaults];
                
                [self loadData];
            }
        });
    } faile:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
}
@end
