//
//  CWSPushMassageController.m
//  CarDefender
//
//  Created by 周子涵 on 15/6/4.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSPushMassageController.h"

@interface CWSPushMassageController ()

@end

@implementation CWSPushMassageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        
        UIUserNotificationType types = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
        if (types != UIUserNotificationTypeNone) {
            self.markLabel.text = @"已开启";
        }else{
            self.markLabel.text = @"未开启";
        }
        
    }else
    {
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (types != UIRemoteNotificationTypeNone) {
            self.markLabel.text = @"已开启";
        }else{
            self.markLabel.text = @"未开启";
        }
    }
    
    
    
}

@end
