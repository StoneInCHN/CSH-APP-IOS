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
#pragma mark 更新登陆用户缓存信息
+ (void)updateLoginCacheInfoWithUserId:(NSString *)userId
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
#pragma mark 我的车辆
+ (void)myCarListWithUserId:(NSString *)userId
                      token:(NSString *)token
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

#pragma mark 车辆品牌查询

/**
 * 车辆品牌查询
 *
 *  @param  userId:用户ID   token: (登陆获取)
 *  @param success 成功回调数据
 *  @param failure 失败回调数据
 */
+ (void)searchVehicleBrandWithUserID:(NSString *)userId
                               token:(NSString *)token
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma mark 根据车辆品牌查询车系
/**
 * 根据车辆品牌查询车系
 *
 *  @param  userId:用户ID   token: (登陆获取)  brankId:品牌id
 *  @param success 成功回调数据
 *  @param failure 失败回调数据
 */
+ (void)searchVehicleLineByBrandWithUserID:(NSString *)userId
                                     token:(NSString *)token
                                   brankId:(NSNumber*)brankId
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 根据车辆车系查询车型
/**
 * 根据车辆品牌查询车系
 *
 *  @param  userId:用户ID   token: (登陆获取)  brankId:车系id
 *  @param success 成功回调数据
 *  @param failure 失败回调数据
 */
+ (void)searchVehicleBrandDetailByLineWithUserID:(NSString *)userId
                                           token:(NSString *)token
                                         brankId:(NSNumber*)brankId
                                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma mark 车辆列表
/**
 * 车辆品牌查询
 *
 *  @param  userId:用户ID   token: (登陆获取)
 *  @param success 成功回调数据
 *  @param failure 失败回调数据
 */
+ (void)searchVehicleListWithUserID:(NSString *)userId
                              token:(NSString *)token
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 添加车辆
/**
 *  添加车辆
 *
 *  @param dic @{@"userId": ,@"token": ,@"plateNo":,@"brandDetailId":,@"vehicleNo":,@"trafficInsuranceExpiration":,@"driveMileage":,@"nextAnnualInspection":,@"lastMaintainMileage":}  uid:用户ID   key:APP KEY(登陆获取)
 *  @param success 成功回调数据
 *  @param failure   失败回调数据
 */
+ (void)insertVehicleAddWithUserID:(NSDictionary *)vehicleDic
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 编辑车辆
/**
 * 编辑车辆
 *
 *  @param dic @{@"userId": ,@"token": ,@"plateNo":,@"brandDetailId":,@"vehicleNo":,@"trafficInsuranceExpiration":,@"driveMileage":,@"nextAnnualInspection":,@"lastMaintainMileage":}  )
 *  @param success 成功回调数据
 *  @param failure   失败回调数据
 */
+ (void)insertVehicleEditWithUserID:(NSDictionary *)vehicleDic
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 用户绑定车辆与设备
/**
 * 用户绑定车辆与设备
 *
 *  @param dic @{@"userId": ,@"token": ,@"deviceNo": ,@"vihicleId": }
 *  @param success 成功回调数据
 *  @param faile   失败回调数据
 */
+ (void)insertBindDeviceWithUserDic:(NSDictionary *)vehicleDic
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 用户设置默认车辆
/**
 * 用户设置默认车辆
 *
 *  @param dic @{@"userId": ,@"token": ,@"vihicleId": }
 *  @param success 成功回调数据
 *  @param faile   失败回调数据
 */
+ (void)insertDeviceSetDefaultWithUserDic:(NSDictionary *)vehicleDic
                                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma mark 用户购买汽车服务列表：
/**
 * 用户购买汽车服务列表
 *
 *  @param dic @{@"userId": ,@"token": ,@"pageNumber": ,@"pageSize"}
 *  @param success 成功回调数据
 *  @param faile   失败回调数据
 */
+ (void)searchCarServicePurchaseListWithUserDic:(NSDictionary *)vehicleDic
                                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 用户购买汽车服务列表（订单列表）
/**
 * 用户购买汽车服务列表
 *
 *  @param dic @{@"userId": ,@"token": ,@"recordId": }
 *  @param success 成功回调数据
 *  @param faile   失败回调数据
 */
+ (void)searchCarServiceRecordDetailWithUserDic:(NSDictionary *)vehicleDic
                                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma mark 用户对商户打分：
/**
 * 用户对商户打分：
 *
 *  @param dic @{@"userId": ,@"token": ,@"recordId": @"tenantId",@"score"}
 *  @param success 成功回调数据
 *  @param faile   失败回调数据
 */
+ (void)insertTenantEvaluateDoRateWithUserDic:(NSDictionary *)vehicleDic
                                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 手机扫描商家二维码时用户车辆与商家绑定：
/**
  * 手机扫描商家二维码时用户车辆与商家绑定：
  *
  *  @param dic @{@"userId": ,@"token": ,@"vehicleId": @"tenantId"}
  *  @param success 成功回调数据
  *  @param faile   失败回调数据
  */
+ (void)insertVehicleBindTenantWithUserDic:(NSDictionary *)vehicleDic
                                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma mark 租户详情
+ (void)getTenantDetailsWithUserId:(NSString *)userId
                            token:(NSString *)token
                         tenantId:(NSString *)tenantId
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 购买服务
+ (void)payServiceWithUserId:(NSString *)userId
                             token:(NSString *)token
                         serviceId:(NSString *)serviceId
                       paymentType:(NSString *)paymentType
                          recordId:(NSString *)recordId
                          couponId:(NSString *)couponId
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma mark 优惠券列表
+ (void)discountCouponListWithUserId:(NSString *)userId
                             token:(NSString *)token
                          serviceId:(NSString *)serviceId
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObjcet))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
