//
//  MyJPushService.m
//  CarDefender
//
//  Created by 王泰莅 on 16/1/12.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "MyJPushService.h"



@implementation MyJPushService

/**应用启动调用(同时实现registerForRemoteNotificationTypes方法)*/
+(void)setupWithOption:(NSDictionary *)launchingOption{

    if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0){
    
        // 可以添加自定义categories
        
//        UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
//        
//        category.identifier = @"identifier";
//        
//        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
//        
//        action.identifier = @"test2";
//        
//        action.title = @"test";
//        
//        action.activationMode = UIUserNotificationActivationModeBackground;
//        
//        action.authenticationRequired = YES;
//        
//        //YES显示为红色，NO显示为蓝色
//        action.destructive = NO;
//        
//        NSArray *actions = @[ action ];
//        
//        [category setActions:actions forContext:UIUserNotificationActionContextMinimal];
        
        //        //设置消息类型
        //        UIMutableUserNotificationAction* action1 = [[UIMutableUserNotificationAction alloc]init];
        //        action1.identifier = @"action1_identifier";
        //        action1.title = @"Accept";
        //        action1.activationMode = UIUserNotificationActivationModeForeground; //当点击的时候启动程序
        //
        //        UIMutableUserNotificationAction* action2 = [[UIMutableUserNotificationAction alloc]init];
        //        action2.identifier = @"action2_identifier";
        //        action2.title = @"Reject";
        //        action2.activationMode = UIUserNotificationActivationModeBackground; //点击时候不启动程序，在后台运行
        //        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        //        action2.destructive = NO;
        //
        //        UIMutableUserNotificationCategory* categorys = [[UIMutableUserNotificationCategory alloc]init];
        //        categorys.identifier = @"category1";
        //        [categorys setActions:@[action1,action2] forContext:UIUserNotificationActionContextDefault];
        
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    }else{
        //categories必须为空
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
    }
    
    [APService setupWithOption:launchingOption];
    
    return;
}

/**appdelegate注册设备调用*/
+(void)registerDeviceToken:(NSData *)deviceToken{
    
    [APService registerDeviceToken:deviceToken];
    return;
}

/**ios7以后才有completion，否则传nil*/
+(void)handleRemoteNotification:(NSDictionary *)userInfo completion:(void (^)(UIBackgroundFetchResult))completion{

    [APService handleRemoteNotification:userInfo];
    if(completion){
        completion(UIBackgroundFetchResultNewData);
    }
    return;
}

/**显示本地通知在最前面*/
+(void)showLocalNotificationAtFront:(UILocalNotification *)notification{

    [APService showLocalNotificationAtFront:notification identifierKey:nil];
    
    return;
}

/**设置别名*/
+(void)setupWithAlias:(NSString*)alias andCallBackSelector:(SEL)callBack andTarget:(id)thyTarget{
    
    [APService setAlias:alias callbackSelector:callBack object:thyTarget];
    
    return;
}

/**设置标签*/
+(void)setupWithTag:(NSSet*)tags andCallBackSelector:(SEL)callBack andTarget:(id)thyTarget{
    
    [APService setTags:tags callbackSelector:callBack object:thyTarget];
    
    return;
}

/**设置消息红点个数*/
+(BOOL)setBadge:(int)value{
    return [APService setBadge:value];
}

/**清空消息个数*/
+(void)resetBadge{
    [APService resetBadge];
}

@end
