//
//  MyOrderDetailModel.h
//  CarDefender
//
//  Created by 万茜 on 15/12/31.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderDetailModel : NSObject
@property (nonatomic,strong)NSString *add_time;
@property (nonatomic,strong)NSString *address;
@property (nonatomic,strong)NSString *effective_time;
@property (nonatomic,strong)NSString *finished_time;
@property (nonatomic,strong)NSString *goodsName;
@property (nonatomic,strong)NSString *im_lat;
@property (nonatomic,strong)NSString *im_lng;
@property (nonatomic,strong)NSString *mobile;
@property (nonatomic,strong)NSArray *orderGoodsList;
@property (nonatomic,strong)NSString *orderId;
@property (nonatomic,strong)NSString *order_sn;
@property (nonatomic,strong)NSString *owner_name;
@property (nonatomic,strong)NSString *reputation;//好评
@property (nonatomic,strong)NSString *service_time;
@property (nonatomic,strong)NSString *store_name;
@property (nonatomic,assign)NSInteger status;
@property (nonatomic,strong)NSString *image_1;
@property (nonatomic,strong)NSString *barcodes;//二维码生成字符串

-(instancetype)initWithDic:(NSDictionary*)lDic;
@end
