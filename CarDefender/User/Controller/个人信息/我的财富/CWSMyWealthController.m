//
//  CWSMyWealthController.m
//  CarDefender
//
//  Created by 周子涵 on 15/6/2.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSMyWealthController.h"
#import "CWSWithdrawDepositController.h"
#import "CWSMyWealthDetailsController.h"
#import "CWSExplainIntegralController.h"
#import "CWSCarManageController.h"
@interface CWSMyWealthController ()
{
    BOOL navHiden;
    UIButton*btn;
}

@property (weak, nonatomic) IBOutlet UILabel *totleCost;
@property (weak, nonatomic) IBOutlet UILabel *payBackLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowLabel;
@property (weak, nonatomic) IBOutlet UILabel *canUseLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *groundView;

@end

@implementation CWSMyWealthController
-(void)getData{
    MyLog(@"calling-%@;total-%@;freeze-%@;cash-%@",KUserManager.account.calling,KUserManager.account.total,KUserManager.account.freeze,KUserManager.account.cash);
    self.totleCost.text = KUserManager.account.calling;
    self.payBackLabel.text = KUserManager.account.total;
    self.nowLabel.text = KUserManager.account.freeze;
    self.canUseLabel.text = KUserManager.account.cash;
//    self.payBackLabel.text = KUserManager.account
}
- (void)viewDidLoad {
    [super viewDidLoad];
    navHiden=YES;
//    self.title = @"我的财富";
    self.title = @"话费余额";
    [Utils changeBackBarButtonStyle:self];
    [self setUI];
    [self getData];
    [Utils setViewRiders:[self.view viewWithTag:4] riders:4];
}
-(void)setUI{
    [self.groundView setFrame:CGRectMake(0, 0, kSizeOfScreen.width, self.groundView.frame.size.height)];
    [self.scrollView addSubview:self.groundView];
    [self.scrollView setContentSize:CGSizeMake(0, self.groundView.frame.size.height)];
}
- (IBAction)btnClick:(UIButton *)sender {
    navHiden=NO;
    switch (sender.tag) {
        case 1:
        {
            MyLog(@"话费说明");
            CWSExplainIntegralController* lController = [[CWSExplainIntegralController alloc] init];
            lController.title = @"话费说明";
            lController.type = @"huafei";
            [self.navigationController pushViewController:lController animated:YES];
        }
            break;
        case 2:
        {
            MyLog(@"余额查看详情");
            CWSMyWealthDetailsController* lController = [[CWSMyWealthDetailsController alloc] init];
            lController.title = @"话费详情";
            lController.type = @"call";
            [self.navigationController pushViewController:lController animated:YES];
        }
            break;
        case 3:
        {
            MyLog(@"返费查看详情");
            CWSMyWealthDetailsController* lController = [[CWSMyWealthDetailsController alloc] init];
            lController.title = @"返费详情";
            lController.type = @"fee";
            [self.navigationController pushViewController:lController animated:YES];
        }
            break;
        case 4:
        {
            MyLog(@"我要提现");
            CWSWithdrawDepositController* lController = [[CWSWithdrawDepositController alloc] initWithNibName:@"CWSWithdrawDepositController" bundle:nil];
            lController.title = @"提现";
            [self.navigationController pushViewController:lController animated:YES];
        }
            break;
        case 5:
        {
            MyLog(@"返费说明");
            CWSExplainIntegralController* lController = [[CWSExplainIntegralController alloc] init];
            lController.title = @"返费说明";
            lController.type = @"fanfei";
            [self.navigationController pushViewController:lController animated:YES];
        }
            break;
        default:
            break;
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    if (btn) {
        [btn removeFromSuperview];
    }
    [self.navigationController.view addSubview:btn];
    if ([self.managerGoHere isEqualToString:@"managerComeHere"]) {
        if (!navHiden) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }else
            [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    [ModelTool stopAllOperation];
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([self.managerGoHere isEqualToString:@"managerComeHere"]) {
        if (btn==nil) {
            btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, 90, 44)];
            btn.backgroundColor=[UIColor clearColor];
            //判断是否放弃编辑
            [btn addTarget:self action:@selector(goBackEvent:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.navigationController.view addSubview:btn];
    }
}
-(void)goBackEvent:(UIButton*)sender
{
    if ([[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 4] isKindOfClass:[CWSCarManageController class]]) {
        CWSCarManageController *carManager = (CWSCarManageController *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 4];
        carManager.chooseCostOK = @"chooseOK";
        [self.navigationController popToViewController:carManager animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
@end
