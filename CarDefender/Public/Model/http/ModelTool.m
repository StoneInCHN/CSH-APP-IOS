//
//  ModelTool.m
//  请求数据
//
//  Created by renhua on 14-9-10.
//  Copyright (c) 2014年 YBB. All rights reserved.
//

#import "ModelTool.h"
#import "AFHTTPRequestOperationManager.h"
#import "HttpTool.h"
//#import "Reachability.h"
//#define kGZHttpURL @"http://114.215.109.210/"
#define kZLHttpURL @"http://115.28.161.11:8080/ZL/appDate/"
#define kCarDefenderUrl @"http://115.28.161.11:8080/XAI/app/"
#define kCarDefenderInterestUrl @"http://115.28.161.11:8080/XAI/app/service/"  //192.168.1.100:8080
#define kCarDefenderInterestNewUrl @"http://115.28.161.11:8080/XAI/app/t_cws/"
#define BaseUrl @"http://127.0.0.1/"
#define kShopMall @"http://182.92.82.119/mobile/index.php?act=login"


#if USENEWURL
#define HTTP_APP_PREFIX @"http://192.168.1.111/app/"
#else
#define HTTP_APP_PREFIX @"http://jfinal.chcws.com/app/"

#endif




@implementation ModelTool

#pragma mark - 获取车辆信息接口
+(void)httpGetCarBSMListWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"appCarBSMList.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kZLHttpURL];
}
#pragma mark - 获取验证码
+(void)httpGetAppGetVdCodeWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"appGetVdCode.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kZLHttpURL];
}
#pragma mark - 注册
+(void)httpGetAppRegistWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"cws/appRegist.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 登录
+(void)httpGetAppLoginWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"cws/appLogin.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 登录新接口
+(void)httpGetAppLoginNewWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"t_cws/appLogin.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 更新个人信息
+(void)httpUpdatePersonWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"cws/appUpPerson.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 获取个人信息
+(void)httpGetPersonWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"cws/appGainPerson.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 拨打电话
+(void)httpGetCallParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"appCall.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kZLHttpURL];
}
#pragma mark - 我的车位置
+(void)httpGetGPSNewCarInfoWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"t_cws/appGainGPSCars.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 我的车位置
+(void)httpGetGPSCarInfoWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"cws/appGainGPSCars.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 添加车辆绑定设备
+(void)httpGetAppAddCarWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfail
{
    [self commonHttp:@"up/appAddCar.do" Dictionary:dic success:modelsuccess faile:modelfail type:kCarDefenderUrl];

}
#pragma mark - 车辆管理列表接口
+(void)httpGetAppGainCarsWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"appGainCars.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderInterestNewUrl];
}
#pragma mark - 退出登陆接口
+(void)httpGetAppLogoutWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"cws/appLogout.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 获取城市列表接口
+(void)httpGetAppGainCityWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"cws/appGainCity.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 修改个人信息接口
+(void)httpGetAppUpPersonWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"cws/appUpPerson.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 修改个人信息接口-新接口
+(void)httpGetAppUpPersonNewWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"t_cws/appUpPerson.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}


#pragma mark - 签到
+(void)httpGetSignWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"cws/appSign.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 签到详情
+(void)httpGetGainSignWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"cws/appGainSign.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 百度兴趣点接口
+(void)httpGainInterestWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"appGainInterest.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderInterestUrl];
}
+(void)httpGainGasWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"appGainGas.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderInterestUrl];
}
#pragma mark - 服务广场列表接口
+(void)httpAppGainServiceWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"appGainService.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderInterestUrl];
}

#pragma mark - 服务广场详情接口
+(void)httpAppGainServiceDetailWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"appGainServiceDetail.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderInterestUrl];
}
#pragma mark - 获取车辆品牌列表
+(void)httpAppGainBSMWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"cws/appGainBSM.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 报告接口
+(void)httpAppGainReportWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"t_cws/appGainReport.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 验证登陆
+(void)httpAppLoginIsValidWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"cws/appLoginIsValid.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 获取APP登陆信息
+(void)httpAppGainLoginWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"cws/appGainLogin.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 获取APP登陆信息新接口
+(void)httpAppGainNewLoginWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"t_cws/appGainLogin.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 保存头像信息接口
+(void)httpAppUpHeadWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"cws/appUpHead.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 足迹
+(void)httpGainFootmarkWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"cws/appGainFootmark.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 足迹详情
+(void)httpGainFootDesWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"cws/appGainFootDes.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 获取消息列表
+(void)httpAppGainPushWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"appGainPush.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderInterestUrl];
}
#pragma mark - 获取消息列表-新接口
+(void)httpAppGainPushNewWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"t_cws/appGainPush.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 获取消息列表-获取未读条数
+(void)httpAppGainNumWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"t_cws/appGainNum.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 修改密码接口
+(void)httpAppUpPswWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"cws/appUpPsw.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 检测接口
+(void)httpGetGainCheckWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"cws/appGainCheck.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 实时车况
+(void)httpGetGainOBDWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"t_cws/appGainOBD_re.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 维修保养
+(void)httpAppGainGasWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"appGainGas.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderInterestUrl];
}
#pragma mark - 设置默认车辆
+(void)httpUpDefaultCarWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"cws/appUpDefaultCar.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 修改车辆数据
+(void)httpAppUpCarWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"up/appUpCar.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 车友圈列表
+(void)httpAppGainCircleWithSuccess:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"appGainCircle.do" Dictionary:nil success:modelsuccess faile:modelfaile type:kCarDefenderInterestNewUrl];
}
#pragma mark - 车友圈二级界面
+(void)httpAppGainCicleInfoWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"appGainCircleInfo.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderInterestNewUrl];
}
#pragma mark - 车友圈详情界面
+(void)httpAppGainCircleDesWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"appGainCircleDes.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderInterestNewUrl];
}
#pragma mark - 检测修改里程
+(void)httpAppModifyMileWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"t_cws/appUpMile.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 车友圈详情界面
+(void)httpAppModifyInspectWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"t_cws/appUpInspect.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark -  驾驶行为评分详情
+(void)httpGetDriveBehaviorDayDataWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"t_cws/appGainDayData.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 平均速度
+(void)httpGetReportDesWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"t_cws/appGainReportDes.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 驾驶行为具体详情
+(void)httpGetDayDataDesWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"t_cws/appGainDayDataDes.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 费用添加接口
+(void)httpAppAddReportFeeWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"t_cws/appAddReportFee.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 13.	费用详情修改接口
+(void)httpAppUpReportFeeWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"t_cws/appUpReportFee.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 删除费用详情接口
+(void)httpAppUpReportFeeDelReportFeeWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"t_cws/appDelReportFee.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 个人中心接口
+(void)httpGetGainPersonWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"t_cws/appGainPerson.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 积分信息接口
+(void)httpGetScoreWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"t_cws/appGainScore.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 更新个性签名接口
+(void)httpUploadNoteWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"t_cws/appUpNote.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 获取城市ID接口
+(void)httpGetCityWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"t_cws/appGainCity.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 获取费用详情接口
+(void)httpGetFeeWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"t_cws/appGainFee.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}

#pragma mark - 选择回馈方式
+(void)httpAppChooseFeedWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"t_cws/appChooseFeed.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 报警设置接口
+(void)httpAppUpWarnWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"t_cws/appUpWarn.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 获取消息模块数据
+(void)httpAppGainWarnWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"t_cws/appGainWarn.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 添加sos号码
+(void)httpAppUpSosWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"t_cws/appUpSos.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 删除sos号码
+(void)httpAppDelSosWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"t_cws/appDelSos.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 编辑sos号码
+(void)httpAppEditSosWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"t_cws/appEditSos.do" Dictionary:dic success:modelsuccess faile:modelfaile type:kCarDefenderUrl];
}
#pragma mark - 新找车位
+(void)httpGetParkWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"appGainPark.do" Dictionary:dic success:modelsuccess faile:modelfaile type:@"http://115.28.161.11:8080/XAI/app/service/"];
}
#pragma mark - 新找车位详情
+(void)httpGetParkInfoWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"appGainParkInfo.do" Dictionary:dic success:modelsuccess faile:modelfaile type:@"http://115.28.161.11:8080/XAI/app/service/"];
}


#pragma mark - 判断是否有预约
+(void)httpGetCheckOrderWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"appCheckOrder.do" Dictionary:dic success:modelsuccess faile:modelfaile type:@"http://115.28.161.11:8080/XAI/app/service/"];
}
#pragma mark - 洗车预约列表
+(void)httpGetCarwashWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"appGainCarwash.do" Dictionary:dic success:modelsuccess faile:modelfaile type:@"http://115.28.161.11:8080/XAI/app/service/"];
}
#pragma mark - 洗车预约详情
+(void)httpGetCarwashInfoWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"appGainOrder.do" Dictionary:dic success:modelsuccess faile:modelfaile type:@"http://115.28.161.11:8080/XAI/app/service/"];
}
#pragma mark - 洗车预约
+(void)httpGetAddOrderWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"appAddOrder.do" Dictionary:dic success:modelsuccess faile:modelfaile type:@"http://115.28.161.11:8080/XAI/app/service/"];
}
#pragma mark - 洗车取消预约
+(void)httpGetCancelOrderWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"appCancelOrder.do" Dictionary:dic success:modelsuccess faile:modelfaile type:@"http://115.28.161.11:8080/XAI/app/service/"];
}
#pragma mark - 获取商城用户账户
+(void)httpGetShopMallUserMsgWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
//    [HttpTool postWithHttpBody:dic success:modelsuccess fail:modelfaile];
    [self shopMallHttp:nil Dictionary:dic success:modelsuccess faile:modelfaile type:nil];
}
#pragma mark - 充值获取订单编号
+(void)httpAppGainPgyOrderWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"appGainPgyOrder.do" Dictionary:dic success:modelsuccess faile:modelfaile type:@"http://115.28.161.11:8080/XAI/app/pgy/"];
}

#pragma mark - 微信支付获取订单
+(void)httpAppGainWeiXinOrderWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"appGainWechatOrder.do" Dictionary:dic success:modelsuccess faile:modelfaile type:@"http://app.chcws.com:8080/XAI/app/pgy/"];
}

#pragma mark - 获取历史订单
+(void)httpAppGainWashListWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"appGainWashList.do" Dictionary:dic success:modelsuccess faile:modelfaile type:@"http://115.28.161.11:8080/XAI/app/up/"];
}

#pragma mark - 客户确认订单
+(void)httpAppGainConfirmOrderWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"appUserConfirmOrder.do" Dictionary:dic success:modelsuccess faile:modelfaile type:@"http://115.28.161.11:8080/XAI/app/wash/"];
}

#pragma mark - 还未洗车原因
+(void)httpAppGainNotWashWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"appCarwashOrder.do" Dictionary:dic success:modelsuccess faile:modelfaile type:@"http://115.28.161.11:8080/XAI/app/wash/"];
}

#pragma mark - 获取洗车点数据
+(void)httpAppGainWashWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile{
    [self commonHttp:@"appGainWash.do" Dictionary:dic success:modelsuccess faile:modelfaile type:@"http://115.28.161.11:8080/XAI/app/up/"];
}
#pragma mark - 获取是否购买过保险的信息接口
+(void)httpAppGainPolicyWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"appGainPolicy.do" Dictionary:dic success:modelsuccess faile:modelfaile type:@"http://app.chcws.com:8080/XAI/app/up/"];
}
#pragma mark - 购买保险接口
+(void)httpAppGainBuyPolicyWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"appBuyPolicy.do" Dictionary:dic success:modelsuccess faile:modelfaile type:@"http://app.chcws.com:8080/XAI/app/up/"];
}
#pragma mark - 保险（保障协议）
+(void)httpAppGainPolicyRuleWithParameter:(NSDictionary*)dic success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    [self commonHttp:@"appGainPolicyRule.do" Dictionary:dic success:modelsuccess faile:modelfaile type:@"http://app.chcws.com:8080/XAI/app/up/"];
}
#pragma mark - 请求方法
+(void)commonHttp:(NSString*)str Dictionary:(NSDictionary*)dic  success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile type:(NSString*)type
{
    NSString* url = [NSString stringWithFormat:@"%@%@?",type,str];
    NSString* parameter;
    NSArray* lKeys = [dic allKeys];
    for ( int i=0; i<[lKeys count]; i++) {
        NSString* lKey = [lKeys objectAtIndex:i];
        NSString* value = [dic objectForKey:lKey];
        if (parameter == nil) {
            parameter = [NSString stringWithFormat:@"%@=%@",lKey,value];
        }else   
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,lKey,value];
        }
    }
    if (lKeys.count) {
        url = [NSString stringWithFormat:@"%@%@",url,parameter];
    }else{
        url = [NSString stringWithFormat:@"%@%@",type,str];
    }
    MyLog(@"%@",url);
    if ([self checkNetWork]) {
        AFHTTPRequestOperationManager *lManager = [AFHTTPRequestOperationManager manager];
        lManager.responseSerializer  = [AFHTTPResponseSerializer serializer];
        //设置网络超时
        lManager.requestSerializer.timeoutInterval = 30;
        [lManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary*datadic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            modelsuccess(datadic);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#warning 网络请求失败处理
            modelfaile(error);//error.code   == -1001  网络超时
            //error.code == -1004  1、无网络。2、服务器无响应；
        }];
    }
}



#pragma mark -------------------------------------------------------新版Model接口
/**获取车辆列表信息*/
+(void)getVehicleInfoWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail{
    [self commonHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"vehicle/queryVehicle" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}


/**获取车辆品牌*/
+(void)getVehicleBrandWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail{
    [self commonHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"brand/queryBrand" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}

/**获取钱包信息信息*/
+(void)getWalletInfoWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail{
    [self commonHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"wallet/queryWallet" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}



/**添加车辆信息*/
+(void)insertVehicleInfoWithParameter:(NSDictionary *)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail{
    [self requestWithHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"vehicle/insertVehicle" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}

/**编辑车辆信息*/
+(void)editVehicleInfoWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail{
    [self requestWithHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"vehicle/updateVehicle" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}

/**获取定位信息*/
+(void)getLocationWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail{
    [self commonHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"vehicle/queryLocation" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}



/**绑定设备接口*/
+(void)insertBindVehicleInfoWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail{
    [self commonHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"vehicle/bindVehicle" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}

/**更改默认车辆接口*/
+(void)changeDefaultCarWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail{
    [self commonHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"vehicle/updateDefault" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}

/**获取报告信息*/
+(void)getReportWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail{
    
    [self commonHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"vehicle/queryReport" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}


/**检测信息*/
+(void)getCarCheckWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail{
    
    [self commonHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"vehicle/queryCheck" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}

/**洗车*/
+(void)getWashCarWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail{

    [self commonHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"store/findStoreByWashingList" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}

/**美容*/
+(void)getBeautyWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail{
    [self commonHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"store/findCosmetology" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}

/**商家详情以及商品*/
+(void)getMerchantsDetailAndDoodsWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail{
    
    [self commonHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"store/findStoreInfo" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}

/**查看消息详情*/
+(void)getCheckMessageWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail;{

    [self commonHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"messageInfo/findMessageInfo" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}

/**消息列表*/
+(void)getInformationListWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail{
    [self commonHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"msg/queryMsg" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}

/**加载首页信息*/
+(void)getHomeMessageWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail{
    
    [self commonHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"loadData/index" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}

/**订单生成*/
+(void)getGenerateOrderWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail{
    
    [self commonHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"order/insertOrder" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}

/**支付交易创建*/
+(void)getPayOrderCreateWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail{
//    http://192.168.1.111/app/
//    http://jfinal.chcws.com/app/
    
    [self requestWithHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"pay/recharge" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}


/**支付交易创建(用于红包和余额支付)*/
+(void)getPayByRedAndBalaceWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail{
    [self requestWithHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"pay/queryCharge" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}

/**在线支付完成返回接口*/
+(void)getPayFinishInfoWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail{
    [self requestWithHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"order/paymentResult" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}

/**我的订单*/
+(void)getMyOrderWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail{
    
    [self requestWithHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"order/findOrderList" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}

/**订单详情*/
+(void)getMyOrderDetaikWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail{

    [self requestWithHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"order/findOrderDetails" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}

/**红包详情*/
+(void)getRedDetaikWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail{
    
    [self requestWithHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"wallet/redDetails" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}

/**订单取消*/
+(void)getCancleOrderWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail{
    [self requestWithHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"order/cancelOrder" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}


/**保养服务*/
+(void)getMaintenanceServiceListWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail{
    [self requestWithHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"store/findMaintenance" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}

/**推送消息*/
+(void)getPushMessageWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail{
    [self requestWithHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"msg/queryMsg" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}

/**钱包明细表*/
+(void)getWalletDetailListWithParameter:(NSDictionary*)ParamDict andSuccess:(ModelSuccess)receiveSuccess andFail:(ModelFaile)receiveFail{
    [self requestWithHttpPrefix:HTTP_APP_PREFIX andFunctionPath:@"walletRecord/WalletRecord" andParamDict:ParamDict andSuccess:receiveSuccess andFailer:receiveFail];
}


#pragma mark -=================================================新版GET方法 和 POST方法

//get方法
+(void)commonHttpPrefix:(NSString*)thyPrefix andFunctionPath:(NSString*)thyPath andParamDict:(NSDictionary*)thyParamDict andSuccess:(ModelSuccess)httpSuccess andFailer:(ModelFaile)httpFailer{
    
    NSString* urlString = [NSString stringWithFormat:@"%@%@?",thyPrefix,thyPath];
    
    if([thyParamDict allKeys].count){
        NSMutableArray* tempArray = [NSMutableArray array];
        for (NSString* thyKey in [thyParamDict allKeys]) {
            NSString* tempString = [NSString stringWithFormat:@"%@=%@",thyKey,[thyParamDict valueForKey:thyKey]];
            [tempArray addObject:tempString];
        }
        NSString* paramString = [tempArray componentsJoinedByString:@"&"];
        urlString = [NSString stringWithFormat:@"%@%@",urlString,paramString];
    }else{
        
        urlString = [NSString stringWithFormat:@"%@%@",thyPrefix,thyPath];
    }
    
    MyLog(@"当前请求的URL链接:%@",urlString);
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* rootDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        httpSuccess(rootDict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        httpFailer(error);
    }];
    
//    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFHTTPSessionManager* manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.requestSerializer.timeoutInterval = 30;
//    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary* dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        httpSuccess(dataDict);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        httpFailer(error);
//    }];
    
}

//post方法 
+(void)requestWithHttpPrefix:(NSString*)thyPrefix andFunctionPath:(NSString*)thyPath andParamDict:(NSDictionary*)thyParamDict andSuccess:(ModelSuccess)httpSuccess andFailer:(ModelFaile)httpFailer{
    
    NSString* urlString = [NSString stringWithFormat:@"%@%@?",thyPrefix,thyPath];
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    NSString* paramString;
    if([thyParamDict allKeys].count){
        NSMutableArray* tempArray = [NSMutableArray array];
        for (NSString* thyKey in [thyParamDict allKeys]) {
            NSString* tempString = [NSString stringWithFormat:@"%@=%@",thyKey,[thyParamDict valueForKey:thyKey]];
            [tempArray addObject:tempString];
        }
        if([thyParamDict allKeys].count > 1){
            paramString = [tempArray componentsJoinedByString:@"&"];
        }else{
            paramString = [tempArray firstObject];
        }
    }
    
    
    NSData* bodyParamData = [paramString dataUsingEncoding:NSUTF8StringEncoding];
    
    [urlRequest setHTTPBody:bodyParamData];
    [urlRequest setHTTPMethod:@"POST"];
    
     MyLog(@"当前请求的URL链接:%@%@",urlString,paramString);
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if(connectionError){
            if(httpFailer){
                httpFailer(connectionError);
            }
        }else{
            if(httpSuccess){
                NSDictionary* rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                httpSuccess(rootDict);
                
            }
        }
    }];
    
}

#pragma mark - 请求方法
+(void)shopMallHttp:(NSString*)str Dictionary:(NSDictionary*)dic  success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile type:(NSString*)type
{
    NSString* url = @"http://pay.chcws.com/mobile/index.php?act=login";
//    NSString* parameter;
//    NSArray* lKeys = [dic allKeys];
//    for ( int i=0; i<[lKeys count]; i++) {
//        NSString* lKey = [lKeys objectAtIndex:i];
//        NSString* value = [dic objectForKey:lKey];
//        if (parameter == nil) {
//            parameter = [NSString stringWithFormat:@"%@=%@",lKey,value];
//        }else
//        {
//            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,lKey,value];
//        }
//    }
//    url = [NSString stringWithFormat:@"%@%@",url,parameter];
//    MyLog(@"%@",url);
    
    if ([self checkNetWork]) {
        AFHTTPRequestOperationManager *lManager = [AFHTTPRequestOperationManager manager];
        lManager.responseSerializer  = [[AFHTTPResponseSerializer alloc] init];
        
        //设置网络超时
        //    lManager.requestSerializer.timeoutInterval = 30;
        
        [lManager POST:url parameters:dic
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   NSDictionary*datadic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                   modelsuccess(datadic);
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   modelfaile(error);
               }];
        //    [lManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSDictionary*datadic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        //        modelsuccess(datadic);
        //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //#warning 网络请求失败处理
        //        modelfaile(error);//error.code == -1001  网络超时
        //        //error.code == -1004  1、无网络。2、服务器无响应；
        //    }];
        
        
    }
   
}

#pragma mark - 停止请求
+(void)stopAllOperation
{
    AFHTTPRequestOperationManager *lManager = [AFHTTPRequestOperationManager manager];
    [lManager.operationQueue cancelAllOperations];
}

#pragma mark - 检测网络
+ (BOOL)checkNetWork
{
    
//    BOOL isExistenceNetwork = YES;
//    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
//    switch ([reach currentReachabilityStatus]) {
//        case NotReachable:
//            isExistenceNetwork = NO;
//            
//            NSLog(@"notReachable");
//            TTAlert(@"没有网络");
//            
//            break;
//        case ReachableViaWiFi:
//            isExistenceNetwork = YES;
//            NSLog(@"WIFI");
//            break;
//        case ReachableViaWWAN:
//            isExistenceNetwork = YES;
//            NSLog(@"3G");
//            break;
//    }
//    return isExistenceNetwork;
    return YES;
}

#pragma mark - 文件上传
+(void)httpUpDateImage:(NSData*)lImageData success:(ModelSuccess)modelsuccess faile:(ModelFaile)modelfaile
{
    UIImage* lImage = [[UIImage alloc] initWithData:lImageData];
    CGSize size;
    if (lImage.size.width > lImage.size.height) {
        if (lImage.size.width > 800) {
            size = CGSizeMake(800, lImage.size.height * (800 / lImage.size.width));
        }else
        {
            size = lImage.size;
        }
    }else
    {
        if (lImage.size.height > 800) {
            size = CGSizeMake(lImage.size.width * (800 / lImage.size.height), 800);
        }else
        {
            size = lImage.size;
        }
    }
    
    lImage = [self imageWithImageSimple:lImage scaledToSize:size];
    NSData *imageData = UIImageJPEGRepresentation(lImage,0.8); // 将图片转为NSData， 发送
    
    NSString *myURL = @"http://115.28.161.11:8080/XAI/appUpload/uploadPhoto";
    
    NSMutableData *postBody = [[NSMutableData alloc] init];
    
    
    NSURL *url = [NSURL URLWithString: myURL];  // serverURL 为要发送到的服务器地址
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL: url];
    
    [urlRequest setHTTPMethod: @"POST"];
    
    [postBody appendData: imageData];
    
    [urlRequest setHTTPBody: postBody];
    
    //同步请求
    NSData *returnData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
    NSDictionary *lDic=[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingAllowFragments error:nil];
    if(returnData)
    {
        modelsuccess(lDic);
    }
    else
    {
        modelfaile([NSError errorWithDomain:@"图片上传失败" code:0 userInfo:nil]);
    }
}
#pragma mark - 修改图片大小
+(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
