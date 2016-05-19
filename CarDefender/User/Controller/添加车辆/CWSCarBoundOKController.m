//
//  CWSCarBoundOKController.m
//  CarDefender
//
//  Created by 李散 on 15/6/26.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSCarBoundOKController.h"
#import "CWSCarManageController.h"
@interface CWSCarBoundOKController ()

@end

@implementation CWSCarBoundOKController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils setViewRiders:self.boundBtn riders:4];
    [Utils changeBackBarButtonStyle:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];//隐藏
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];//取消隐藏
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)boundOKClick:(UIButton *)sender {
    
    if ([[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] isKindOfClass:[CWSCarManageController class]]) {
        CWSCarManageController* gjViewController = (CWSCarManageController* )[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3];
        gjViewController.backMsg = @"回来了";
        [self.navigationController popToViewController:gjViewController animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
@end
