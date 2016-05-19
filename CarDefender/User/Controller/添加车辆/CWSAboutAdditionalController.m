//
//  CWSAboutAdditionalController.m
//  CarDefender
//
//  Created by 李散 on 15/5/7.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSAboutAdditionalController.h"

@interface CWSAboutAdditionalController ()<UIAlertViewDelegate>

@end

@implementation CWSAboutAdditionalController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.title=@"关于附加项";
    [Utils changeBackBarButtonStyle:self];
    [Utils setViewRiders:self.pointOne riders:4];
    [Utils setViewRiders:self.pointTwo riders:4];
    [Utils setViewRiders:self.pointThree riders:4];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToWeb:(UIButton *)sender {
    if (sender.tag==1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.chcws.com"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=Network"]];
    }else if (sender.tag==2){
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"联系客服" message:@"拨打4007930888以获取客服支持，您确认要拨打吗？" delegate:self cancelButtonTitle:@"拨打客服" otherButtonTitles:@"取消", nil];
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"4007930888"]]];
    }
}
@end
