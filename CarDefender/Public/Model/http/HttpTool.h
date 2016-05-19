//
//  HttpTool.h
//  请求数据
//
//  Created by renhua on 14-9-10.
//  Copyright (c) 2014年 YBB. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^HttpSuccess)(NSDictionary*data);
typedef void(^HttpFaile)(NSError*err);


@interface HttpTool : NSObject

#pragma mark -post方式请求数据
+(void)postWithHttpBody:(NSDictionary*)body success:(HttpSuccess)httpsuccess fail:(HttpFaile)httpfaile;


#pragma mark -新版Post方式验证*/
+(void)postVerifyWithHttpBody:(NSDictionary*)body success:(HttpSuccess)httpSuccess fail:(HttpFaile)httpFail;

#pragma mark -新版Post方式异地登录
+(void)postExceptionLoginWithHttpBody:(NSDictionary*)body andSuccess:(HttpSuccess)httpSuccess andFail:(HttpFaile)httpFail;

#pragma mark -新版Post方式登录*/
+(void)postLoginWithHttpBody:(NSDictionary*)body success:(HttpSuccess)httpSuccess fail:(HttpFaile)httpFail;

#pragma mark -新版Post方式注册*/
+(void)postRegisterWithHttpBody:(NSDictionary*)body success:(HttpSuccess)httpSuccess fail:(HttpFaile)httpFail;

#pragma mark - 新版Post方式退出登录*/
+(void)postLogoutWithHttpBody:(NSDictionary*)body success:(HttpSuccess)httpSuccess fail:(HttpFaile)httpFail;

#pragma mark - 查询所有用户信息
+(void)postcheckAllUserMessageWithParameter:(NSDictionary*)dic success:(HttpSuccess)httpsuccess faile:(HttpFaile)httpfaile;

#pragma mark - 统一修改用户信息
+(void)postModifyUserMessageWithParameter:(NSDictionary*)dic success:(HttpSuccess)httpsuccess faile:(HttpFaile)httpfaile;

#pragma mark - 修改昵称
+(void)postModifyNikeNameWithParameter:(NSDictionary*)dic success:(HttpSuccess)httpsuccess faile:(HttpFaile)httpfaile;

#pragma mark - 修改签名
+(void)postModifySignatureWithParameter:(NSDictionary*)dic success:(HttpSuccess)httpsuccess faile:(HttpFaile)httpfaile;

#pragma mark - 修改密码
+(void)postModifyPasswdWithParameter:(NSDictionary*)dic success:(HttpSuccess)httpsuccess faile:(HttpFaile)httpfaile;

#pragma mark - 反馈信息
+(void)postFeedbackMessageWithParameter:(NSDictionary*)dic success:(HttpSuccess)httpsuccess faile:(HttpFaile)httpfaile;

#pragma mark - 网络电话充值卡获取
+(void)postInternetPhoneMessageWithParameter:(NSDictionary*)dic success:(HttpSuccess)httpsuccess faile:(HttpFaile)httpfaile;

@end
