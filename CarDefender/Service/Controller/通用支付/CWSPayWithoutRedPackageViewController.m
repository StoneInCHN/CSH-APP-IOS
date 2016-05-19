//
//  CWSPayWithoutRedPackageViewController.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/14.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSPayWithoutRedPackageViewController.h"
#import "CWSPaySuccessViewController.h"

#import "CWSPayInfoView.h"
@interface CWSPayWithoutRedPackageViewController (){

    UILabel* totalCountLabel;
    
}

@end

@implementation CWSPayWithoutRedPackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"支付";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = KGrayColor3;
    
    
    
    [self createUI];
}


#pragma mark -=============================InitialData



#pragma mark -=============================CreateUI
-(void)createUI{
    
    CWSPayInfoView* payInfoView = [[[NSBundle mainBundle]loadNibNamed:@"CWSPayInfoView" owner:self options:nil] lastObject];
    payInfoView.validPeriodView.hidden = NO;
    payInfoView.frame = CGRectMake(0, 0, kSizeOfScreen.width, 193);
    [self.view addSubview:payInfoView];
    
    
    //红包抵用选择
    UIView* redPackageUsedView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(payInfoView.frame), kSizeOfScreen.width, 60)];
    redPackageUsedView.backgroundColor = KGrayColor3;
    [self.view addSubview:redPackageUsedView];
    
    UIView* selectedRedPackageView = [[UIView alloc]initWithFrame:CGRectMake(0, 15, kSizeOfScreen.width, 45)];
    selectedRedPackageView.backgroundColor = [UIColor whiteColor];
    [redPackageUsedView addSubview:selectedRedPackageView];
    
    UILabel* redLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 18, kSizeOfScreen.width, 15)];
    redLabel.textColor = KRedColor;
    redLabel.font = [UIFont systemFontOfSize:14.0f];
    redLabel.textAlignment = NSTextAlignmentLeft;
    redLabel.text = @"可使用红包抵用16元";
    [selectedRedPackageView addSubview:redLabel];
    
    UISwitch* redSwitch = [[UISwitch alloc]init];
    redSwitch.frame = CGRectMake(kSizeOfScreen.width-10-redSwitch.size.width, 10, redSwitch.size.width, redSwitch.size.height);
    redSwitch.on = YES;
    [redSwitch addTarget:self action:@selector(redSwitchClicked:) forControlEvents:UIControlEventValueChanged];
    [selectedRedPackageView addSubview:redSwitch];
    
    
    //合计确认
    UIView* totalCountView = [[UIView alloc]initWithFrame:CGRectMake(0, kSizeOfScreen.height-kDockHeight-45, kSizeOfScreen.width, 45)];
    totalCountView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:totalCountView];
    
    UIButton* comfimButton = [UIButton buttonWithType:UIButtonTypeCustom];
    comfimButton.frame = CGRectMake(kSizeOfScreen.width-88, 0, 88, 45);
    comfimButton.backgroundColor = KBlueColor;
    comfimButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [comfimButton setTitle:@"确认" forState:UIControlStateNormal];
    [comfimButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [comfimButton addTarget:self action:@selector(comfimButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [totalCountView addSubview:comfimButton];
    
    UILabel* totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, 30, 15)];
    totalLabel.font = [UIFont systemFontOfSize:15.0f];
    totalLabel.text = @"合计:";
    totalLabel.textAlignment = NSTextAlignmentLeft;
    [totalCountView addSubview:totalLabel];
    [totalLabel sizeToFit];
    
    totalCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(totalLabel.frame), 15, kSizeOfScreen.width, 15)];
    totalCountLabel.font = [UIFont systemFontOfSize:14.0f];
    totalCountLabel.textColor = KRedColor;
    totalCountLabel.text = @"￥0.00";
    totalCountLabel.textAlignment = NSTextAlignmentLeft;
    [totalCountView addSubview:totalCountLabel];

    
}


#pragma mark -=============================OtherCallBack

/**红包抵用按钮*/
-(void)redSwitchClicked:(UISwitch*)sender{
    if(sender.on){
    
        totalCountLabel.text = [NSString stringWithFormat:@"￥%@",@"0.00"];
    
    }else{
    
        totalCountLabel.text = [NSString stringWithFormat:@"￥%@",@"16.00"];
    }
    NSLog(@"%d",sender.on);
}

/**确认订单按钮*/
-(void)comfimButtonClicked:(UIButton*)sender{
    
    NSLog(@"确认");
    
    CWSPaySuccessViewController* paySucVc = [CWSPaySuccessViewController new];
    [self.navigationController pushViewController:paySucVc animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
