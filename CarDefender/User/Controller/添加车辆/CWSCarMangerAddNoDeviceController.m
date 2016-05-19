//
//  CWSCarMangerAddNoDeviceController.m
//  CarDefender
//
//  Created by pan on 15/6/7.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSCarMangerAddNoDeviceController.h"
#import "CWSCarManageController.h"
#import "CWSAddCarController.h"
@interface CWSCarMangerAddNoDeviceController ()

@end

@implementation CWSCarMangerAddNoDeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    [Utils setViewRiders:self.goLookBtn riders:4];
    [Utils setViewRiders:self.goBackBtn riders:4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBtn:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1://前往完善
        {
            if ([[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2]isKindOfClass:[CWSAddCarController class]]) {
                CWSAddCarController *addCar = (CWSAddCarController *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
                addCar.noDeviceComeBackEdit = @"回来了";
                addCar.title = @"编辑车辆";
                [self.navigationController popToViewController:addCar animated:YES];
            }
        }
            break;
        case 2://返回
        {
            if ([[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3]isKindOfClass:[CWSCarManageController class]]) {
                CWSCarManageController *addCar = (CWSCarManageController *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3];
                addCar.chooseCostOK = @"chooseOK";
                [self.navigationController popToViewController:addCar animated:YES];
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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [ModelTool stopAllOperation];
}
@end
