//
//  CWSAboutUsController.m
//  CarDefender
//
//  Created by 周子涵 on 15/4/29.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSAboutUsController.h"

#import "CWSWebController.h"

@interface CWSAboutUsController ()<UIAlertViewDelegate>

@end

@implementation CWSAboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    self.webButton = (UIButton *)[self.view viewWithTag:1];
    [self.webButton addTarget:self action:@selector(webButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.phoneButton = (UIButton *)[self.view viewWithTag:2];
    [self.phoneButton addTarget:self action:@selector(phoneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - webButtonPressed
- (void)webButtonPressed:(UIButton *)sender
{
//    CWSWebController* lController = [[CWSWebController alloc] init];
//    lController.title = @"官网";
//    [self.navigationController pushViewController:lController animated:YES];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.chcws.com"]];
}


#pragma mark -phoneButtonPressed
- (void)phoneButtonPressed:(UIButton *)sender
{
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"联系客服" message:@"拨打4007930888以获取客服支持，您确认要拨打吗？" delegate:self cancelButtonTitle:@"拨打客服" otherButtonTitles:@"取消", nil];
    alert.delegate = self;
    [alert show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"4007930888"]]];
    }
}

@end
