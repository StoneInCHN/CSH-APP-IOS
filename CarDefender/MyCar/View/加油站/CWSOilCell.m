//
//  CWSOilCell.m
//  CarDefender
//
//  Created by 周子涵 on 15/5/8.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSOilCell.h"

@implementation CWSOilCell

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)btnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            MyLog(@"电话");
            if ([self.tel isEqualToString:@""]) {
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"暂无电话信息" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
            else {
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"拨号:" message:self.tel delegate:self cancelButtonTitle:@"拨打" otherButtonTitles:@"取消", nil];
                alert.tag=99;
                [alert show];
            }
            
        }
            break;
        case 2:
        {
            NSLog(@"--------------%@%@",self.lat,self.lon);
//            if (self.lat.length == 0 || self.lon.length == 0) {
//                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"暂无导航信息" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
//            }else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"parkGoNav" object:@{@"lat":self.lat,@"lon":self.lon}];
                MyLog(@"到这去%@-%@",self.lat,self.lon);
//            }
            
        }
            break;
            
        default:
            break;
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==99) {
        if(buttonIndex==0){//拨打
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.tel]]];
        }
    }
}
@end
