//
//  CWSCheckMessageCenterDetailViewController.m
//  CarDefender
//
//  Created by 万茜 on 16/1/12.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "CWSCheckMessageCenterDetailViewController.h"

@interface CWSCheckMessageCenterDetailViewController ()

@end

@implementation CWSCheckMessageCenterDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _messageTextView.editable = NO;
    _messageTextView.text = self.messageContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看消息";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    
//    [self initalizeUserInterface];
}

- (void)initalizeUserInterface
{
    
}

@end
