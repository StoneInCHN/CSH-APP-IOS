//
//  HttpTool.m
//  请求数据
//
//  Created by renhua on 14-9-10.
//  Copyright (c) 2014年 YBB. All rights reserved.
//

#import "HttpTool.h"
#define kHttpToolURL @"http://182.92.82.119/mobile/index.php?act=login"


#define KHTTPTOOL_VERIFY_URL @"/ucpaas/pin/smscode?"//验证
#define KHTTPTOOL_LOGIN_URL  @"/auth/login?"//登录
#define KHTTPTOOL_REGISTER_URL @"/auth/register?"//注册
#define KHTTPTOOL_LOGOUT_URL @"/auth/logout?"//注销
#define KHTTPTOOL_CHECKALLUSERMESSAGE_URL @"/queryUserInfo?"//查询用用户信息
#define KHTTPTOOL_MODIFYUSERMESSAGE_URL @"/updateUserInfo?"//修改信息
#define KHTTPTOOL_MODIFYSIGNATURE_URL @"/user/updateSignature?"//修改签名
#define KHTTPTOOL_MODIFYNIKENAME_URL @"/user/upnickName?"//修改昵称
#define KHTTPTOOL_MODIFYPASSWD_URL @"/auth/updatePassowrd?"//修改密码
#define KHTTPTOOL_FEEDBACKMESSAGE_URL @"/feedback/insertFeedback?"//反馈信息
#define KHTTPTOOL_INDEXPAGE_URL @"/loadData/index?" //获取首页信息接口
#define KHTTPTOOL_EXCEPTIONLOGIN_URL @"/auth/loginAuth?" //异地或不同设备登录
#define KHTTPTOOL_INTERNETPHONE_URL @"/mobile/queryMobile?" //网络电话充值卡获取

@implementation HttpTool

+(void)requestWithURL:(NSString*)URL HttpBody:(NSDictionary*)body HttpMethod:(NSString*)method success:(HttpSuccess)httpsuccess faile:(HttpFaile)httpfaile
{
    
    
//    if ([Utils judgeNetwork]) {
        NSString *urlstring = URL;
        
        NSMutableURLRequest*urlRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlstring] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval:3.0];
        
        NSData *bodyParamData=[NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *string=[[NSString alloc]initWithData:bodyParamData encoding:NSUTF8StringEncoding];
        
        bodyParamData=[string dataUsingEncoding:NSUTF8StringEncoding];
        
        [urlRequest setHTTPBody:bodyParamData];
        [urlRequest setHTTPMethod:@"POST"];
    
    

    
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError) {
                if (httpfaile){
                    httpfaile(connectionError);
                }
            }else {
                if (httpsuccess) {
                    //没有错误时，执行block回调，并且传入data
                    httpsuccess(data);
                }
            }
        }];
//    }else{
//        
//    }
    
}

+(void)postWithHttpBody:(NSDictionary *)body success:(HttpSuccess)httpsuccess fail:(HttpFaile)httpfaile
{
    [self requestWithURL:kHttpToolURL HttpBody:body HttpMethod:@"POST" success:httpsuccess faile:httpfaile];
    
}



#pragma mark -============================================新版post方法实现

#pragma mark modify by sifu
/**新版Post方式验证*/
+(void)postVerifyWithHttpBody:(NSDictionary *)body success:(HttpSuccess)httpSuccess fail:(HttpFaile)httpFail{
    [self requestVerify:KHTTPTOOL_VERIFY_URL andHttpBody:body andSucces:httpSuccess andFail:httpFail];
}

/**新版Post方式登录*/
+(void)postLoginWithHttpBody:(NSDictionary *)body success:(HttpSuccess)httpSuccess fail:(HttpFaile)httpFail{
    [self requestWithURL:KHTTPTOOL_LOGIN_URL andHttpBody:body andSucces:httpSuccess andFail:httpFail];
}

/**新版Post方式注册*/
+(void)postRegisterWithHttpBody:(NSDictionary *)body success:(HttpSuccess)httpSuccess fail:(HttpFaile)httpFail{
    [self requestWithURL:KHTTPTOOL_REGISTER_URL andHttpBody:body andSucces:httpSuccess andFail:httpFail];
}

/**新版Post方式退出登录*/
+(void)postLogoutWithHttpBody:(NSDictionary*)body success:(HttpSuccess)httpSuccess fail:(HttpFaile)httpFail{
    [self requestWithURL:KHTTPTOOL_LOGOUT_URL andHttpBody:body andSucces:httpSuccess andFail:httpFail];
}


/**新版Post方式异地登录*/
+(void)postExceptionLoginWithHttpBody:(NSDictionary*)body andSuccess:(HttpSuccess)httpSuccess andFail:(HttpFaile)httpFail{
    [self requestWithURL:KHTTPTOOL_EXCEPTIONLOGIN_URL andHttpBody:body andSucces:httpSuccess andFail:httpFail];
}


#pragma mark - 查询所有用户信息
+(void)postcheckAllUserMessageWithParameter:(NSDictionary*)dic success:(HttpSuccess)httpsuccess faile:(HttpFaile)httpfaile{

    [self requestWithURL:KHTTPTOOL_CHECKALLUSERMESSAGE_URL andHttpBody:dic andSucces:httpsuccess andFail:httpfaile];
}

#pragma mark - 统一修改用户信息
+(void)postModifyUserMessageWithParameter:(NSDictionary*)dic success:(HttpSuccess)httpsuccess faile:(HttpFaile)httpfaile{

    [self requestWithURL:KHTTPTOOL_MODIFYUSERMESSAGE_URL andHttpBody:dic andSucces:httpsuccess andFail:httpfaile];
    
}

#pragma mark - 修改昵称
+(void)postModifyNikeNameWithParameter:(NSDictionary*)dic success:(HttpSuccess)httpsuccess faile:(HttpFaile)httpfaile{
    
    [self requestWithURL:KHTTPTOOL_MODIFYNIKENAME_URL andHttpBody:dic andSucces:httpsuccess andFail:httpfaile];
}

#pragma mark - 修改签名
+(void)postModifySignatureWithParameter:(NSDictionary*)dic success:(HttpSuccess)httpsuccess faile:(HttpFaile)httpfaile{

    [self requestWithURL:KHTTPTOOL_MODIFYSIGNATURE_URL andHttpBody:dic andSucces:httpsuccess andFail:httpfaile];
}

#pragma mark - 修改密码
+(void)postModifyPasswdWithParameter:(NSDictionary*)dic success:(HttpSuccess)httpsuccess faile:(HttpFaile)httpfaile{

    [self requestWithURL:KHTTPTOOL_MODIFYPASSWD_URL andHttpBody:dic andSucces:httpsuccess andFail:httpfaile];
}

#pragma mark - 反馈信息
+(void)postFeedbackMessageWithParameter:(NSDictionary*)dic success:(HttpSuccess)httpsuccess faile:(HttpFaile)httpfaile
{
    [self requestWithURL:KHTTPTOOL_FEEDBACKMESSAGE_URL andHttpBody:dic andSucces:httpsuccess andFail:httpfaile];
}


#pragma mark - 网络电话充值卡获取
+(void)postInternetPhoneMessageWithParameter:(NSDictionary*)dic success:(HttpSuccess)httpsuccess faile:(HttpFaile)httpfaile{
    
    [self requestWithURL:KHTTPTOOL_INTERNETPHONE_URL andHttpBody:dic andSucces:httpsuccess andFail:httpfaile];
}

+(void)requestVerify:(NSString*)URL andHttpBody:(NSDictionary*)body andSucces:(HttpSuccess)httpSuccess andFail:(HttpFaile)httpFail{
    
#if USENEWURL
    NSString* urlString = [NSString stringWithFormat:@"http://192.168.1.111%@",URL];
#else
    NSString* urlString = [NSString stringWithFormat:@"http://jfinal.chcws.com%@",URL];
    
#endif
    
    
    
    
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3.0];
    NSString* paramString;
    if([body allKeys].count){
        NSMutableArray* tempArray = [NSMutableArray array];
        for (NSString* thyKey in [body allKeys]) {
            NSString* tempString = [NSString stringWithFormat:@"%@=%@",thyKey,[body valueForKey:thyKey]];
            [tempArray addObject:tempString];
        }
        if([body allKeys].count > 1){
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
            if(httpFail){
                httpFail(connectionError);
            }
        }else{
            if(httpSuccess){
                NSDictionary* rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                httpSuccess(rootDict);
                
            }
        }
    }];
}



+(void)requestWithURL:(NSString*)URL andHttpBody:(NSDictionary*)body andSucces:(HttpSuccess)httpSuccess andFail:(HttpFaile)httpFail{
    
#if USENEWURL
    NSString* urlString = [NSString stringWithFormat:@"http://192.168.1.111/app%@",URL];
#else
    NSString* urlString = [NSString stringWithFormat:@"http://jfinal.chcws.com/app%@",URL];
    
#endif
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    NSString* paramString;
    if([body allKeys].count){
        NSMutableArray* tempArray = [NSMutableArray array];
        for (NSString* thyKey in [body allKeys]) {
            NSString* tempString = [NSString stringWithFormat:@"%@=%@",thyKey,[body valueForKey:thyKey]];
            [tempArray addObject:tempString];
        }
        if([body allKeys].count > 1){
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
            if(httpFail){
                httpFail(connectionError);
            }
        }else{
            if(httpSuccess){
                NSDictionary* rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                httpSuccess(rootDict);
                
            }
        }
    }];
}






@end
