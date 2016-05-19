//
//  UserDefaultStoreNew.h
//  CarDefender
//
//  Created by 王泰莅 on 15/12/28.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultStoreNew : NSObject

/**地址*/
@property (nonatomic,copy) NSString* address;

/**优惠价*/
@property (nonatomic,copy) NSString* discountPrice;

/**距离*/
@property (nonatomic,copy) NSString* distance;

/**ID*/
@property (nonatomic,copy) NSString* storeId;

/**是否有折后价*/
@property (nonatomic,assign) BOOL isDiscountPrice;

/**价格*/
@property (nonatomic,copy) NSString* price;

/**店名*/
@property (nonatomic,copy) NSString* storeName;

@end
