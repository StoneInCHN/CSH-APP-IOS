//
//  UserNew.h
//  CarDefender
//
//  Created by 李散 on 15/6/3.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserAccountNew.h"
#import "UserScoreNew.h"
#import "UserDefaultCarNew.h"
@interface UserNew : NSObject

#pragma mark -===================================新版属性

#if USENEWVERSION
/**用户编号*/
@property (nonatomic,copy) NSString* uid;

/**电话号码*/
@property (nonatomic,copy) NSString* mobile;

/**签名*/
@property (nonatomic,copy) NSString* signature;

/**昵称*/
@property (nonatomic,copy) NSString* nick_name;

/**头像*/
@property (nonatomic,copy) NSString* icon;

/**电子邮箱*/
@property (nonatomic,copy) NSString* email;

/**QQ号码*/
@property (nonatomic,copy) NSString* qq;

/**性别*/
@property (nonatomic,copy) NSString* sex;

/**出生年月*/
@property (nonatomic,copy) NSString* birth_date;

/**身份证*/
@property (nonatomic,copy) NSString* identity_card;

/**驾驶证*/
@property (nonatomic,copy) NSString* driver_license;

/**用户cid*/
@property (nonatomic,copy) NSString* userCID;

/**用户标签*/
@property (nonatomic,strong) NSSet* userTags;



@property (strong, nonatomic) NSString* key;//app接口验证key
@property (strong, nonatomic) NSString* no;//环信账号
@property (strong, nonatomic) NSString* nick;//昵称
@property (strong, nonatomic) NSString* photo;//头像
@property (assign, nonatomic) BOOL isPush;//是否推送
@property (strong, nonatomic) NSString* note;//签名（新添加）
@property (strong, nonatomic) NSString* sign;//是否签到
@property (strong, nonatomic) NSString* msg;//消息中心条数
@property (assign, nonatomic) BOOL type;//1-隐藏金额 0-显示金额


@property (strong, nonatomic) UserAccountNew* account;//账户信息
@property (strong, nonatomic) UserScoreNew* score;//账户信息
@property (strong, nonatomic) UserDefaultCarNew* car;//当前默认车辆信息

@property (nonatomic,strong)  NSMutableArray*      defaultStoreArray; //默认车店
@property (strong, nonatomic) NSMutableArray          *carArray;//所有车辆
@property (nonatomic,strong)  NSMutableArray*      advertisementInfoArray; //广告信息(设置为字典用于排序)
@property (nonatomic,strong)  NSMutableDictionary* userDefaultVehicle; //默认车辆
@property (nonatomic,strong)  NSMutableDictionary* userWalletInfo;  //用户钱包信息
@property (nonatomic,copy)    NSString* baseUrl; //IP地址

@property (strong, nonatomic) NSString* currentCity;
@property (assign, nonatomic) CLLocationCoordinate2D currentPt;

#else
@property (strong, nonatomic) NSString* key;//app接口验证key
@property (strong, nonatomic) NSString* uid;//用户ID
@property (strong, nonatomic) NSString* no;//环信账号
@property (strong, nonatomic) NSString* tel;//电话
@property (strong, nonatomic) NSString* nick;//昵称
@property (strong, nonatomic) NSString* photo;//头像
@property (assign, nonatomic) BOOL isPush;//是否推送
@property (strong, nonatomic) NSString* note;//签名（新添加）
@property (strong, nonatomic) NSString* sign;//是否签到
@property (strong, nonatomic) NSString* msg;//消息中心条数
@property (assign, nonatomic) BOOL type;//1-隐藏金额 0-显示金额


@property (strong, nonatomic) UserAccountNew* account;//账户信息
@property (strong, nonatomic) UserScoreNew* score;//账户信息
@property (strong, nonatomic) UserDefaultCarNew* car;//账户信息
@property (strong, nonatomic) NSArray          *carArray;//所有车辆


@property (strong, nonatomic) NSString* currentCity;
@property (assign, nonatomic) CLLocationCoordinate2D currentPt;

#endif





-(instancetype)initWithDic:(NSDictionary*)lDic;
@end
