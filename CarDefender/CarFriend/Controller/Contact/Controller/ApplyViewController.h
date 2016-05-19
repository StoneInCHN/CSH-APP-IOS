/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  * 好友申请界面，申请与通知界面
  */

#import <UIKit/UIKit.h>

typedef enum{
    ApplyStyleFriend            = 0, //好友申请
    ApplyStyleGroupInvitation,  //组队邀请
    ApplyStyleJoinGroup,   //加入圈子
}ApplyStyle;

@interface ApplyViewController : UITableViewController
{
    NSMutableArray *_dataSource;
}

@property (strong, nonatomic, readonly) NSMutableArray *dataSource;

+ (instancetype)shareController;

- (void)addNewApply:(NSDictionary *)dictionary;
//获取数据
- (void)loadDataSourceFromLocalDB;

- (void)clear;

@end
