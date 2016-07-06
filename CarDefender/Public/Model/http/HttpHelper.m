//
//  HttpHelper.m
//  CarDefender
//
//  Created by sicnu_ifox on 16/5/4.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "HttpHelper.h"
#import "AFHTTPRequestOperationManager.h"

#import "HttpURLMacro.h"

@implementation HttpHelper
#pragma mark json post通用
+ (void)post:(NSString *)url
  parameters:(NSMutableDictionary *)parmDict
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:url parameters:parmDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}

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
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:token] forKey:@"token"];
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
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:token] forKey:@"token"];
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
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:userId] forKey:@"userId"];
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:token] forKey:@"token"];
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
    [self post:urlString parameters:parmDict success:success failure:failure];
}
#pragma mark 一键检测之查看详情
+ (void)scanDetailWithUserId:(NSString *)userId
                       token:(NSString *)token
                    deviceNo:(NSString *)deviceNo
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:userId] forKey:@"userId"];
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:token] forKey:@"token"];
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:deviceNo] forKey:@"deviceNo"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_VEHICLE_SCAN_URL];
    NSLog(@"scan detail url :%@",urlString);
    [self post:urlString parameters:parmDict success:success failure:failure];
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
                    piWidth:(NSString *)piWidth
                   piHeight:(NSString *)piHeight
                    success:(void (^)(AFHTTPRequestOperation *, id))success
                    failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:userId forKey:@"userId"];
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:token] forKey:@"token"];
    [parmDict setObject:versionCode forKey:@"versionCode"];
    [parmDict setObject:regId forKey:@"regId"];
    [parmDict setObject:appPlatform forKey:@"appPlatform"];
    [parmDict setObject:piWidth forKey:@"piWidth"];
    [parmDict setObject:piHeight forKey:@"piHeight"];
    
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

#pragma mark 根据用户当前车辆查询租户可用的服务详情

+ (void)getTenantInfiServiceByldWithUserDic:(NSDictionary *)vehicleDic
                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_TENANTINFOSERVICEBYLD_GET_URL];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"adertisment image url根据用户当前车辆查询租户可用的服务详情:%@",urlString);
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

#pragma mark 获取用户已经购买的可以绑定的设备列表

+ (void)getAvailableDeviceWithUserDic:(NSDictionary *)vehicleDic
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_AVAILABLEDEVICE_GET_URL];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"获取用户已经购买的可以绑定的设备列表:%@",urlString);
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
    if (![paymentType isEqualToString:@"0"]) {
         [parmDict setObject:paymentType forKey:@"paymentType"];
    }
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
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:userId] forKey:@"userId"];
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:token] forKey:@"token"];
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:serviceId] forKey:@"serviceId"];
    
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

#pragma mark 可选优惠券列表－活动页面
+ (void)couponListWithUserId:(NSString *)userId
                       token:(NSString *)token
                    pageSize:(NSString *)pageSize
                  pageNumber:(NSString *)pageNumber
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:userId] forKey:@"userId"];
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:token] forKey:@"token"];
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:pageSize] forKey:@"pageSize"];
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:pageNumber] forKey:@"pageNumber"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_AVAILABLE_COUPON_URL];
   [self post:urlString parameters:parmDict success:success failure:failure];
}

#pragma mark 申请获取优惠券
+ (void)applyCouponWithUserId:(NSString *)userId
                        token:(NSString *)token
                     couponId:(NSString *)couponId
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:userId] forKey:@"userId"];
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:token] forKey:@"token"];
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:couponId] forKey:@"couponId"];
     NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_APPLY_COUPON_URL];
    [self post:urlString parameters:parmDict success:success failure:failure];
}

#pragma mark 获取洗车劵
+ (void)myWashingCouponWithUserId:(NSString *)userId
                            token:(NSString *)token
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:userId] forKey:@"userId"];
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:token] forKey:@"token"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_MYWASH_COUPON_URL];
    [self post:urlString parameters:parmDict success:success failure:failure];
}

#pragma mark 账户余额充值
+ (void)walletChargeWithUserId:(NSString *)userId
                         token:(NSString *)token
                        amount:(NSString *)amount
                   paymentType:(NSString *)paymentType
                    chargeType:(NSString *)chargeType
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:userId] forKey:@"userId"];
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:token] forKey:@"token"];
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:amount] forKey:@"amount"];
    [parmDict setObject:[PublicUtils checkNSNullWithgetString:paymentType] forKey:@"paymentType"];
    [parmDict setObject:chargeType forKey:@"chargeType"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SERVERADDRESS, KHTTPHELPER_WALLET_CHARGE_URL];
    NSLog(@"余额充值 :%@",urlString);   
    [self post:urlString parameters:parmDict success:success failure:failure];
}

@end
