//
//  CWSPaySuccessViewController.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/14.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSPaySuccessViewController.h"

#import "CWSPaySuccessInfoView.h"

#import "CWSCarWashDetileController.h"
@interface CWSPaySuccessViewController (){

  
}

@end

@implementation CWSPaySuccessViewController

//-(void)viewWillAppear:(BOOL)animated{
//
//    [super viewWillAppear:animated];
//    [paySuccessInfoVc setDataDict:self.dataDict];
//    
//    
//}



- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    self.title = @"支付成功";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [PublicUtils changeBackBarButtonStyle:self];
    
    CWSPaySuccessInfoView* paySuccessInfoVc = [[CWSPaySuccessInfoView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 160) Data:self.dataDict];
//    [paySuccessInfoVc setDataDict:self.dataDict];
    
    
    
//    paySuccessInfoVc.frame = CGRectMake(0, 0, kSizeOfScreen.width, 160);
    [self.view addSubview:paySuccessInfoVc];
    
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(paySuccessInfoVc.frame)+5, kSizeOfScreen.width, 1)];
    lineView.backgroundColor = KGrayColor2;
    [self.view addSubview:lineView];
    
    UIButton* comfimButton = [UIButton buttonWithType:UIButtonTypeCustom];
    comfimButton.frame = CGRectMake((kSizeOfScreen.width-145)/2, CGRectGetMaxY(paySuccessInfoVc.frame)+30, 145, 45);
    comfimButton.layer.masksToBounds = YES;
    comfimButton.layer.borderColor = KBlueColor.CGColor;
    comfimButton.layer.borderWidth = 1.0f;
    comfimButton.layer.cornerRadius = 5.0f;
    [comfimButton setTitle:@"查看详情" forState:UIControlStateNormal];
    [comfimButton setTitleColor:KBlueColor forState:UIControlStateNormal];
    [comfimButton addTarget:self action:@selector(comfimButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:comfimButton];
    
    
}


#pragma mark -========================================OtherCallBack
-(void)comfimButtonClicked:(UIButton*)sender{

    CWSCarWashDetileController* detailVc = [CWSCarWashDetileController new];
    [detailVc setDataDict:self.dataDict];
    detailVc.tag = 1;
    [self.navigationController pushViewController:detailVc animated:YES];
}

-(void)backClicked:(UIBarButtonItem*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
