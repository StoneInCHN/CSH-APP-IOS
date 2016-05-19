//
//  CWSMalfunctionController.m
//  CarDefender
//  故障详情
//  Created by 周子涵 on 15/7/1.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSMalfunctionController.h"
#import "CWSRepairController.h"

@interface CWSMalfunctionController ()
{
    UIScrollView* _scrollView;
    __weak IBOutlet UILabel *malfunctionNumberLabel;
    __weak IBOutlet UIView *headView;
}
@end

@implementation CWSMalfunctionController
-(void)getData{
    malfunctionNumberLabel.text = self.dataDic[@"name"];
    [Utils setBianKuang:kCOLOR(229, 229, 229) Wide:1 view:headView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"故障详情";
    [Utils changeBackBarButtonStyle:self];
    [self getData];
    [self creatUI];
}
-(void)creatUI{
    MyLog(@"%@",self.dataDic);
    CGSize size = [Utils takeTheSizeOfString:self.dataDic[@"describe"] withFont:kFontOfSize(16) withWeight:kSizeOfScreen.width - 112];
    UIView* groundView = [[UIView alloc] initWithFrame:CGRectMake(-1, 64, kSizeOfScreen.width + 2, size.height + 28)];
    groundView.backgroundColor = [UIColor whiteColor];
    [Utils setBianKuang:kCOLOR(229, 229, 229) Wide:1 view:groundView];
    [self.view addSubview:groundView];
    UILabel* nameLabel = [Utils labelWithFrame:CGRectMake(11, 15, 64, 16) withTitle:@"故障解释" titleFontSize:kFontOfSize(16) textColor:kCOLOR(60, 152, 247) alignment:NSTextAlignmentLeft];
    [groundView addSubview:nameLabel];
    
    UILabel* destrictLabel = [Utils labelWithFrame:CGRectMake(101, 14, size.width, size.height) withTitle:self.dataDic[@"describe"] titleFontSize:kFontOfSize(16) textColor:KBlackMainColor alignment:NSTextAlignmentLeft];
    destrictLabel.numberOfLines = 0;
    [groundView addSubview:destrictLabel];
    
    UIButton* btn = [Utils buttonWithFrame:CGRectMake(-1, groundView.frame.origin.y + groundView.frame.size.height + 50, kSizeOfScreen.width + 2, 44) title:@"联系专家解决故障" titleColor:kCOLOR(60, 152, 247) font:kFontOfSize(16)];
    btn.backgroundColor = [UIColor whiteColor];
    [Utils setBianKuang:kCOLOR(229, 229, 229) Wide:1 view:btn];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
-(void)btnClick{
    MyLog(@"解决问题");
    if (KManager.currentCity != nil) {
        CWSRepairController* lController = [[CWSRepairController alloc] init];
        lController.title = @"维修保养";
        lController.cityString = KManager.currentCity;
        lController.keyWords=@"汽车维修";
        [self.navigationController pushViewController:lController animated:YES];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"未获取到您当前城市" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}
@end
