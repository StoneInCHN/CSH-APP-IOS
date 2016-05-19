//
//  CWSCarMangerChooseOKController.m
//  CarDefender
//
//  Created by 李散 on 15/6/6.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSCarMangerChooseOKController.h"
#import "CWSCarManageController.h"
#import "CWSMyWealthController.h"
@interface CWSCarMangerChooseOKController ()

@end

@implementation CWSCarMangerChooseOKController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    [Utils setViewRiders:self.goLook riders:4];
    [Utils setViewRiders:self.goBack riders:4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)clickBtn:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            CWSMyWealthController*wealthVC=[[CWSMyWealthController alloc]initWithNibName:@"CWSMyWealthController" bundle:nil];
            wealthVC.managerGoHere=@"managerComeHere";
            [self.navigationController pushViewController:wealthVC animated:YES];
        }
            break;
        case 2:
        {
            if ([[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 4] isKindOfClass:[CWSCarManageController class]]) {
                CWSCarManageController*carManager = (CWSCarManageController *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 4];
                carManager.chooseCostOK=@"chooseOK";
//                carManager.title = @"编辑车辆";
                [self.navigationController popToViewController:carManager animated:YES];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
            break;
        default:
            break;
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [ModelTool stopAllOperation];
}
@end
