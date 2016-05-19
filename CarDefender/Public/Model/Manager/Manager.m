//
//  Manager.m
//  CarDefender
//
//  Created by 周子涵 on 15/4/16.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "Manager.h"

static Manager* shareManagerInfo;
@implementation Manager
+(Manager *)shareManagerInfo
{
    @synchronized(self){
        if (shareManagerInfo == nil) {
            shareManagerInfo = [[Manager alloc] init];
        }
    }
    return shareManagerInfo;
}

#pragma mark - 初始化User
-(instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"getManager" object:nil];
    }
    return self;
}
#pragma mark - 初始化User的观察者方法
-(void)notification:(NSNotification *)sender
{
    NSDictionary* dic = sender.object;
    [Manager shareManagerInfo].lat = dic[@"lat"];
    [Manager shareManagerInfo].lng = dic[@"lng"];
}
@end
