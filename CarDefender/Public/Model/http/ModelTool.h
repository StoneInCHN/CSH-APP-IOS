//
//  ModelTool.h
//  请求数据
//  @param dic
//  @param modelsuccess 成功回调数据
//  @param modelfaile   失败回调数据
//  Created by renhua on 14-9-10.
//  Copyright (c) 2014年 YBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
typedef void(^ModelSuccess)(id object);
typedef void(^ModelFaile)(NSError*err);
@interface ModelTool : NSObject

//#pragma mark - 4.24.2 签到
//+(void)httpGetSignInItemWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;

#pragma mark - 获取车辆信息接口
/**
 *  获取车辆信息接口
 *
 *  @param dic          @{@"type":  @"parent_id":} //type 第几级菜单  parent_id model_id  series_id   传相应的数据
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetCarBSMListWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 获取验证码
/**
 *  获取验证码
 *
 *  @param dic          @{@"mobile": ,@"password":} //account 账号     password 密码
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetAppGetVdCodeWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;

#pragma mark - 注册
/**
 *  注册
 *
 *  @param dic          @{@"tel": ,@"psw":  ,@"nick": ,@"phone": ,@"system": ,@"app":} //@"tel":电话,@"psw":密码,@"nick":昵称,@"phone":手机设备,@"system":手机系统,@"app":APP系统
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetAppRegistWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 登录
/**
 *  登录
 *
 *  @param dic          @{@"tel": ,@"psw":  ,@"imei": ,@"lnglat": ,@"phone": ,@"system": ,@"app": } //@"tel":电话,@"psw":密码,,@"imei":唯一标示,@"lnglat":经纬度,@"phone":手机设备,@"system":手机系统,@"app":APP系统
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetAppLoginWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 登录新接口
/**
 *  登录
 *
 *  @param dic          @{@"tel": ,@"psw":  ,@"imei": ,@"lnglat": ,@"phone": ,@"system": ,@"app": } //@"tel":电话,@"psw":密码,,@"imei":唯一标示,@"lnglat":经纬度,@"phone":手机设备,@"system":手机系统,@"app":APP系统
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetAppLoginNewWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 修改个人信息
/**
 *  修改个人信息
 *
 *  @param dic          @{@"uid": ,@"key":  ,@"nick": ,@"sex": ,@"age": ,@"birth": ,@"city": ,@"note":}
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpUpdatePersonWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 获取个人信息
/**
 *  获取个人信息
 *
 *  @param dic          @{@"uid": ,@"key": }
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetPersonWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 积分详情
/**
 *  获取个人信息
 *
 *  @param dic          @{@"cid": ,@"uid": ,@"page":,@"size":}
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
//+(void)httpGetPersonWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;

#pragma mark - 拨打电话
/**
 *  拨打电话
 *
 *  @param @{@"uid": ,@"called": }   uid(用户id)，called(被叫号码)
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetCallParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 我的车位置
/**
 *  我的车位置
 *
 *  @param dic          @{@"mobile": ,@"password":} //account 账号     password 密码
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetGPSCarInfoWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
+(void)httpGetGPSNewCarInfoWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 添加车辆绑定设备
/**
 *  添加车辆绑定设备
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetAppAddCarWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 车辆管理列表接口
/**
 *  车辆管理列表接口
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetAppGainCarsWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 退出登陆接口
/**
 *  退出登陆接口
 *
 *  @param dic @{@"uid": ,@"key": }  uid:用户ID   key:APP KEY(登陆获取)
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetAppLogoutWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 获取城市列表接口
/*
 *  获取城市列表接口
 *
 *  @param dic @{@"uid": ,@"key": }  uid:用户ID   key:APP KEY(登陆获取)
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetAppGainCityWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;

#pragma mark - 修改个人信息接口
/**
 *  修改个人信息接口
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetAppUpPersonWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 修改个人信息接口-新接口
/**
 *  修改个人信息接口-新接口
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetAppUpPersonNewWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 签到详情
/**
 *  签到详情
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetGainSignWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 签到
/**
 *  签到
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetSignWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 百度兴趣点接口
/**
 *  百度兴趣点接口
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGainInterestWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 百度兴趣点接口
/**
 *  百度兴趣点接口
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGainGasWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;

#pragma mark - 服务广场列表接口
/**
 *  服务广场列表接口
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppGainServiceWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;

#pragma mark - 服务广场详情接口
/**
 *  服务广场详情接口
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppGainServiceDetailWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;

#pragma mark - 获取车辆品牌列表
/**
 *  获取车辆品牌列表
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppGainBSMWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;

#pragma mark - 报告接口
/**
 *  报告接口
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppGainReportWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;

#pragma mark - 验证登陆
/**
 *  验证登陆
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppLoginIsValidWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;

#pragma mark - 获取APP登陆信息
/**
 *  获取APP登陆信息
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppGainLoginWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 获取APP登陆信息新接口
/**
 *  获取APP登陆信息新接口
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppGainNewLoginWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;

#pragma mark - 保存头像信息接口
/**
 *  保存头像信息接口
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppUpHeadWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;

#pragma mark - 足迹
/**
 *  足迹
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGainFootmarkWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 足迹详情
/**
 *  足迹详情
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGainFootDesWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;

#pragma mark - 获取消息列表
/**
 *  获取消息列表
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppGainPushWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 获取消息列表-新接口
/**
 *  获取消息列表-新接口
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppGainPushNewWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 获取消息列表-获取未读条数
/**
 *  获取消息列表-获取未读条数
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppGainNumWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 修改密码接口
/**
 *  修改密码接口
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppUpPswWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 检测接口
/**
 *  检测接口
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetGainCheckWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 实时车况
/**
 *  实时车况
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetGainOBDWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;

#pragma mark - 维修保养
/**
 *  维修保养
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppGainGasWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 设置默认车辆
/**
 *  设置默认车辆
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpUpDefaultCarWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 修改车辆数据
/**
 *  设置默认车辆
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppUpCarWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;

#pragma mark - 车友圈列表
/**
 *  车友圈列表
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppGainCircleWithSuccess:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 车友圈二级界面
/**
 *  车友圈二级界面
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppGainCicleInfoWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 车友圈详情界面
/**
 *  车友圈详情界面
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppGainCircleDesWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 检测修改里程
/**
 *  检测修改里程
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppModifyMileWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 车友圈详情界面
/**
 *  车友圈详情界面
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppModifyInspectWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 驾驶行为评分详情
/**
 *  驾驶行为评分详情
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetDriveBehaviorDayDataWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 平均速度
/**
 *  平均速度
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetReportDesWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 驾驶行为具体详情
/**
 *  驾驶行为具体详情
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetDayDataDesWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 费用添加接口
/**
 *  费用添加接口
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppAddReportFeeWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 13.	费用详情修改接口
/**
 *  13.	费用详情修改接口
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppUpReportFeeWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 删除费用详情接口
/**
 *  删除费用详情接口
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppUpReportFeeDelReportFeeWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 个人中心接口
/**
 *  个人中心接口
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetGainPersonWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 积分信息接口
/**
 *  积分信息接口
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetScoreWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 更新个性签名接口
/**
 *  更新个性签名接口
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpUploadNoteWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 获取城市ID接口
/**
 *  获取城市ID接口
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetCityWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 获取费用详情接口
/**
 *  获取费用详情接口
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetFeeWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 选择回馈方式
/**
 *  选择回馈方式
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppChooseFeedWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 报警设置接口
/**
 *  报警设置接
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppUpWarnWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 获取消息模块数据
/**
 *  获取消息模块数据
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppGainWarnWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 添加sos号码
/**
 *  添加sos号码
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppUpSosWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 删除sos号码
/**
 *  删除sos号码
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppDelSosWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 编辑sos号码
/**
 *  编辑sos号
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpAppEditSosWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 新找车位接口
/**
 *  新找车位接口
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetParkWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 新找车位详情接口
/**
 *  新找车位详情接口
 *
 *  @param dic
 *  @param modelsuccess 成功回调数据
 *  @param modelfaile   失败回调数据
 */
+(void)httpGetParkInfoWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;


#pragma mark - 判断是否有预约
+(void)httpGetCheckOrderWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 洗车预约列表
+(void)httpGetCarwashWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 洗车预约详情
+(void)httpGetCarwashInfoWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 洗车预约
+(void)httpGetAddOrderWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 洗车取消预约
+(void)httpGetCancelOrderWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 获取商城用户账户
+(void)httpGetShopMallUserMsgWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 充值获取订单编号
+(void)httpAppGainPgyOrderWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;

#pragma mark - 微信支付获取订单
+(void)httpAppGainWeiXinOrderWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;

#pragma mark - 获取历史订单
+(void)httpAppGainWashListWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;

#pragma mark - 客户确认订单
+(void)httpAppGainConfirmOrderWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 还未洗车原因
+(void)httpAppGainNotWashWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 获取洗车点数据
+(void)httpAppGainWashWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;

#pragma mark - 获取是否购买过保险的信息接口
+(void)httpAppGainPolicyWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 购买保险接口
+(void)httpAppGainBuyPolicyWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;
#pragma mark - 保险（保障协议）
+(void)httpAppGainPolicyRuleWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile;

#pragma mark - 停止请求
+(void)stopAllOperation;

#pragma mark - 检测网络
+ (BOOL)checkNetWork;


#pragma mark -==========================================新版Model接口==============================================
#pragma mark -----------------------------------------------------------------------------------------------------获取车辆列表信息
/**获取车辆列表信息*/
+(void)getVehicleInfoWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;

#pragma mark -----------------------------------------------------------------------------------------------------获取钱包信息
/**获取钱包信息*/
+(void)getWalletInfoWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;

#pragma mark -----------------------------------------------------------------------------------------------------获取车辆品牌
/**获取车辆品牌*/
+(void)getVehicleBrandWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;

#pragma mark -----------------------------------------------------------------------------------------------------添加车辆信息
/**添加车辆信息*/
+(void)insertVehicleInfoWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;

#pragma mark -----------------------------------------------------------------------------------------------------编辑车辆信息
/**编辑车辆信息*/
+(void)editVehicleInfoWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;

#pragma mark -----------------------------------------------------------------------------------------------------绑定设备接口
/**绑定设备接口*/
+(void)insertBindVehicleInfoWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;

#pragma mark -----------------------------------------------------------------------------------------------------更改默认车辆接口
/**更改默认车辆接口*/
+(void)changeDefaultCarWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;

#pragma mark -----------------------------------------------------------------------------------------------------获取定位信息
/**获取定位信息*/
+(void)getLocationWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;

#pragma mark -----------------------------------------------------------------------------------------------------获取报告信息
/**获取报告信息*/
+(void)getReportWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;

#pragma mark -----------------------------------------------------------------------------------------------------检测信息
/**检测信息*/
+(void)getCarCheckWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;

#pragma mark -----------------------------------------------------------------------------------------------------洗车
/**洗车*/
+(void)getWashCarWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;

#pragma mark -----------------------------------------------------------------------------------------------------美容
/**美容*/
+(void)getBeautyWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;

#pragma mark -----------------------------------------------------------------------------------------------------商家详情以及商品
/**商家详情以及商品*/
+(void)getMerchantsDetailAndDoodsWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;

#pragma mark -----------------------------------------------------------------------------------------------------查看消息详情
/**查看消息详情*/
+(void)getCheckMessageWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;

#pragma mark -----------------------------------------------------------------------------------------------------消息列表
/**消息列表*/
+(void)getInformationListWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;

#pragma mark -----------------------------------------------------------------------------------------------------加载首页信息
/**加载首页信息*/
+(void)getHomeMessageWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;

#pragma mark -----------------------------------------------------------------------------------------------------订单生成
/**订单生成*/
+(void)getGenerateOrderWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;

#pragma mark -----------------------------------------------------------------------------------------------------支付交易创建(用于在线支付)
/**支付交易创建(用于在线支付)*/
+(void)getPayOrderCreateWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;

#pragma mark -----------------------------------------------------------------------------------------------------支付交易创建(用于红包和余额支付)
/**支付交易创建(用于红包和余额支付)*/
+(void)getPayByRedAndBalaceWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;

#pragma mark -----------------------------------------------------------------------------------------------------在线支付完成
/**在线支付完成返回接口*/
+(void)getPayFinishInfoWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;

#pragma mark -----------------------------------------------------------------------------------------------------订单取消
/**订单取消*/
+(void)getCancleOrderWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;

#pragma mark -----------------------------------------------------------------------------------------------------我的订单
/**我的订单*/
+(void)getMyOrderWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;

#pragma mark -----------------------------------------------------------------------------------------------------订单详情
/**订单详情*/
+(void)getMyOrderDetaikWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;

#pragma mark -----------------------------------------------------------------------------------------------------红包详情
/**红包详情*/
+(void)getRedDetaikWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;

#pragma mark -----------------------------------------------------------------------------------------------------保养服务
/**保养服务*/
+(void)getMaintenanceServiceListWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;

#pragma mark -----------------------------------------------------------------------------------------------------推送消息
/**推送消息*/
+(void)getPushMessageWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;

#pragma mark -----------------------------------------------------------------------------------------------------钱包明细表
/**钱包明细表*/
+(void)getWalletDetailListWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;



@end
