//
//  MyJPushService.h
//  CarDefender
//
//  Created by 王泰莅 on 16/1/12.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "APService.h"
@interface MyJPushService : NSObject


#pragma mark -==================================================================必选项
/**应用启动调用(同时实现registerForRemoteNotificationTypes方法)*/
+(void)setupWithOption:(NSDictionary *)launchingOption;

/**appdelegate注册设备调用*/
+(void)registerDeviceToken:(NSData *)deviceToken;

/**ios7以后才有completion，否则传nil*/
+(void)handleRemoteNotification:(NSDictionary *)userInfo completion:(void (^)(UIBackgroundFetchResult))completion;

/**显示本地通知在最前面*/
+(void)showLocalNotificationAtFront:(UILocalNotification *)notification;


#pragma mark -==================================================================可选项
/**设置别名*/
+(void)setupWithAlias:(NSString*)alias andCallBackSelector:(SEL)callBack andTarget:(id)thyTarget;

/**设置标签*/
+(void)setupWithTag:(NSSet*)tags andCallBackSelector:(SEL)callBack andTarget:(id)thyTarget;

/**设置消息红点个数*/
+(BOOL)setBadge:(int)value;

/**清空消息个数*/
+(void)resetBadge;

@end
