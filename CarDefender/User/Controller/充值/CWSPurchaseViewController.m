//
//  CWSPurchaseViewController.m
//  CarDefender
//
//  Created by 王泰莅 on 15/11/21.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSPurchaseViewController.h"
#import "CWSMyMonyController.h"



#import "WXApi.h"
#import "WQPay.h"
#import "WXPay.h"
#import "WXUtil.h"
#import "WQAler.h"
#import "payRequsestHandler.h"

#define NUM_PAY 4
#define NUM_PURCHASE 4

@interface CWSPurchaseViewController (){
    NSString* selectedPay;
    NSString* price;
    int whichPay;
}

@end

@implementation CWSPurchaseViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户充值";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [Utils changeBackBarButtonStyle:self];
    
    [self createUI];
}

- (void)viewWillDisappear:(BOOL)animated{
    [ModelTool stopAllOperation];
}

#pragma mark -==================CreateUI====================
-(void)createUI{
//    NSString* titleLabelString = @"账户一次性充值600元 , 就可以享受一年内免费洗车48次 ; 还可以在商城进行愉快购物哦～";
//    CGFloat titleLabelHeight = [titleLabelString boundingRectWithSize:CGSizeMake(kSizeOfScreen.width-40-18, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0]} context:nil].size.height;
//    
//    UIView* titleView = [[UIView alloc]initWithFrame:CGRectMake(20, 22, kSizeOfScreen.width-40, titleLabelHeight+5)];
//    titleView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:titleView];
    
    
//    UILabel* titleImageView = [PublicUtils labelWithFrame:CGRectMake(0, 0, 20, 20) withTitle:@"\U0000E619" titleFontSize:[UIFont fontWithName:@"icomoon" size:15.0] textColor:[UIColor colorWithRed:244/255.0 green:167/255.0 blue:64/255.0 alpha:1] backgroundColor:[UIColor whiteColor] alignment:0 hidden:NO];
//    [titleView addSubview:titleImageView];
//    UILabel* titleLabel = [PublicUtils labelWithFrame:CGRectMake(CGRectGetMaxX(titleImageView.frame)+3, 2, titleView.frame.size.width-18, titleLabelHeight) withTitle:titleLabelString titleFontSize:[UIFont systemFontOfSize:12.0] textColor:[UIColor grayColor] backgroundColor:nil alignment:0 hidden:NO];
//    titleLabel.numberOfLines = 0;
//    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    //调整行间距
//    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc]initWithString:titleLabelString];
//    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    [paragraphStyle setLineSpacing:5.0];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [titleLabelString length])];
//    titleLabel.attributedText = attributedString;
//    [titleView addSubview:titleLabel];
//    [titleLabel sizeToFit];
    
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
    UIButton* view1Button = [UIButton buttonWithType:UIButtonTypeCustom];
    view1Button.frame = view1.frame;
    view1Button.selected = YES;
    selectedPay = @"alipay";
    [view1Button setTitle:@"alipay" forState:UIControlStateNormal];
    [view1Button setImage:[UIImage imageNamed:@"mycar_noclick"] forState:UIControlStateNormal];
    [view1Button setImage:[UIImage imageNamed:@"mycar_click"] forState:UIControlStateSelected];
    [view1Button setImageEdgeInsets:UIEdgeInsetsMake(0, view1.frame.size.width-36, 0, 0)];
    [view1Button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -100, 0)];
    [view1Button addTarget:self action:@selector(payButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    view1Button.tag = 201;
    [self.view addSubview:view1Button];
    
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
        
        UIButton* view2Button = [UIButton buttonWithType:UIButtonTypeCustom];
        view2Button.frame = view2.frame;
        [view2Button setTitle:@"wx" forState:UIControlStateNormal];
        [view2Button setImage:[UIImage imageNamed:@"mycar_noclick"] forState:UIControlStateNormal];
        [view2Button setImage:[UIImage imageNamed:@"mycar_click"] forState:UIControlStateSelected];
        [view2Button setImageEdgeInsets:UIEdgeInsetsMake(0, view2.frame.size.width-36, 0, 0)];
        [view2Button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -100, 0)];
        [view2Button addTarget:self action:@selector(payButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        view2Button.tag = 202;
        [self.view addSubview:view2Button];
    }
    
    
//    UIView* barrierLine3 = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(view1.frame)+view2.frame.size.height+1, kSizeOfScreen.width-40, 1)];
//    barrierLine3.backgroundColor = [UIColor colorWithRed:0.961f green:0.961f blue:0.961f alpha:1.00f];
//    [self.view addSubview:barrierLine3];
//    
//    UIView* view3 = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(barrierLine3.frame)+1, barrierLine3.frame.size.width, 47)];
//    view3.backgroundColor = [UIColor clearColor];
//    
//    UIImageView* viewImg3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 31, 31)];
//    viewImg3.image = [UIImage imageNamed:@"yinlian"];
//    [view3 addSubview:viewImg3];
//    UILabel* view3ImgLabel1 = [PublicUtils labelWithFrame:CGRectMake(CGRectGetMaxX(viewImg1.frame)+8, 10, kSizeOfScreen.width, 30) withTitle:@"银联支付" titleFontSize:[UIFont systemFontOfSize:15.0] textColor:KBlackMainColor backgroundColor:nil alignment:0 hidden:NO];
//    [view3 addSubview:view3ImgLabel1];
//    [view3ImgLabel1 sizeToFit];
//    UILabel* view3ImgLabel2 = [PublicUtils labelWithFrame:CGRectMake(CGRectGetMaxX(viewImg1.frame)+8, CGRectGetMaxY(view3ImgLabel1.frame), kSizeOfScreen.width, 30) withTitle:@"支持储存卡,信用卡的使用" titleFontSize:[UIFont systemFontOfSize:12.0] textColor:[UIColor grayColor] backgroundColor:nil alignment:0 hidden:NO];
//    [view3 addSubview:view3ImgLabel2];
//    [view3ImgLabel2 sizeToFit];
//    
//    [self.view addSubview:view3];
//    
//    UIButton* view3Button = [UIButton buttonWithType:UIButtonTypeCustom];
//    view3Button.frame = view3.frame;
//    [view3Button setTitle:@"upacp" forState:UIControlStateNormal];
//    [view3Button setImage:[UIImage imageNamed:@"mycar_noclick"] forState:UIControlStateNormal];
//    [view3Button setImage:[UIImage imageNamed:@"mycar_click"] forState:UIControlStateSelected];
//    [view3Button setImageEdgeInsets:UIEdgeInsetsMake(0, view3.frame.size.width-36, 0, 0)];
//    [view3Button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -100, 0)];
//    [view3Button addTarget:self action:@selector(payButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    view3Button.tag = 203;
//    [self.view addSubview:view3Button];
    
    //    UIView* barrierLine4 = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(view3.frame)+10, kSizeOfScreen.width-40, 1)];
    //    barrierLine4.backgroundColor = [UIColor colorWithRed:0.961f green:0.961f blue:0.961f alpha:1.00f];
    //    [self.view addSubview:barrierLine4];
    
    UILabel* label2 = [PublicUtils labelWithFrame:CGRectMake(20, CGRectGetMaxY(view1.frame)+view2.frame.size.height+7, kSizeOfScreen.width, 30) withTitle:@"请选择充值金额" titleFontSize:[UIFont systemFontOfSize:15.0] textColor:KBlackMainColor backgroundColor:nil alignment:0 hidden:NO];
    [self.view addSubview:label2];
    [label2 sizeToFit];
    
    
    NSArray* purchaseButtonTitles = @[@"100元",@"300元",@"600元",@"1000元"];
    CGFloat eachButtonWidth = (kSizeOfScreen.width - ((purchaseButtonTitles.count-1) * 10 + 40)) / purchaseButtonTitles.count;
    for(int i=0; i<purchaseButtonTitles.count; i++){
        UIButton* purchaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        purchaseButton.frame = CGRectMake(20 + i*(eachButtonWidth+10), CGRectGetMaxY(label2.frame)+15, eachButtonWidth, 30);
        purchaseButton.tag = 211 + i;
        
        purchaseButton.layer.borderColor = [UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1.00f].CGColor;
        purchaseButton.layer.borderWidth = 1.0;
        purchaseButton.layer.cornerRadius = 2;
        purchaseButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [purchaseButton setTitle:purchaseButtonTitles[i] forState:UIControlStateNormal];
        [purchaseButton setTitleColor:KBlueColor forState:UIControlStateNormal];
        [purchaseButton addTarget:self action:@selector(purchaseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [purchaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self.view addSubview:purchaseButton];
        purchaseButton.selected = ((i==2) ? YES : NO);
        if(purchaseButton.selected){
            [purchaseButton setBackgroundColor:KBlueColor];
            price = purchaseButton.titleLabel.text;
        }
    }
    
    UIButton* comfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    comfirmButton.frame = CGRectMake(0, CGRectGetMaxY(label2.frame)+77, kSizeOfScreen.width, 38);
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
    selectedPay = sender.titleLabel.text;
    NSLog(@"%@",sender.titleLabel.text);
}

/**付款金额按钮回调*/
-(void)purchaseButtonClicked:(UIButton*)sender{
    for(int i=0; i<NUM_PURCHASE; i++){
        UIButton* button = (UIButton*)[self.view viewWithTag:211 + i];
        [button setBackgroundColor:[UIColor clearColor]];
        button.selected = NO;
    }
    sender.selected = YES;
    [sender setBackgroundColor:KBlueColor];
    price = sender.titleLabel.text;
}

/**确认回调*/
-(void)comfirmButtonClicked:(UIButton*)sender{
    MyLog(@"支付方式:%@-PINGPP:%@-支付金额:%@",selectedPay,selectedPay,price);
//    if([selectedPay isEqualToString:@"微信"]){
//        WXPay* thyWeiXinPay = [WXPay shareInstance];
//        thyWeiXinPay.isSuccess = NO;
//        [self getWeiXinOrderWithPrice:price];
//    }
//    if([selectedPay isEqualToString:@"支付宝"]){
//        [self getOrderIdWithPrice:price];
//    }
    

/*
    以下是新版支付方式
 */
    NSDictionary* paramDict = @{
                                @"uid":KUserManager.uid,
                                @"mobile":KUserManager.mobile,
                                @"appid":@"app_j5qbP4Dib5uHTe5C",
                                @"amount":[NSString stringWithFormat:@"%d",(int)([[[price componentsSeparatedByString:@"元"] firstObject] floatValue]*100)],  //1分钱充值
                                @"channel":selectedPay,
                                @"currency":@"cny",
                                @"subject":[NSString stringWithFormat:@"车生活%@充值",price],
                                @"body":[NSString stringWithFormat:@"车生活%@元充值",price],
                                @"red":@"0",
                                @"money":@"0",
                                @"order_sn":[NSString stringWithFormat:@""],
                                @"store_id":@"2",
                                @"goods_id":@"1",
                                @"price":[NSString stringWithFormat:@"%d",(int)([[[price componentsSeparatedByString:@"元"] firstObject] floatValue]*100)]
                                };
    
    MyLog(@"-------------生成充值订单的参数-------------%@",paramDict);
    [MBProgressHUD showMessag:@"订单提交中..." toView:self.view];
    [ModelTool getPayOrderCreateWithParameter:paramDict andSuccess:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSDictionary* rootDict = [NSDictionary dictionaryWithDictionary:object];
            MyLog(@"----------充值返回信息-----------%@",[PublicUtils showServiceReturnMessage:rootDict[@"message"]]);
            MyLog(@"----------充值返回信息-----------%@",rootDict);
            if([rootDict[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]){
                
                if([selectedPay isEqualToString:@"wx"]){
                    //使用微信支付
                    WXPay* thyWeiXinPay = [WXPay shareInstance];
                    thyWeiXinPay.isSuccess = NO;
//                    [self WXPayWithPrepayId:rootDict[@"data"][@"order_sn"]];
                    [self WXPayWithParamDict:rootDict[@"data"]];
                }else{
                    //使用支付宝支付
                    [self AlipayWithPrice:price andOrderNum:rootDict[@"data"][@"out_trade_no"]];
                }
            }else{
                [self alert:@"温馨提示" msg:[PublicUtils showServiceReturnMessage:rootDict[@"message"]]];
            }
        });
    } andFail:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self alert:@"温馨提示" msg:@"网络出错,请重新加载"];
    }];
    
/*
    以下是PINGPP支付方式
 */
//    NSDictionary* paramDict = @{
//                                @"uid":KUserManager.uid,
//                                @"mobile":KUserManager.mobile,
//                                @"appid":@"app_j5qbP4Dib5uHTe5C",
//                                @"amount":[NSString stringWithFormat:@"%d",(int)(0.01*100)],  //1分钱充值
//                                @"channel":selectedPay,
//                                @"currency":@"cny",
//                                @"subject":[NSString stringWithFormat:@"车生活%.2f元充值",0.01],
//                                @"body":[NSString stringWithFormat:@"车生活%.2f元充值",0.01],
//                                @"red":@"0",
//                                @"money":@"0",
//                                @"order_sn":[NSString stringWithFormat:@""],
//                                @"store_id":@"2",
//                                @"goods_id":@"1",
//                                @"price":[NSString stringWithFormat:@"%d",(int)(0.01*100)]
//                                };
//    MyLog(@"-------------生成充值订单的参数-------------%@",paramDict);
//    [MBProgressHUD showMessag:@"订单提交中..." toView:self.view];
//    [ModelTool getPayOrderCreateWithParameter:paramDict andSuccess:^(id object) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            NSDictionary* rootDict = [NSDictionary dictionaryWithDictionary:object];
//            MyLog(@"----------充值返回信息-----------%@",[PublicUtils showServiceReturnMessage:rootDict[@"message"]]);
//            MyLog(@"----------充值返回信息-----------%@",object);
//            if([rootDict[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]){
//                //调用支付控件
//                if([selectedPay isEqualToString:@"wx"]){
//                    if([WXApi isWXAppInstalled]){
//                        
//                        [Pingpp createPayment:rootDict[@"data"][@"charge"] appURLScheme:@"wx75b0585936937e4a" withCompletion:^(NSString *result, PingppError *error) {
//                            if([result isEqualToString:@"success"]){
//                                //支付成功
//                                [MBProgressHUD showSuccess:@"交易成功!" toView:self.view];
//                                [self.navigationController popViewControllerAnimated:YES];
//                            }else{
//                                [MBProgressHUD showError:[error getMsg] toView:self.view];
//                            }
//                        }];
//                    
//                    }else{
//                        [WCAlertView showAlertWithTitle:@"温馨提示" message:@"您还没有安装微信客户端哦" customizationBlock:nil completionBlock:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//                    }
//                }else{
//                    
//                    [Pingpp createPayment:rootDict[@"data"][@"charge"] appURLScheme:@"MyPayUrlScheme" withCompletion:^(NSString *result, PingppError *error) {
//                        if([result isEqualToString:@"success"]){
//                            //支付成功
//                            [MBProgressHUD showSuccess:@"交易成功!" toView:self.view];
//                            [self.navigationController popViewControllerAnimated:YES];
//                        }else{
//                            [MBProgressHUD showError:[error getMsg] toView:self.view];
//                        }
//                    }];
//                    
//                }
//            }
//        });
//    } andFail:^(NSError *err) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        [WCAlertView showAlertWithTitle:@"提示" message:@"网络出错,请重新加载" customizationBlock:nil completionBlock:nil cancelButtonTitle:@"" otherButtonTitles:nil, nil];
//    }];
}



#pragma mark --== 支付 ==--
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
        [self alert:@"温馨提示" msg:@"支付完成!"];
        [self.navigationController popViewControllerAnimated:YES];
        //  [self checkLoginOrNo];
    }];
}

/**支付宝支付*/
-(void)AlipayWithPrice:(NSString*)thyPrice andOrderNum:(NSString*)thyOrderNum{
    [[WQPay shareInstance]payProductArray:thyPrice AndOrderID:thyOrderNum];
    [[WQPay shareInstance] setPaySucc:^{
        [self alert:@"提示" msg:@"支付完成!"];
        [self.navigationController popViewControllerAnimated:YES];
        //  [self checkLoginOrNo];
    }];
}


///**微信支付完成回调*/
//-(void)onResp:(BaseResp *)resp{
//    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
//    NSString *strTitle;
//    
//    if([resp isKindOfClass:[SendMessageToWXResp class]])
//    {
//        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
//    }
//    WXPay* thyWxPay = [WXPay shareInstance];
//    if([resp isKindOfClass:[PayResp class]]){
//        //支付返回结果，实际支付结果需要去微信服务器端查询
//        strTitle = [NSString stringWithFormat:@"支付结果"];
//        
//        switch (resp.errCode) {
//            case WXSuccess:
//                strMsg = @"支付成功！";
//                MyLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//                if(!thyWxPay.isSuccess){
//                    thyWxPay.paySucc();
//                    thyWxPay.isSuccess = YES;
//                }
//                break;
//                
//            default:
//                if(resp.errCode == (-2)){
//                    strMsg = @"您已取消付款";
//                    [WQAler Show:strMsg WithView:[[UIApplication sharedApplication].delegate window] ];
//                }else{
//                    strMsg = @"支付失败！";
//                    [WQAler Show:strMsg WithView:[[UIApplication sharedApplication].delegate window] ];
//                }
//                
//                MyLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
//                break;
//        }
//    }
//}



///**微信支付*/
//-(void)WXPayWithPrepayId:(NSString*)thyPrepayId{
//    if([WXApi isWXAppInstalled]){
//        NSString    *package, *time_stamp, *nonce_str;
//        //设置支付参数
//        time_t now;
//        time(&now);
//        time_stamp  = [NSString stringWithFormat:@"%ld", now];
//        nonce_str	= [WXUtil md5:time_stamp];
//        package         = @"Sign=WXPay";
//        NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
//        [signParams setObject: APP_ID        forKey:@"appid"];
//        [signParams setObject: nonce_str    forKey:@"noncestr"];
//        [signParams setObject: package  forKey:@"package"];
//        [signParams setObject: MCH_ID        forKey:@"partnerid"];
//        [signParams setObject: time_stamp   forKey:@"timestamp"];
//        [signParams setObject: thyPrepayId     forKey:@"prepayid"];
//
//        //生成签名
//        NSString *sign  = [self createMd5Sign:signParams];
//        
//        //添加签名
//        [signParams setObject: sign   forKey:@"sign"];
//        
//        //调用微信支付
//        PayReq* req = [[PayReq alloc]init];
//        req.openID              = APP_ID;
//        req.partnerId           = MCH_ID;
//        req.prepayId            = thyPrepayId;
//        req.nonceStr            = signParams[@"noncestr"];
//        req.timeStamp           = [signParams[@"timestamp"] intValue]; //要十位数
//        req.package             = signParams[@"package"];
//        req.sign                = signParams[@"sign"];
//        [WXApi sendReq:req];
//        
//    }else{
//        [self alert:@"温馨提示" msg:@"您还没有安装微信客户端哦"];
//    }
//    
//    [[WXPay shareInstance]setPaySucc:^{
//        [self alert:@"温馨提示" msg:@"支付完成!"];
//        [self.navigationController popViewControllerAnimated:YES];
//      //  [self checkLoginOrNo];
//    }];
//}




///**获取支付宝订单编号*/
//-(void)getOrderIdWithPrice:(NSString*)thyPrice{
//    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
//    float getPrice = [[[thyPrice componentsSeparatedByString:@"元"] firstObject] floatValue];
//    NSString*nameDescri = [[NSString stringWithFormat:@"车生活%d元充值",(int)getPrice] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary* payParamDict = @{@"uid":KUserManager.uid,@"total_fee":[NSString stringWithFormat:@"%.2f",getPrice],@"key":KUserManager.key,@"quantity":@"1",@"price":[NSString stringWithFormat:@"%.2f",getPrice],@"subject":nameDescri,@"body":nameDescri,@"payment_type":@"1"};
//    [ModelTool httpAppGainPgyOrderWithParameter:payParamDict success:^(id object) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            MyLog(@"%@",object);
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
//                [self AlipayWithPrice:thyPrice andOrderNum:[NSString stringWithFormat:@"%@",object[@"data"][@"out_trade_no"]]];
//            }else{
//                [self alert:@"提示" msg:object[@"data"][@"msg"]];
//            }
//        });
//    } faile:^(NSError *err) {
//        MyLog(@"%@",err);
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    }];
//}

///**微信获取订单*/
//-(void)getWeiXinOrderWithPrice:(NSString*)thyPrice{
//    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
//    float getPrice = [[[thyPrice componentsSeparatedByString:@"元"] firstObject] floatValue] * 100;
//    NSString*nameDescri = [[NSString stringWithFormat:@"车生活%@充值",thyPrice] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary* payParamDict = @{@"uid":KUserManager.uid,@"total_fee":[NSString stringWithFormat:@"%d",(int)getPrice],@"key":KUserManager.key,@"spbill_create_ip":@"127.0.0.1",@"body":nameDescri,@"product_id":@"1522456645"};
//    [ModelTool httpAppGainWeiXinOrderWithParameter:payParamDict success:^(id object) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            MyLog(@"%@",object);
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
//                [self WXPayWithPrepayId:object[@"data"][@"prepay_id"]];
//            }else{
//                [self alert:@"提示" msg:object[@"data"][@"msg"]];
//            }
//        });
//    } faile:^(NSError *err) {
//        MyLog(@"%@",err);
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    }];
//}

//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alter show];
}

#pragma mark - 获取用户数据
//-(void)checkLoginOrNo
//{
//    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
//    [ModelTool httpAppGainNewLoginWithParameter:@{@"uid":KUserManager.uid,@"key":KUserManager.key} success:^(id object) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
//                NSDictionary*dic=object[@"data"];
//                NSMutableDictionary*dicMsg=[NSMutableDictionary dictionaryWithDictionary:dic];
//                NSDictionary*dic1=dicMsg[@"car"];
//                NSMutableDictionary*carMsgDic=[NSMutableDictionary dictionaryWithDictionary:dic1];
//                [carMsgDic setObject:[Utils checkNSNullWithgetString:carMsgDic[@"isDefault"]] forKey:@"isDefault"];
//                [dicMsg setObject:carMsgDic forKey:@"car"];
//                UserNew* lUser = [[UserNew alloc] initWithDic:dic];
//                KUserManager = lUser;
//                NSUserDefaults*user=[[NSUserDefaults alloc]init];
//                [user setObject:dicMsg forKey:@"user"];
//                [NSUserDefaults resetStandardUserDefaults];
//                
////            [self.remainMoneyVc loadData];
//            }
//        });
//    } faile:^(NSError *err) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        
//    }];
//}

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

}
@end
