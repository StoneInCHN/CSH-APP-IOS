//
//  MyJPushService.m
//  CarDefender
//
//  Created by 王泰莅 on 16/1/12.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "MyJPushService.h"
#import <AdSupport/AdSupport.h>

static NSString *appKey = @"37ada1a7a6d7a3b77cde69b8";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;
@implementation MyJPushService

/**应用启动调用(同时实现registerForRemoteNotificationTypes方法)*/
+(void)setupWithOption:(NSDictionary *)launchingOption{
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    //Required
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchingOption appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    
    return;
}

/**appdelegate注册设备调用*/
+(void)registerDeviceToken:(NSData *)deviceToken{
    
    [JPUSHService registerDeviceToken:deviceToken];
    return;
}

/**ios7以后才有completion，否则传nil*/
+(void)handleRemoteNotification:(NSDictionary *)userInfo completion:(void (^)(UIBackgroundFetchResult))completion{

    [JPUSHService handleRemoteNotification:userInfo];
    if(completion){
        completion(UIBackgroundFetchResultNewData);
    }
    return;
}

/**显示本地通知在最前面*/
+(void)showLocalNotificationAtFront:(UILocalNotification *)notification{

    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
    
    return;
}

/**设置别名*/
+(void)setupWithAlias:(NSString*)alias andCallBackSelector:(SEL)callBack andTarget:(id)thyTarget{
    
    [JPUSHService setAlias:alias callbackSelector:callBack object:thyTarget];
    
    return;
}

/**设置标签*/
+(void)setupWithTag:(NSSet*)tags andCallBackSelector:(SEL)callBack andTarget:(id)thyTarget{
    
    [JPUSHService setTags:tags callbackSelector:callBack object:thyTarget];
    
    return;
}

/**设置消息红点个数*/
+(BOOL)setBadge:(int)value{
    return [JPUSHService setBadge:value];
}

/**清空消息个数*/
+(void)resetBadge{
    [JPUSHService resetBadge];
}

@end
