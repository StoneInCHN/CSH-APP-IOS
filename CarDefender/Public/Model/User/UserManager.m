//
//  UserManager.m
//  云车宝项目
//
//  Created by sky on 14-9-17.
//  Copyright (c) 2014年 HCYunAPP. All rights reserved.
//

#import "UserManager.h"

static UserManager* shareUserManagerInfo;

@implementation UserManager
+(UserManager *)shareUserManagerInfo
{
    @synchronized(self){
        if (shareUserManagerInfo == nil) {
            shareUserManagerInfo = [[UserManager alloc] init];
        }
    }
    return shareUserManagerInfo;
}

#pragma mark - 初始化User
-(instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"getUser" object:nil];
    }
    return self;
}
#pragma mark - 初始化User的观察者方法
-(void)notification:(NSNotification *)sender
{
    [UserManager shareUserManagerInfo].user = sender.object;
}
@end
