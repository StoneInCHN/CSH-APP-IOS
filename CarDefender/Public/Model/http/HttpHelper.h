//
//  HttpHelper.h
//  CarDefender
//
//  Created by sicnu_ifox on 16/5/4.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPRequestOperation;

#define SERVERADDRESS @"http://120.27.92.247:10001"

@interface HttpHelper : NSObject
#pragma mark 获取验证码(注册和找回密码)
+ (void)getVerifyCodeWithMobileNo:(NSString *)mobileNum
                        tokenType:(NSString *)tokenType
                         sendType:(NSString *)sendType
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 验证验证码(注册和找回密码)
/**
 * options :REGISTER_CODE --> "register" -->注册
 *         :MODIFY_PASSWD_CODE --> "modify_password" -->修改密码
 */
+ (void)confirmVerifyCodeWithUserTel:(NSString *)mobileNo
                     smsToken:(NSString *)smsToken
                             options:(NSString *)options
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 注册(密码需加密)
+ (void)registerWithUserName:(NSString *)userName
                    password:(NSString *)passwd
               passwdConfirm:(NSString *)passwdConfirm
                      sucess:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma mark 登录(密码需加密)
+ (void)userLoginWithUserName:(NSString *)userName
                     password:(NSString *)passwd
                 deviceToken:(NSString *) deviceToken
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 修改密码(密码需加密)
+ (void)modifyPasswordWithUserName:(NSString *)userName
                            passwd:(NSString *)passwd
                   passwdConfirm:(NSString *)passwdConfirm
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 更改用户信息(不包括用户头像)
+ (void)changeUserInfoWithUserId:(NSString *)userId
                           token:(NSString *)token
                        nickName:(NSString *)niceName
                            sign:(NSString *)sign
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 我的钱包
+ (void)viewMyWalletWithUserId:(NSString *)userId
                           token:(NSString *)token
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 我的钱包--余额，红包,积分接口
/**
  余额:MONEY
  红包:REDPACKET
  积分:SCORE
 */
+ (void)getMoneyOrRedPacketWithUserId:(NSString *)userId
                                token:(NSString *)token
                           walletType:(NSString *)walletType
                             walletId:(NSString *)walletId
                           pageNumber:(NSString *)pageNumber
                             pageSize:(NSString *)pageSize
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 获取广告信息
+ (void)getAdvertismentImageWithUserId:(NSString *)userId
                               token:(NSString *)token
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 获取用户消息列表 
+ (void)getMessageListWithUserId:(NSString *)userId
                           token:(NSString *)token
                      pageNumber:(NSString *)pageNumber
                        pageSize:(NSString *)pageSize
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 修改消息状态
+ (void)changeMessageStateWithUserId:(NSString *)userId
                          token:(NSString *)token
                         msgId:(NSString *)msgId
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma mark 删除消息
+ (void)deleteMessageWithUserId:(NSString *)userId
                          token:(NSString *)token
                         msgIds:(NSArray *)msgIds
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 按服务类别（洗车，紧急救援）搜寻租户列表
+ (void)searchRenterListWithServiceCategoryId:(NSString *)serviceID
                                       userId:(NSString *)userId
                                        token:(NSString *)token
                                     latitude:(NSString *)latitude
                                    longitude:(NSString *)longitude
                                     pageSize:(int)pageSize
                                   pageNumber:(int)pageNumber
                                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma mark 车辆违章记录查询
+ (void)getIllegalRecordsWithUserId:(NSString *)userId
                              token:(NSString *)token
                              plate:(NSString *)plate
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma mark 意见反馈
+ (void)postFeedbackWithUserId:(NSString *)userId
                              token:(NSString *)token
                              content:(NSString *)content
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma mark 退出登录
+ (void)logoutWithUserId:(NSString *)userId
                         token:(NSString *)token
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma mark 一键检测
+ (void)oneKeyDetectionWithUserId:(NSString *)userId
                            token:(NSString *)token
                         deviceNo:(NSString *)deviceNo
                       searchDate:(NSString *)searchDate
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma mark 找加油站
+ (void)searchGasolineStationWithUserId:(NSString *)userId
                                  token:(NSString *)token
                                keyWord:(NSString *)keyWord
                              longitude:(NSString *)longitude
                               latitude:(NSString *)latitude
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma mark 车辆动态
+ (void)carTrendsWithUserId:(NSString *)userId
                                  token:(NSString *)token
                                deviceNo:(NSString *)deviceNo
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 初始化极光推送
+ (void)initJpushWithUserId:(NSString *)userId
                      token:(NSString *)token
                versionCode:(NSString *)versionCode
                      regId:(NSString *)regId
                appPlatform:(NSString *)appPlatform
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
