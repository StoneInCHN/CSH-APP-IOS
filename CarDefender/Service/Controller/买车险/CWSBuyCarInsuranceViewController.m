//
//  CWSBuyCarInsuranceViewController.m
//  CarDefender
//
//  Created by 万茜 on 15/12/7.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSBuyCarInsuranceViewController.h"
#import "CWSImmediatelyUploadViewController.h"
#import "CWSTryCalculateViewController.h"
#import "CWSCarManageController.h"

@interface CWSBuyCarInsuranceViewController ()<UIAlertViewDelegate>
{
    NSDictionary *carDic;
}
@end

@implementation CWSBuyCarInsuranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"车险";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [Utils changeBackBarButtonStyle:self];
    [self getData];
    [self initalizeUserInterface];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCarNotification:) name:@"changeCar" object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeCar" object:nil];
}

#pragma mark - 监听
- (void)changeCarNotification:(NSNotification *)info
{
    carDic = [[NSDictionary alloc] initWithDictionary:info.userInfo];
    MyLog(@"carDic--------------%@",carDic);
    [self initalizeUserInterface];
    [self changeCarUI];

}

- (void)changeCarUI
{
    if (carDic != nil) {
        self.carLabel.text = carDic[@"plate"];
        self.insuredCityLabel.text = [NSString stringWithFormat:@"投保城市:%@",KManager.currentCity];
        self.brandCarsLabel.text = [NSString stringWithFormat:@"品牌车系:%@-%@",carDic[@"brand"][@"brandName"],carDic[@"brand"][@"seriesName"]];
        self.insuredCarLabel.text = [NSString stringWithFormat:@"投保车辆:%@",carDic[@"plate"]];
        self.carModelsLabel.text = [NSString stringWithFormat:@"车型:%@",carDic[@"brand"][@"moduleName"]];
    }
    
}

#pragma mark - 数据
- (void)getData
{

}

#pragma mark - 界面
- (void)initalizeUserInterface
{
    //未上传行驶证
    self.notCardLabel = (UILabel *)[self.view viewWithTag:1];
    
    //车辆
    self.carLabel = (UILabel *)[self.view viewWithTag:2];
    self.carLabel.text = KUserManager.userDefaultVehicle[@"plate"];
    
    //立即上传
    self.immediatelyUploadButton = (UIButton *)[self.view viewWithTag:3];
    self.immediatelyUploadButton.layer.cornerRadius = 5;
    self.immediatelyUploadButton.layer.borderWidth = 1.0;
    self.immediatelyUploadButton.layer.borderColor = [UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1].CGColor;
    [self.immediatelyUploadButton addTarget:self action:@selector(immediatelyUploadButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //切换车辆
    self.changeCarButton = (UIButton *)[self.view viewWithTag:4];
    [self.changeCarButton addTarget:self action:@selector(changeCarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //投保城市
    self.insuredCityLabel = (UILabel *)[self.view viewWithTag:5];
    self.insuredCityLabel.text = [NSString stringWithFormat:@"投保城市:%@",KManager.currentCity];
    
    //品牌车系
    self.brandCarsLabel = (UILabel *)[self.view viewWithTag:6];
//    self.brandCarsLabel.text = [NSString stringWithFormat:@"品牌车系:%@-%@",KUserManager.car.brand,KUserManager.car.brandName];
    self.brandCarsLabel.text = [NSString stringWithFormat:@"品牌车系:%@-%@",KUserManager.userDefaultVehicle[@"brand"][@"brandName"],KUserManager.userDefaultVehicle[@"brand"][@"seriesName"]];
    
    //投保车辆
    self.insuredCarLabel = (UILabel *)[self.view viewWithTag:7];
//    self.insuredCarLabel.text = [NSString stringWithFormat:@"投保车辆:%@",KUserManager.car.plate];
    self.insuredCarLabel.text = [NSString stringWithFormat:@"投保车辆:%@",KUserManager.userDefaultVehicle[@"plate"]];
    //车型
    self.carModelsLabel = (UILabel *)[self.view viewWithTag:8];
//    self.carModelsLabel.text = [NSString stringWithFormat:@"车型:%@",KUserManager.car.module];
    self.carModelsLabel.text = [NSString stringWithFormat:@"车型:%@",KUserManager.userDefaultVehicle[@"brand"][@"moduleName"]];
    
    //试算
    self.tryCalculateButton = (UIButton *)[self.view viewWithTag:9];
    [self.tryCalculateButton addTarget:self action:@selector(tryCalculateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

#pragma mark - 立即上传
- (void)immediatelyUploadButtonPressed:(UIButton *)sender
{
//    CWSImmediatelyUploadViewController *vc = [[CWSImmediatelyUploadViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 切换车辆
- (void)changeCarButtonPressed:(UIButton *)sender
{
    CWSCarManageController* lController = [[CWSCarManageController alloc] init];
    lController.tag = 1;
    [self.navigationController pushViewController:lController animated:YES];
}

#pragma mark - 试算
- (void)tryCalculateButtonPressed:(UIButton *)sender
{
//    CWSTryCalculateViewController *vc = [[CWSTryCalculateViewController alloc] init];
//    
//    [self.navigationController pushViewController:vc animated:YES];
    
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"联系客服4007930888" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
    
    [alert show];
}

#pragma mark - <UIAlertViewDelegate>
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){//拨打
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"4007930888"]]];
        ;
    }
}

@end
