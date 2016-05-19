//
//  CWSCarWashDiscountModel.h
//  CarDefender
//
//  Created by 王泰莅 on 15/12/10.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWSCarWashDiscountModel : NSObject

/**商品名称*/
@property (nonatomic,copy)  NSString* productName;

/**是否可用红包*/
@property (nonatomic,assign)  BOOL isRedPackageUseable;

/**是否有优惠价*/
@property (nonatomic,assign) BOOL  isDiscount;

/**优惠价*/
@property (nonatomic,copy)  NSString* discountPrice;

/**原价*/
@property (nonatomic,copy)  NSString* originalPrice;

/**商品附加信息*/
@property (nonatomic,copy)  NSString* productDetailName;


/**商品ID*/
@property (nonatomic,assign)  NSInteger productID;

/**商家ID*/
@property (nonatomic,assign)  NSInteger merchantsID;

/**商家名*/
@property (nonatomic,strong)  NSString *merchantsName;

/**商品类别编号*/
@property (nonatomic,copy)  NSString* cateId;

-(instancetype)initWithDic:(NSDictionary*)lDic;
@end
