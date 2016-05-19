//
//  CWSContactsController.h
//  CarDefender
//
//  Created by 李散 on 15/4/2.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "BaseViewController.h"

@interface CWSContactsController : BaseViewController
@property (strong, nonatomic) IBOutlet UIView *topTabelView;

//好友请求变化时，更新好友请求未处理的个数
- (void)reloadApplyView;

//群组变化时，更新群组页面
- (void)reloadGroupView;

//好友个数变化时，重新获取数据
- (void)reloadDataSource;

//添加好友的操作被触发
- (void)addFriendAction;
@end
