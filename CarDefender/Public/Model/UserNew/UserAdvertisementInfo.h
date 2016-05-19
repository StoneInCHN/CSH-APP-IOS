//
//  UserAdvertisementInfo.h
//  CarDefender
//
//  Created by 王泰莅 on 15/12/28.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAdvertisementInfo : NSObject

/**图片内容链接*/
@property (nonatomic,copy) NSString *advContentLink;
/**图片地址*/
@property (nonatomic,copy) NSString* advImageUrl;
/**广告id*/
@property (nonatomic,copy) NSString* apId;


-(instancetype)initWithDict:(NSDictionary*)thyDataDict;
@end
