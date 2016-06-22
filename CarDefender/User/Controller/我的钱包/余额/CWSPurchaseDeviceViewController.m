//
//  CWSPurchaseDeviceViewController.m
//  CarDefender
//
//  Created by DRiPhion on 16/6/14.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "CWSPurchaseDeviceViewController.h"
#import "WXApi.h"
#import "WQPay.h"
#import "WXPay.h"
#import "WXUtil.h"
#import "WQAler.h"
#import "payRequsestHandler.h"
#import "CWSRemainMoneyViewController.h"

#define NUM_PAY 3
@interface CWSPurchaseDeviceViewController (){
  
    NSString* price;
    int whichPay;
    NSString* payMethodString;
    UIButton* alipayButton; //支付宝支付
    UIButton* wechatButton; //微信支付
    UISwitch* balanceSwitch; //余额支付开关
   
}



@end

@implementation CWSPurchaseDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"购买设备";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [Utils changeBackBarButtonStyle:self];
    
    [self createUI];
    
}
#pragma mark -==================CreateUI====================
-(void)createUI{
    
    UILabel* label1 = [PublicUtils labelWithFrame:CGRectMake(20, 20, kSizeOfScreen.width, 30) withTitle:@"请选择支付方式" titleFontSize:[UIFont systemFontOfSize:15.0] textColor:KBlackMainColor backgroundColor:nil alignment:0 hidden:NO];
    [self.view addSubview:label1];
    [label1 sizeToFit];
    
    UIView* barrierLine1 = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(label1.frame)+10, kSizeOfScreen.width-40, 1)];
    barrierLine1.backgroundColor = [UIColor colorWithRed:0.961f green:0.961f blue:0.961f alpha:1.00f];
    [self.view addSubview:barrierLine1];
    
    UIView* view1 = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(barrierLine1.frame)+1, barrierLine1.frame.size.width, 47)];
    view1.backgroundColor = [UIColor clearColor];
    
    UIImageView* viewImg1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 31, 31)];
    viewImg1.image = [UIImage imageNamed:@"zhufu"];
    [view1 addSubview:viewImg1];
    UILabel* viewImgLabel1 = [PublicUtils labelWithFrame:CGRectMake(CGRectGetMaxX(viewImg1.frame)+8, 10, kSizeOfScreen.width, 30) withTitle:@"支付宝支付" titleFontSize:[UIFont systemFontOfSize:15.0] textColor:KBlackMainColor backgroundColor:nil alignment:0 hidden:NO];
    [view1 addSubview:viewImgLabel1];
    [viewImgLabel1 sizeToFit];
    UILabel* viewImgLabel2 = [PublicUtils labelWithFrame:CGRectMake(CGRectGetMaxX(viewImg1.frame)+8, CGRectGetMaxY(viewImgLabel1.frame), kSizeOfScreen.width, 30) withTitle:@"推荐有支付宝账号的用户使用" titleFontSize:[UIFont systemFontOfSize:12.0] textColor:[UIColor grayColor] backgroundColor:nil alignment:0 hidden:NO];
    [view1 addSubview:viewImgLabel2];
    [viewImgLabel2 sizeToFit];
    
    [self.view addSubview:view1];
    //    alipay
    //    wx
    //    upacp
    alipayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    alipayButton.frame = view1.frame;
    alipayButton.selected = YES;
    payMethodString = @"alipay";
    [alipayButton setTitle:@"alipay" forState:UIControlStateNormal];
    [alipayButton setImage:[UIImage imageNamed:@"mycar_noclick"] forState:UIControlStateNormal];
    [alipayButton setImage:[UIImage imageNamed:@"mycar_click"] forState:UIControlStateSelected];
    [alipayButton setImageEdgeInsets:UIEdgeInsetsMake(0, view1.frame.size.width-36, 0, 0)];
    [alipayButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -100, 0)];
    [alipayButton addTarget:self action:@selector(payButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    alipayButton.tag = 201;
    [self.view addSubview:alipayButton];
    
    UIView* view2 = nil;
    if([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]){
        
        UIView* barrierLine2 = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(view1.frame)+1, kSizeOfScreen.width-40, 1)];
        barrierLine2.backgroundColor = [UIColor colorWithRed:0.961f green:0.961f blue:0.961f alpha:1.00f];
        [self.view addSubview:barrierLine2];
        
        view2 = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(barrierLine2.frame)+1, barrierLine2.frame.size.width, 47)];
        view2.backgroundColor = [UIColor clearColor];
        
        UIImageView* viewImg2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 31, 31)];
        viewImg2.image = [UIImage imageNamed:@"weixin"];
        [view2 addSubview:viewImg2];
        UILabel* view2ImgLabel1 = [PublicUtils labelWithFrame:CGRectMake(CGRectGetMaxX(viewImg1.frame)+8, 10, kSizeOfScreen.width, 30) withTitle:@"微信支付" titleFontSize:[UIFont systemFontOfSize:15.0] textColor:KBlackMainColor backgroundColor:nil alignment:0 hidden:NO];
        [view2 addSubview:view2ImgLabel1];
        [view2ImgLabel1 sizeToFit];
        UILabel* view2ImgLabel2 = [PublicUtils labelWithFrame:CGRectMake(CGRectGetMaxX(viewImg1.frame)+8, CGRectGetMaxY(viewImgLabel1.frame), kSizeOfScreen.width, 30) withTitle:@"推荐安装微信5.0及以上版本的使用" titleFontSize:[UIFont systemFontOfSize:12.0] textColor:[UIColor grayColor] backgroundColor:nil alignment:0 hidden:NO];
        [view2 addSubview:view2ImgLabel2];
        [view2ImgLabel2 sizeToFit];
        
        [self.view addSubview:view2];
        
        wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        wechatButton.frame = view2.frame;
        [wechatButton setTitle:@"wx" forState:UIControlStateNormal];
        [wechatButton setImage:[UIImage imageNamed:@"mycar_noclick"] forState:UIControlStateNormal];
        [wechatButton setImage:[UIImage imageNamed:@"mycar_click"] forState:UIControlStateSelected];
        [wechatButton setImageEdgeInsets:UIEdgeInsetsMake(0, view2.frame.size.width-36, 0, 0)];
        [wechatButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -100, 0)];
        [wechatButton addTarget:self action:@selector(payButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        wechatButton.tag = 202;
        [self.view addSubview:wechatButton];
    }
    //*********余额支付
    
  
    
    UILabel * balanceLabel = [PublicUtils labelWithFrame:CGRectMake(20, CGRectGetMaxY(view1.frame)+view2.frame.size.height+20, kSizeOfScreen.width, 30) withTitle:@"使用账户余额抵用" titleFontSize:[UIFont systemFontOfSize:15.0] textColor:KBlackMainColor backgroundColor:nil alignment:0 hidden:NO];
    balanceLabel.textColor = KRedColor;
    
    balanceLabel.textAlignment = NSTextAlignmentLeft;
    //        balanceLabel.text = [NSString stringWithFormat:@"可使用余额抵用%.2f元",balanceMoney];
    balanceLabel.text = [NSString stringWithFormat:@"使用账户余额抵用"];
    [self.view addSubview:balanceLabel];
    
    balanceSwitch = [[UISwitch alloc]init];
    balanceSwitch.tag = 203;
    balanceSwitch.frame = CGRectMake(kSizeOfScreen.width-10-balanceSwitch.size.width, balanceLabel.frame.origin.y, balanceSwitch.size.width, balanceSwitch.size.height);
    balanceSwitch.on = NO;
    [balanceSwitch addTarget:self action:@selector(switchClicked:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:balanceSwitch];
    

    //购买设备金额
    UILabel *devicePriceLabel = [PublicUtils labelWithFrame:CGRectMake(20, balanceLabel.frame.size.height+balanceLabel.frame.origin.y+ 20, kSizeOfScreen.width, 30) withTitle:@"购买设备金额:" titleFontSize:[UIFont systemFontOfSize:15.0] textColor:[UIColor blackColor] backgroundColor:nil alignment:0 hidden:NO];
    devicePriceLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:devicePriceLabel];
    NSString *dePrice = [NSString stringWithFormat:@"￥%@元",self.devicePrice];
    UILabel *devicePriceLabel1 = [PublicUtils labelWithFrame:CGRectMake(120, balanceLabel.frame.size.height+balanceLabel.frame.origin.y+ 20, kSizeOfScreen.width, 30) withTitle:dePrice titleFontSize:[UIFont systemFontOfSize:15.0] textColor:[UIColor blackColor] backgroundColor:nil alignment:0 hidden:NO];
    devicePriceLabel1.textAlignment = NSTextAlignmentLeft;
    devicePriceLabel1.backgroundColor = [UIColor whiteColor];
    devicePriceLabel1.textColor = kMainColor;
    [self.view addSubview:devicePriceLabel1];
    
    
    UIButton* comfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    comfirmButton.frame = CGRectMake(0, CGRectGetMaxY(balanceLabel.frame)+77, kSizeOfScreen.width, 38);
    comfirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    comfirmButton.layer.cornerRadius = 2;
    [comfirmButton setBackgroundColor:[UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1.00f]];
    [comfirmButton setTitle:@"确定充值" forState:UIControlStateNormal];
    [comfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [comfirmButton addTarget:self action:@selector(comfirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:comfirmButton];
    
}

#pragma mark --==  OtherCallBack ==--
/**支付方式按钮回调*/
-(void)payButtonClicked:(UIButton*)sender{
    for(int i=0; i<NUM_PAY; i++){
        UIButton* button = (UIButton*)[self.view viewWithTag:201+i];
        button.selected = NO;
    }
    sender.selected = YES;
    payMethodString = sender.titleLabel.text;
    balanceSwitch.on=NO;
    
}

//开关事件
-(void)switchClicked:(UISwitch*)sender{
    
    if(sender.on){
        wechatButton.selected = NO;
        [wechatButton setImage:[UIImage imageNamed:@"mycar_noclick"] forState:UIControlStateNormal];
        alipayButton.selected = NO;
        [alipayButton setImage:[UIImage imageNamed:@"mycar_noclick"] forState:UIControlStateNormal];
        
        payMethodString = @"yue";
    }else{
        wechatButton.selected = NO;
        [wechatButton setImage:[UIImage imageNamed:@"mycar_noclick"] forState:UIControlStateNormal];
        alipayButton.selected = YES;
        [alipayButton setImage:[UIImage imageNamed:@"mycar_click"] forState:UIControlStateNormal];
     
        payMethodString = @"alipay";
       
    }
   

}
/**确认订单按钮*/
-(void)comfirmButtonClicked:(UIButton*)sender{
    /*
     以下是新版支付方式
     */
    
   
    if(self.devicePrice){
        //在线支付
        NSLog(@"payMethodString=%@",payMethodString);
        [MBProgressHUD showMessag:@"订单提交中..." toView:self.view];
        NSString *paymentType;
        if([payMethodString isEqualToString:@"wx"]){
            paymentType = @"WECHAT";
        }else if([payMethodString isEqualToString:@"alipay"]){
            paymentType = @"ALIPAY";
        }else if([payMethodString isEqualToString:@"yue"]){
            paymentType = @"WALLET";
        }
       
        //chargeType:PD  购买设备  CI普通充值
        NSDictionary *dic = @{@"userId":KUserInfo.desc,@"token":KUserInfo.token,@"chargeType":@"PD",@"paymentType":paymentType,@"deviceNo":self.deviceNo};
        NSLog(@"datadic%@",dic);
        [HttpHelper getbalanceChargeInWithUserDic:dic
                                 success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                     
                                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                     NSDictionary* rootDict = [NSDictionary dictionaryWithDictionary:responseObjcet];
                                     //                MyLog(@"----------充值返回信息-----------%@",[PublicUtils showServiceReturnMessage:rootDict[@"msg"]]);
                                     MyLog(@"----------充值返回信息-----------%@",rootDict);
                                     if([rootDict[@"code"] isEqualToString:SERVICE_SUCCESS]){
                                         
                                         if([payMethodString isEqualToString:@"wx"]){
                                             //使用微信支付
                                             WXPay* thyWeiXinPay = [WXPay shareInstance];
                                             thyWeiXinPay.isSuccess = NO;
                                             [self WXPayWithParamDict:rootDict[@"msg"]];
                                             
                                         }else if([payMethodString isEqualToString:@"alipay"]){
                                             //使用支付宝支付
                                             [self AlipayWithPrice:[NSString stringWithFormat:@"%@元",self.devicePrice] andOrderNum:rootDict[@"msg"][@"out_trade_no"]];
                                         }else  if([payMethodString isEqualToString:@"yue"]){
                                             
                                             //余额支付成功后回调
                                             [self updateCarServicePayStatus:rootDict];
                                             
                                             
                                         }
                                         
                                     }else{
                                         [self alert:@"温馨提示" msg:[PublicUtils showServiceReturnMessage:rootDict[@"desc"]]];
                                     }
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                     [self alert:@"温馨提示" msg:@"网络出错,请重新加载"];
                                 }];
    }else{
        //使用红包或者余额支付
        [MBProgressHUD showMessag:@"订单提交中..." toView:self.view];
            }
    
  
    
}


#pragma mark -======================支付的方法回调
/**新版微信支付*/
-(void)WXPayWithParamDict:(NSDictionary*)thyDict{
    NSString* time_stamp, *nonce_str, *package;
    time_t now;
    time(&now);
    time_stamp = [NSString stringWithFormat:@"%ld",now];
    nonce_str = [WXUtil md5:time_stamp];
    package = @"Sign=WXPay";
    NSMutableDictionary* signParams = [NSMutableDictionary dictionary];
    [signParams setObject:APP_ID forKey:@"appid"];
    [signParams setObject:nonce_str forKey:@"noncestr"];
    [signParams setObject:package forKey:@"package"];
    [signParams setObject:MCH_ID forKey:@"partnerid"];
    [signParams setObject:time_stamp forKey:@"timestamp"];
    [signParams setObject:[NSString stringWithFormat:@"%@",thyDict[@"prepay_id"]] forKey:@"prepayid"];
    
    //生成签名
    NSString *sign  = [self createMd5Sign:signParams];
    
    //添加签名
    [signParams setObject:sign forKey:@"sign"];
    
    PayReq* request = [[PayReq alloc]init];
    request.openID = APP_ID;
    request.partnerId = MCH_ID;
    request.nonceStr = signParams[@"noncestr"];
    request.package = signParams[@"package"];
    request.prepayId = signParams[@"prepayid"];
    request.sign = signParams[@"sign"];
    request.timeStamp = [signParams[@"timestamp"] intValue];
    [WXApi sendReq:request];
    [[WXPay shareInstance]setPaySucc:^{
        
        [self backMyWalletPaySucess];
        
    }];
}

/**支付宝支付*/
-(void)AlipayWithPrice:(NSString*)thyPrice andOrderNum:(NSString*)thyOrderNum{
    [[WQPay shareInstance]payProductArray:thyPrice AndOrderID:thyOrderNum];
    [[WQPay shareInstance] setPaySucc:^{
       
        [self backMyWalletPaySucess];
        
    }];
}
#pragma mark =======================余额支付回调
-(void)updateCarServicePayStatus:(NSDictionary*)dic{
    
    
     NSDictionary *postDic = @{@"userId":KUserInfo.desc,@"token":KUserInfo.token,@"paymentType":@"WALLET",@"deviceNo":self.deviceNo,@"recordNo":@"322"};
    [MBProgressHUD showMessag:@"正在生成订单..." toView:self.view];
    [HttpHelper getPurDeviceChargeWithUserDic:postDic success:^(AFHTTPRequestOperation *operation , id object){
        NSLog(@"正在生成订单%@",object);
        NSDictionary *dataD = (NSDictionary *)object;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if([dataD[@"code"] isEqualToString:SERVICE_SUCCESS]){
           [self backMyWalletPaySucess];
        }else{
            
            [self alert:@"温馨提示" msg:[PublicUtils showServiceReturnMessage:dataD[@"desc"]]];
            
        }
    
    } failure:^(AFHTTPRequestOperation *operation , NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self alert:@"温馨提示" msg:@"网络出错,请重新加载"];
    }];
    
    
}
-(void)backMyWalletPaySucess{
    CWSRemainMoneyViewController *remainView = [self.navigationController.viewControllers objectAtIndex:2];
    if ([remainView isKindOfClass:[CWSRemainMoneyViewController class]
        ]) {
        remainView.identifier = 111;
        [self.navigationController popToViewController:remainView animated:YES];
    }else{
        [self alert:@"提示" msg:@"支付成功"];
    }
    
}
#pragma mark -======================其他方法的回调
//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alter show];
}

-(NSString*) createMd5Sign:(NSMutableDictionary*)dict{
    
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", PARTNER_ID];
    //得到MD5 sign签名
    NSString *md5Sign =[WXUtil md5:contentString];
    
    MyLog(@"-------关键字串---------%@",contentString);
    MyLog(@"-------生成的md5------%@",md5Sign);
    
    
    return md5Sign;
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
