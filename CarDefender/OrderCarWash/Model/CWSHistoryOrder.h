//
//  CWSHistoryOrder.h
//  CarDefender
//
//  Created by 周子涵 on 15/10/12.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWSHistoryOrder : NSObject

#if USENEWVERSION
@property (strong, nonatomic) NSString* add_time;       //订单添加时间
@property (strong, nonatomic) NSString* amount_paid;          
@property (strong, nonatomic) NSString* buyer_email;          //买家email
@property (strong, nonatomic) NSString* cate_id_2;             //用于判断是什么类别 30是普洗 31是精洗 23 美容 25养护
@property (strong, nonatomic) NSString* classification_name;   //分类名字
@property (strong, nonatomic) NSString* evaluation_time;       //评论时间
@property (strong, nonatomic) NSString* finished_time;          //订单完成时间
@property (strong, nonatomic) NSString* goods_name;             //商品名
@property (strong, nonatomic) NSString* orderId;     //订单ID
@property (strong, nonatomic) NSString* order_sn;      //订单号
@property (strong, nonatomic) NSString* pay_time;      //支付时间
@property (strong, nonatomic) NSString*price;        
@property (strong, nonatomic) NSString* seller_id;       //商家ID
@property (strong, nonatomic) NSString* seller_name;       //商家名称
@property (strong, nonatomic) NSString* service_time;      //服务时间
@property (nonatomic,copy) NSString *status;             //状态
@property (nonatomic,copy) NSString *type;

-(instancetype)initWithDic:(NSDictionary*)dic;

#else
@property (strong, nonatomic) NSString* orderId;       //ID
@property (strong, nonatomic) NSString* img;          //图片
@property (strong, nonatomic) NSString* name;          //名称
@property (strong, nonatomic) NSString* uno;          //订单号
@property (strong, nonatomic) NSString* plate;     //车牌号
@property (strong, nonatomic) NSString* date;      //预约时间
@property (strong, nonatomic) NSString* deal;       //失效时间
@property (strong, nonatomic) NSString* status;       //状态

-(instancetype)initWithDic:(NSDictionary*)dic;

#endif


@end
