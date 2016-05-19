//
//  CWChatListController.h
//  CarDefender
//
//  Created by 李散 on 15/4/2.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "BaseViewController.h"

@interface CWChatListController : BaseViewController

- (void)refreshDataSource;

- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)connectionState;
@end
