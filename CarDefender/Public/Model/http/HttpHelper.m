//
//  HttpHelper.m
//  CarDefender
//
//  Created by sicnu_ifox on 16/5/4.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "HttpHelper.h"
#import "AFHTTPRequestOperationManager.h"

#define KHTTPHELPER_REGISTER_VERIFY_URL @"/csh-interface/endUser/reg.jhtml"//验证验证码
#define KHTTPHELPER_VERIFYCODE_REGISTER_URL @"/csh-interface/endUser/getSmsToken.jhtml"//获取注册验证码
#define KHTTPHELPER_REGISTER_URL @"/csh-interface/endUser/reg.jhtml"//注册
#define KHTTPHELPER_LOGIN_URL @"/csh-interface/endUser/login.jhtml" //登陆
#define KHTTPHELPER_LOGOUT_URL @"/csh-interface/endUser/logout.jhtml"   //退出登录
#define KHTTPHELPER_VERIFYCODE_MODIFYPW_URL @"/csh-interface/endUser/resetPwd.jhtml" //获取修改密码验证码
#define KHTTPHELPER_MODIFY_PASSWD_URL @"/csh-interface/endUser/resetPwd.jhtml" //修改密码
#define KHTTPHELPER_CHANGE_USERINFO_URL @"/csh-interface/endUser/editUserInfo.jhtml" //更改用户信息(不包括用户头像)
#define KHTTPHELPER_RENTER_LIST_URL @"/csh-interface/tenantInfo/list.jhtml" //按服务类别（洗车，紧急救援）搜寻租户列表
#define KHTTPHELPER_MY_WALLET_URL @"/csh-interface/balance/myWallet.jhtml" //我的钱包
#define KHTTPHELPER_MONEY_OR_REDPACKET_URL @"/csh-interface/balance/walletRecordByType.jhtml" //我的钱包--余额，红包，积分
#define KHTTPHELPER_AD_LIST @"/csh-interface/advertisement/getAdvImage.jhtml" // 用户广告列表
#define KHTTPHELPER_MESSAGE_LIST @"/csh-interface/message/getMsgList.jhtml" //用户获取消息列表
#define KHTTPHELPER_MESSAGE_STATE @"/csh-interface/message/readMessage.jhtml" //用户读取消息(用于修改消息是状态，从未读标记为已读)
#define KHTTPHELPER_DELETE_MESSAGE @"/csh-interface/message/deleteMsgs.jhtml" //用户删除消息
#define KHTTPHELPER_VIOLATION_RECORD_URL @"/csh-interface/illegalRecord/getIllegalRecords.jhtml" //车辆违章记录查询
#define KHTTPHELPER_FEEDBACK_URL @"/csh-interface/feedback/add.jhtml" //意见反馈
#define KHTTPHELPER_ONEKEEDETECTION_URL @"/csh-interface/obd/oneKeyDetection.jhtml" //一键检测
#define KHTTPHELPER_MY_CAR_LIST_URL @"/csh-interface/vehicle/list.jhtml" //用户我的车辆列表
#define KHTTPHELPER_AROUND_SEARCH_URL @"/csh-interface/aroundSearch/keyWordSearch.jhtml" //周边加油站
#define KHTTPHELPER_CAR_TREND_URL @"/csh-interface/obd/vehicleTrends.jhtml" //车辆动态
#define KHTTPHELPER_INIT_JPUSH_URL @"/csh-interface/jpush/setRegId.jhtml" //初始化极光推送

#define KHTTPHELPER_UPDATE_LOGIN_CACHE_INFO_URL @"/csh-interface/endUser/updateLoginCacheInfo.jhtml" //更新用户登陆缓存信息

#define KHTTPHELPER_VEHICLEBRAND_SEARCH_URL @"/csh-interface/vehicle/getVehicleBrandByCode.jhtml" //车辆品牌查询
#define KHTTPHELPER_VEHICLELIST_SEARCH_URL @"/csh-interface/vehicle/list.jhtml" //车辆列表
#define KHTTPHELPER_VEHICLEADD_SEARCH_URL @"/csh-interface/vehicle/add.jhtml" //添加车辆
#define KHTTPHELPER_VEHICLEEDIT_SEARCH_URL @"/csh-interface/vehicle/edit.jhtml" //编辑车辆
#define KHTTPHELPER_VEHICLEBYBRAND_SEARCH_URL @"/csh-interface/vehicle/getVehicleLineByBrand.jhtml"//根据车辆品牌查询车系
#define KHTTPHELPER_VEHICLEBYDETAILBRAND_SEARCH_URL @"/csh-interface/vehicle/getVehicleBrandDetailByLine.jhtml"//根据车辆车系查询车型

#define KHTTPHELPER_VEHICLEBINDDEVICE_INSERT_URL @"/csh-interface/vehicle/bindDevice.jhtml"//用户绑定车辆与设备
#define KHTTPHELPER_VEHICLESETDEFAULT_INSERT_URL @"/csh-interface/vehicle/setDefault.jhtml"//用户设置默认车辆

#define KHTTPHELPER_VEHICLESERVICEPURCHASELIST_SEARCH_URL @"/csh-interface/carService/purchaseList.jhtml"//用户购买汽车服务列表
#define KHTTPHELPER_VEHICLESERVICERECORDDETAIL_SEARCH_URL @"/csh-interface/carService/recordDetail.jhtml"//用户购买汽车服务记录详情（订单详情)
#define KHTTPHELPER_TENANTEVALUATEDORATE_INSERT_URL @"/csh-interface/tenantEvaluate/doRate.jhtml"//用户对商户打分：

#define KHTTPHELPER_BINDTENANT_INSERT_URL @"/csh-interface/vehicle/bindTenant.jhtml"//手机扫描商家二维码时用户车辆与商家绑定：
#define KHTTPHELPER_SUBSCRIBESERVICE_INSERT_URL @"/csh-interface/carService/subscribeService.jhtml"//用户预约汽车服务：
#define KHTTPHELPER_PAYSTATUS_UPDATE_URL @"/csh-interface/carService/updatePayStatus.jhtml"//更新购买汽车服务记录状态
#define KHTTPHELPER_PURDEVICEPAGE_GET_URL @"/csh-interface/balance/purDevicePage.jhtml"//购买设备充值页面(返回数据库配置的设备价格)
#define KHTTPHELPER_BALANCECHAREIN_GET_URL @"/csh-interface/balance/chargeIn.jhtml"//充值获取交易凭证
#define KHTTPHELPER_PURDEVICECHARGE_GET_URL @"/csh-interface/balance/purDeviceCharge.jhtml"//购买设备充值回调

#define KHTTPHELPER_TENANT_DETAILS_URL @"/csh-interface/tenantInfo/getTenantById.jhtml"//租户详情
#define KHTTPHELPER_PAY_SERVICE_URL @"/csh-interface/carService/payService.jhtml"//租户详情


#define KHTTPHELPER_TENANT_DETAILS_URL @"/csh-interface/tenantInfo/getTenantById.jhtml"//租户详情
#define KHTTPHELPER_PAY_SERVICE_URL @"/csh-interface/carService/payService.jhtml"//支付调用

#define KHTTPHELPER_BINDTENANT_INSERT_URL @"/csh-interface/vehicle/bindTenant.jhtml"//手机扫描商家二维码时用户车辆与商家绑定
#define KHTTPHELPER_DISCOUNT_COUPON_URL @"/csh-interface/coupon/getCouponForPay.jhtml" //支付时可用优惠券列表

@implementation HttpHelper
#pragma mark 登陆
+ (void)userLoginWithUserName:(NSString *)userName
                     password:(NSString *)passwd
                  deviceToken:(NSString *)deviceToken
                      success:(void (^)(AFHTTPRequestOperation *, id))success
                      failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userName forKey:@"userName"];
    [paramDict setObject:passwd forKey:@"password"];
    [paramDict setObject:deviceToken forKey:@"imei"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SERVERADDRESS,KHTTPHELPER_LOGIN_URL];
    NSLog(@"login url :%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(operation,responseObject);
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         failure(operation,error);
     }];
}
#pragma mark 获取验证码
+ (void)getVerifyCodeWithMobileNo:(NSString *)mobileNum
                        tokenType:(NSString *)tokenType
                         sendType:(NSString *)sendType
                          success:(void (^)(AFHTTPRequestOperation *, id))success
                          failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:mobileNum forKey:@"mobileNo"];
    [paramDict setObject:tokenType forKey:@"tokenType"];
    [paramDict setObject:sendType forKey:@"sendType"];
    
    NSString *urlString =  [NSString stringWithFormat:@"%@%@",SERVERADDRESS,KHTTPHELPER_VERIFYCODE_REGISTER_URL];
    NSLog(@"get verify code url :%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(operation,responseObject);
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         failure(operation,error);
     }];
}

#pragma mark 确定验证码
+ (void)confirmVerifyCodeWithUserTel:(NSString *)userTel
                         smsToken:(NSString *)smsToken
                             options:(NSString *)options
                             success:(void (^)(AFHTTPRequestOperation *, id))success
                             failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userTel forKey:@"userName"];
    [paramDict setObject:smsToken forKey:@"smsToken"];
    
    NSString *urlString;
    if ([options isEqualToString:@"register"]) {
        urlString = [NSString stringWithFormat:@"%@%@",SERVERADDRESS,KHTTPHELPER_REGISTER_VERIFY_URL];
    } else if([options isEqualToString:@"modify password"]){
        urlString = [NSString stringWithFormat:@"%@%@",SERVERADDRESS,KHTTPHELPER_VERIFYCODE_MODIFYPW_URL];
    } else {
        urlString = @"";
    }
    NSLog(@"confirm verify code url :%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(operation,responseObject);
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         failure(operation,error);
     }];
}
#pragma mark 注册
+ (void)registerWithUserName:(NSString *)userName
                    password:(NSString *)passwd passwdConfirm:(NSString *)passwdConfirm
                      sucess:(void (^)(AFHTTPRequestOperation *, id))success
                     failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userName forKey:@"userName"];
    [paramDict setObject:passwd forKey:@"password"];
    [paramDict setObject:passwdConfirm forKey:@"password_confirm"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SERVERADDRESS,KHTTPHELPER_REGISTER_URL];
    NSLog(@"register url :%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(operation,responseObject);
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         failure(operation,error);
     }];
}

#pragma mark 修改密码
+ (void)modifyPasswordWithUserName:(NSString *)userName
                            passwd:(NSString *)passwd
                     passwdConfirm:(NSString *)passwdConfirm
                           success:(void (^)(AFHTTPRequestOperation *, id))success
                           failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:userName forKey:@"userName"];
    [parmDict setObject:passwd forKey:@"password"];
    [parmDict setObject:passwdConfirm forKey:@"password_confirm"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SERVERADDRESS,KHTTPHELPER_MODIFY_PASSWD_URL];
    NSLog(@"modify password url :%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:parmDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}

#pragma mark 更改用户信息(不包括用户头像)
+ (void)changeUserInfoWithUserId:(NSString *)userId
                           token:(NSString *)token
                        nickName:(NSString *)nicKName
                            sign:(NSString *)sign
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:userId forKey:@"userId"];
    [parmDict setObject:token forKey:@"token"];
    [parmDict setObject:nicKName forKey:@"nickName"];
    [parmDict setObject:sign forKey:@"sign"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SERVERADDRESS,KHTTPHELPER_CHANGE_USERINFO_URL];
    NSLog(@"change user info :%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:parmDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}

+ (void)searchRenterListWithServiceCategoryId:(NSString *)serviceID
                                       userId:(NSString *)userId
                                        token:(NSString *)token
                                     latitude:(NSString *)latitude
                                    longitude:(NSString *)longitude
                                     pageSize:(int)pageSize
                                   pageNumber:(int)pageNumber
                                      success:(void (^)(AFHTTPRequestOperation *, id))success
                                      failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:userId forKey:@"userId"];
    [parmDict setObject:serviceID forKey:@"serviceCategoryId"];
    [parmDict setObject:token forKey:@"token"];
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:latitude] forKey:@"latitude"];
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:longitude] forKey:@"longitude"];
    [parmDict setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    [parmDict setObject:[NSNumber numberWithInt:pageNumber] forKey:@"pageNumber"];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SERVERADDRESS,KHTTPHELPER_RENTER_LIST_URL];
    NSLog(@"search renter list :%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:parmDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
    
}
#pragma mark 我的钱包
+ (void)viewMyWalletWithUserId:(NSString *)userId
                         token:(NSString *)token
                       success:(void (^)(AFHTTPRequestOperation *, id))success
                       failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:userId forKey:@"userId"];
    [parmDict setObject:token forKey:@"token"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_MY_WALLET_URL];
    NSLog(@"my wallet url :%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:parmDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}
#pragma mark 我的钱包--余额，红包接口
+ (void)getMoneyOrRedPacketWithUserId:(NSString *)userId
                                token:(NSString *)token
                           walletType:(NSString *)walletType
                             walletId:(NSString *)walletId
                           pageNumber:(NSString *)pageNumber
                             pageSize:(NSString *)pageSize
                              success:(void (^)(AFHTTPRequestOperation *, id))success
                              failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:userId forKey:@"userId"];
    [parmDict setObject:token forKey:@"token"];
    [parmDict setObject:walletType forKey:@"walletType"];
    [parmDict setObject:walletId forKey:@"walletId"];
    [parmDict setObject:pageNumber forKey:@"pageNumber"];
    [parmDict setObject:pageSize forKey:@"pageSize"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_MONEY_OR_REDPACKET_URL];
    NSLog(@"money or redpacket url :%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:parmDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}
#pragma mark 获取广告信息
+ (void)getAdvertismentImageWithUserId:(NSString *)userId
                               token:(NSString *)token
                             success:(void (^)(AFHTTPRequestOperation *, id))success
                             failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:userId forKey:@"userId"];
    [parmDict setObject:token forKey:@"token"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_AD_LIST];
    NSLog(@"adertisment image url :%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:parmDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}
#pragma mark 获取用户消息列表
+ (void)getMessageListWithUserId:(NSString *)userId
                           token:(NSString *)token
                      pageNumber:(NSString *)pageNumber
                        pageSize:(NSString *)pageSize
                         success:(void (^)(AFHTTPRequestOperation *, id))success
                         failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:userId forKey:@"userId"];
    [parmDict setObject:token forKey:@"token"];
    [parmDict setObject:pageNumber forKey:@"pageNumber"];
    [parmDict setObject:pageSize forKey:@"pageSize"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_MESSAGE_LIST];
    NSLog(@"message list url :%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:parmDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}
#pragma mark 修改消息状态
+ (void)changeMessageStateWithUserId:(NSString *)userId
                               token:(NSString *)token
                              msgId:(NSString *)msgId
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:userId forKey:@"userId"];
    [parmDict setObject:token forKey:@"token"];
    [parmDict setObject:msgId forKey:@"msgId"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_MESSAGE_STATE];
    NSLog(@"change message state url :%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:parmDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}
#pragma mark 删除消息
+ (void)deleteMessageWithUserId:(NSString *)userId
                          token:(NSString *)token
                         msgIds:(NSArray *)msgIds
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:userId forKey:@"userId"];
    [parmDict setObject:token forKey:@"token"];
    [parmDict setObject:msgIds forKey:@"msgIds"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_DELETE_MESSAGE];
    NSLog(@"delete message  url :%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:parmDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}

#pragma mark 车辆违章记录查询
+ (void)getIllegalRecordsWithUserId:(NSString *)userId
                              token:(NSString *)token
                              plate:(NSString *)plate
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:userId forKey:@"userId"];
    [parmDict setObject:token forKey:@"token"];
    [parmDict setObject:plate forKey:@"plate"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_VIOLATION_RECORD_URL];
    NSLog(@"get illegal records url :%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:parmDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}

#pragma mark 意见反馈
+ (void)postFeedbackWithUserId:(NSString *)userId
                         token:(NSString *)token
                       content:(NSString *)content
                       success:(void (^)(AFHTTPRequestOperation *, id))success
                       failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:userId forKey:@"userId"];
    [parmDict setObject:token forKey:@"token"];
    [parmDict setObject:content forKey:@"content"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_FEEDBACK_URL];
    NSLog(@"post feedback url :%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:parmDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}

#pragma mark 退出登录
+ (void)logoutWithUserId:(NSString *)userId
                   token:(NSString *)token
                 success:(void (^)(AFHTTPRequestOperation *, id))success
                 failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:userId forKey:@"userId"];
    [parmDict setObject:token forKey:@"token"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_LOGOUT_URL];
    NSLog(@"logout url :%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:parmDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}

#pragma mark 更新登陆用户缓存信息
+ (void)updateLoginCacheInfoWithUserId:(NSString *)userId
                                 token:(NSString *)token
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:userId forKey:@"userId"];
    [parmDict setObject:token forKey:@"token"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_UPDATE_LOGIN_CACHE_INFO_URL];
    NSLog(@"update login cache info url :%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:parmDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}

#pragma mark 一键检测
+ (void)oneKeyDetectionWithUserId:(NSString *)userId
                            token:(NSString *)token
                         deviceNo:(NSString *)deviceNo
                       searchDate:(NSString *)searchDate
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:userId forKey:@"userId"];
    [parmDict setObject:token forKey:@"token"];
    [parmDict setObject:deviceNo forKey:@"deviceNo"];
    [parmDict setObject:searchDate forKey:@"searchDate"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_ONEKEEDETECTION_URL];
    NSLog(@"one key detection url :%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:parmDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}
#pragma mark 我的车辆
+ (void)myCarListWithUserId:(NSString *)userId
                      token:(NSString *)token
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:userId forKey:@"userId"];
    [parmDict setObject:token forKey:@"token"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_MY_CAR_LIST_URL];
    NSLog(@"my car url :%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:parmDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}

#pragma mark 找加油站或停车场(keyWord="加油站" or "停车场")
+ (void)searchGasolineStationWithUserId:(NSString *)userId
                                  token:(NSString *)token
                                keyWord:(NSString *)keyWord
                              longitude:(NSString *)longitude
                               latitude:(NSString *)latitude
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:userId forKey:@"userId"];
    [parmDict setObject:token forKey:@"token"];
    [parmDict setObject:keyWord forKey:@"keyWord"];
    [parmDict setObject:longitude forKey:@"longitude"];
    [parmDict setObject:latitude forKey:@"latitude"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_AROUND_SEARCH_URL];
    NSLog(@"周边加油站 url :%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:parmDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}

#pragma mark 车辆动态
+ (void)carTrendsWithUserId:(NSString *)userId
                      token:(NSString *)token
                   deviceNo:(NSString *)deviceNo
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:userId forKey:@"userId"];
    [parmDict setObject:token forKey:@"token"];
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:deviceNo] forKey:@"deviceNo"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_CAR_TREND_URL];
    NSLog(@"car trends url :%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:parmDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}

#pragma mark 初始化极光推送
+ (void)initJpushWithUserId:(NSString *)userId
                      token:(NSString *)token
                versionCode:(NSString *)versionCode
                      regId:(NSString *)regId
                appPlatform:(NSString *)appPlatform
                    success:(void (^)(AFHTTPRequestOperation *, id))success
                    failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:userId forKey:@"userId"];
    [parmDict setObject:token forKey:@"token"];
    [parmDict setObject:versionCode forKey:@"versionCode"];
    [parmDict setObject:regId forKey:@"regId"];
    [parmDict setObject:appPlatform forKey:@"appPlatform"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_INIT_JPUSH_URL];
    NSLog(@"init jpush url :%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:parmDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}

#pragma mark 车辆品牌查询
+ (void)searchVehicleBrandWithUserID:(NSString *)userId
                               token:(NSString *)token
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:userId forKey:@"userId"];
    [parmDict setObject:token forKey:@"token"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_VEHICLEBRAND_SEARCH_URL];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"adertisment image url :%@",urlString);
    [self requestWithHttpURL:urlString andParamDict:parmDict andSuccess:success andFailer:failure];
}
#pragma mark 根据车辆品牌查询车系
+ (void)searchVehicleLineByBrandWithUserID:(NSString *)userId
                                     token:(NSString *)token
                                   brankId:(NSNumber*)brankId
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:userId forKey:@"userId"];
    [parmDict setObject:token forKey:@"token"];
    [parmDict setObject:brankId forKey:@"brandId"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_VEHICLEBYBRAND_SEARCH_URL];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"adertisment image url :%@",urlString);
    [self requestWithHttpURL:urlString andParamDict:parmDict andSuccess:success andFailer:failure];
}

#pragma mark 根据车辆车系查询车型
+ (void)searchVehicleBrandDetailByLineWithUserID:(NSString *)userId
                                           token:(NSString *)token
                                         brankId:(NSNumber*)brankId
                                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:userId forKey:@"userId"];
    [parmDict setObject:token forKey:@"token"];
    [parmDict setObject:brankId forKey:@"vehicleLineId"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_VEHICLEBYDETAILBRAND_SEARCH_URL];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"adertisment image url :%@",urlString);
    [self requestWithHttpURL:urlString andParamDict:parmDict andSuccess:success andFailer:failure];
    
    
}
#pragma mark 车辆列表
+ (void)searchVehicleListWithUserID:(NSString *)userId
                              token:(NSString *)token
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:userId forKey:@"userId"];
    [parmDict setObject:token forKey:@"token"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_VEHICLELIST_SEARCH_URL];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"adertisment image url 车辆列表:%@",urlString);
    [self requestWithHttpURL:urlString andParamDict:parmDict andSuccess:success andFailer:failure];

}

#pragma mark 添加车辆
+ (void)insertVehicleAddWithUserID:(NSDictionary *)vehicleDic
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_VEHICLEADD_SEARCH_URL];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"adertisment image url 添加车辆:%@",urlString);
   [self requestWithHttpURL:urlString andParamDict:vehicleDic andSuccess:success andFailer:failure];
    
}
#pragma mark 编辑车辆
+ (void)insertVehicleEditWithUserID:(NSDictionary *)vehicleDic
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_VEHICLEEDIT_SEARCH_URL];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"adertisment image url 编辑车辆:%@",urlString);
    [self requestWithHttpURL:urlString andParamDict:vehicleDic andSuccess:success andFailer:failure];
}

#pragma mark 用户绑定车辆与设备
+ (void)insertBindDeviceWithUserDic:(NSDictionary *)vehicleDic
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_VEHICLEBINDDEVICE_INSERT_URL];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"adertisment image url用户绑定车辆与设备:%@",urlString);
    [self requestWithHttpURL:urlString andParamDict:vehicleDic andSuccess:success andFailer:failure];
}
#pragma mark 用户设置默认车辆
+ (void)insertDeviceSetDefaultWithUserDic:(NSDictionary *)vehicleDic
                                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_VEHICLESETDEFAULT_INSERT_URL];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"adertisment image url用户绑定车辆与设备:%@",urlString);
   [self requestWithHttpURL:urlString andParamDict:vehicleDic andSuccess:success andFailer:failure];
}
#pragma mark 用户购买汽车服务列表
+ (void)searchCarServicePurchaseListWithUserDic:(NSDictionary *)parmDict
                                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_VEHICLESERVICEPURCHASELIST_SEARCH_URL];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"adertisment image url用户购买汽车服务列表:%@",urlString);
    [self requestWithHttpURL:urlString andParamDict:parmDict andSuccess:success andFailer:failure];

}

#pragma mark 用户购买汽车服务列表（订单列表）

+ (void)searchCarServiceRecordDetailWithUserDic:(NSDictionary *)parmDict
                                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_VEHICLESERVICERECORDDETAIL_SEARCH_URL];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"adertisment image url用户购买汽车服务列表:%@",urlString);
    [self requestWithHttpURL:urlString andParamDict:parmDict andSuccess:success andFailer:failure];
}

#pragma mark 用户对商户打分：
+ (void)insertTenantEvaluateDoRateWithUserDic:(NSDictionary *)parmDict
                                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_TENANTEVALUATEDORATE_INSERT_URL];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"adertisment image url用户对商户打分:%@",urlString);
    [self requestWithHttpURL:urlString andParamDict:parmDict andSuccess:success andFailer:failure];
    
}


#pragma mark 手机扫描商家二维码时用户车辆与商家绑定：

+ (void)insertVehicleBindTenantWithUserDic:(NSDictionary *)vehicleDic
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_BINDTENANT_INSERT_URL];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"adertisment image url手机扫描商家二维码时用户车辆与商家绑定:%@",urlString);
    [self requestWithHttpURL:urlString andParamDict:vehicleDic andSuccess:success andFailer:failure];
}

#pragma mark 用户预约汽车服务：

+ (void)insertVehicleSubscribeServiceWithUserDic:(NSDictionary *)vehicleDic
                                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_SUBSCRIBESERVICE_INSERT_URL];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"adertisment image url用户预约汽车服务：:%@",urlString);
    [self requestWithHttpURL:urlString andParamDict:vehicleDic andSuccess:success andFailer:failure];

}
#pragma mark 更新购买汽车服务记录状态

+ (void)updateCarServicePayStatusWithUserDic:(NSDictionary *)vehicleDic
                                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_PAYSTATUS_UPDATE_URL];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"adertisment image url更新购买汽车服务记录状态:%@",urlString);
    [self requestWithHttpURL:urlString andParamDict:vehicleDic andSuccess:success andFailer:failure];
}

#pragma mark 购买设备充值页面(返回数据库配置的设备价格)

+ (void)getPurDevicePageWithUserDic:(NSDictionary *)vehicleDic
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_PURDEVICEPAGE_GET_URL];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"adertisment image url购买设备充值页面:%@",urlString);
    [self requestWithHttpURL:urlString andParamDict:vehicleDic andSuccess:success andFailer:failure];

}

#pragma mark 充值获取交易凭证

+ (void)getbalanceChargeInWithUserDic:(NSDictionary *)vehicleDic
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_BALANCECHAREIN_GET_URL];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"adertisment image url充值获取交易凭证:%@",urlString);
    [self requestWithHttpURL:urlString andParamDict:vehicleDic andSuccess:success andFailer:failure];


}

#pragma mark 购买设备充值回调：

+ (void)getPurDeviceChargeWithUserDic:(NSDictionary *)vehicleDic
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_PURDEVICECHARGE_GET_URL];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"adertisment image url购买设备充值回调:%@",urlString);
    [self requestWithHttpURL:urlString andParamDict:vehicleDic andSuccess:success andFailer:failure];
}
//post方法
+(void)requestWithHttpURL:(NSString*)urlString  andParamDict:(NSDictionary*)thyParamDict andSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success andFailer:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:thyParamDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}



#pragma mark 租户详情
+ (void)getTenantDetailsWithUserId:(NSString *)userId
                             token:(NSString *)token
                          tenantId:(NSString *)tenantId
                           success:(void (^)(AFHTTPRequestOperation *, id))success
                           failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:userId forKey:@"userId"];
    [parmDict setObject:token forKey:@"token"];
    [parmDict setObject:tenantId forKey:@"tenantId"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_TENANT_DETAILS_URL];
    NSLog(@"租户详情url :%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:parmDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];

}

#pragma mark 购买服务
+ (void)payServiceWithUserId:(NSString *)userId
                       token:(NSString *)token
                   serviceId:(NSString *)serviceId
                 paymentType:(NSString *)paymentType
                    recordId:(NSString *)recordId
                    couponId:(NSString *)couponId
                     success:(void (^)(AFHTTPRequestOperation *, id))success
                     failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:userId forKey:@"userId"];
    [parmDict setObject:token forKey:@"token"];
    [parmDict setObject:serviceId forKey:@"serviceId"];
    [parmDict setObject:paymentType forKey:@"paymentType"];
    [parmDict setObject:recordId forKey:@"recordId"];
    [parmDict setObject:couponId forKey:@"couponId"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_PAY_SERVICE_URL];
    NSLog(@"购买服务url :%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:parmDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}

#pragma mark 优惠券列表
+ (void)discountCouponListWithUserId:(NSString *)userId
                               token:(NSString *)token
                           serviceId:(NSString *)serviceId
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:userId forKey:@"userId"];
    [parmDict setObject:token forKey:@"token"];
    [parmDict setObject:serviceId forKey:@"serviceId"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_DISCOUNT_COUPON_URL];
    NSLog(@"优惠券列表url :%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:parmDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}
@end
