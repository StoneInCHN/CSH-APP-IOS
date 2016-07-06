//
//  HttpURLMacro.h
//  CarDefender
//
//  Created by sicnu_ifox on 16/6/15.
//  Copyright © 2016年 SKY. All rights reserved.
//

#ifndef HttpURLMacro_h
#define HttpURLMacro_h

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

#define KHTTPHELPER_TENANTINFOSERVICEBYLD_GET_URL @"/csh-interface/tenantInfo/getServiceById.jhtml"//根据用户当前车辆查询租户可用的服务详情

#define KHTTPHELPER_PAYSTATUS_UPDATE_URL @"/csh-interface/carService/updatePayStatus.jhtml"//更新购买汽车服务记录状态
#define KHTTPHELPER_TENANT_DETAILS_URL @"/csh-interface/tenantInfo/getTenantById.jhtml"//租户详情
#define KHTTPHELPER_PAY_SERVICE_URL @"/csh-interface/carService/payService.jhtml"//租户详情#
#define KHTTPHELPER_PURDEVICEPAGE_GET_URL @"/csh-interface/balance/purDevicePage.jhtml" //购买设备充值页面(返回数据库配置的设备价格)：

#define KHTTPHELPER_BALANCECHAREIN_GET_URL @"/csh-interface/balance/chargeIn.jhtml" //我的钱包余额充值获取交易凭证：

#define KHTTPHELPER_PURDEVICECHARGE_GET_URL @"/csh-interface/balance/purDeviceCharge.jhtml" //购买设备充值回调：

#define KHTTPHELPER_AVAILABLEDEVICE_GET_URL @"/csh-interface/vehicle/getAvailableDevice.jhtml" //获取用户已经购买的可以绑定的设备列表

#define KHTTPHELPER_TENANT_DETAILS_URL @"/csh-interface/tenantInfo/getTenantById.jhtml"//租户详情
#define KHTTPHELPER_PAY_SERVICE_URL @"/csh-interface/carService/payService.jhtml"//支付调用

#define KHTTPHELPER_BINDTENANT_INSERT_URL @"/csh-interface/vehicle/bindTenant.jhtml"//手机扫描商家二维码时用户车辆与商家绑定
#define KHTTPHELPER_DISCOUNT_COUPON_URL @"/csh-interface/coupon/getCouponForPay.jhtml" //支付时可用优惠券列表
#define KHTTPHELPER_AVAILABLE_COUPON_URL @"/csh-interface/coupon/availableCoupon.jhtml" //活动页面优惠券列表
#define KHTTPHELPER_APPLY_COUPON_URL @"/csh-interface/coupon/getCoupon.jhtml" //手机用户领取优惠券
#define KHTTPHELPER_MYWASH_COUPON_URL @"/csh-interface/coupon/myWashingCoupon.jhtml" //我的洗车劵列表
#define KHTTPHELPER_VEHICLE_SCAN_URL @"/csh-interface/obd/vehicleScan.jhtml" //--车辆详情接口, 用于车辆检测的安全扫描接口
#define KHTTPHELPER_WALLET_CHARGE_URL @"/csh-interface/balance/chargeIn.jhtml" //账户余额充值


#endif /* HttpURLMacro_h */
