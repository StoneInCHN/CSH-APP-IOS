//
//  WQPay.m
//  chlidfios
//
//  Created by ZG-YUH on 15/7/31.
//  Copyright (c) 2015年 yuhuan. All rights reserved.
//

#import "WQPay.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"
#import <UIKit/UIKit.h>
#import "WQAler.h"
#import "AppDelegate.h"


static WQPay * wqPay;
@implementation WQPay
+(WQPay *) shareInstance{
    if (!wqPay) {
        wqPay=[[WQPay alloc] init];
    }
    return wqPay;
}
#pragma -mark  支付宝
-(void)payProductArray:(NSString *)thyPrice AndOrderID:(NSString *)order_code{
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    //    Product *product = [[Product alloc]init];
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088021552530780";//16位商户ID号
    NSString *seller = @"chcws@chcws.com";//收款账户支付宝号
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAL4Lx8cgCyPVKxjdr3IBch3JG+/AreSbjhLqN0pM4HlPEkQGmoihzptSVe+o1ywALgkul/1e5fUljqAGAbtyhmxk9dRs3QddKposOzStoX9ReTWmMJPtC5cNXbclg7QbYKrzw25sUkxGHMP9KInZV7qAnhwFg5TDmk87Lab5JrmPAgMBAAECgYBJ0uWuEmKBbuMo66Slkq4zp9W0UpK6RTrxWg5UTHy+YtrjlfUdsk1BxMAhMuMy8nbvlivwfpaxnf9DZlHx8NEKSY+vpj/jZyir1Nscf9Dya7ak5EgvBPBE/5KtJqpx7WD1qJjAoaumTh0ljy9B5G88RcLFNA2U27NjchCO9SjmIQJBAPn/g8omfRGHJoBJHXsIBYripnCld7J1V/Ekyjb8r4rQtH8bS/NK30CR1ToPD0gjcEDTgYkLkONqUUmJ9EWBwOcCQQDCm80BkFTt0TxjxqLSpyEJcsZdp7dHFVUDaHEci/WVVwldcaPdw9THkHybB3KvwzIVzuClq2QYvRptZ+qN6qUZAkA+sHYp0PD33j4nWS5NVbueEivOf4++bnJ5A9K5ay/RzXgVj5DCF3pYRLmFb5VTb5+Mgf0vknjorhZoLHHWpCztAkEAosXuEwDGCKSZ/lqGlet0lpKJmIxPoAUXtmIFOftWzjKegqoqhbLmpoUTtBfmtVxu6A7Bl9BjSM3i7N+eMFWzAQJAIfUnYgTQ8RKBZ0gkK98FuGcsYU6aPvKzyGaPeczKdsp4xZgEdlppCzwxn/Kd9kKRrL2PKkgBzQ5Vaygvu8dqNg==";//key值
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = order_code; //订单ID（由商家自行制定）
    order.productName = @"车卫士"; //商品标题
    order.productDescription = @"充值"; //商品描述
    float price=[[[thyPrice componentsSeparatedByString:@"元"] firstObject] floatValue];
    order.amount = [NSString stringWithFormat:@"%.2f",price]; //商品价格
//    order.amount =@"0.01"; //商品价格
    

    order.notifyURL =  @"http://jfinal.chcws.com/notify/pay/notify_alipay"; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
//    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"MyPayUrlScheme";
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            UIWindow *mywindow = [UIApplication sharedApplication].keyWindow;
            for (UIView *subview in mywindow.subviews) {
                subview.frame = mywindow.bounds;
            }

            NSLog(@"reslut = %@",resultDic);
            if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
                
                [WQAler Show:@"您已取消付款" WithView:[[UIApplication sharedApplication].delegate window] ];
            }else if([resultDic[@"resultStatus"] isEqualToString:@"9000"]){
                //支付成功
                self.paySucc();
            }else if([resultDic[@"resultStatus"] isEqualToString:@"8000"]){
                [WQAler Show:@"订单处理中" WithView:[[UIApplication sharedApplication].delegate window] ];

            }else if([resultDic[@"resultStatus"] isEqualToString:@"4000"]){
                [WQAler Show:@"支付失败" WithView:[[UIApplication sharedApplication].delegate window] ];

            }else if([resultDic[@"resultStatus"] isEqualToString:@"6002"]){
                [WQAler Show:@"网络连接出错" WithView:[[UIApplication sharedApplication].delegate window] ];
            }
        }];
    }
    
}

@end
