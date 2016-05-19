//
//  OrderConfirmView.m
//  CarDefender
//
//  Created by 万茜 on 15/11/25.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "OrderConfirmView.h"
#import "CWSSituationInstructionsController.h"
#import "ModelTool.h"
#import "MBProgressHUD.h"

@interface OrderConfirmView()
{
    NSDictionary *dataDic;
}
@property (nonatomic,strong)UIViewController *viewController;
@property (weak, nonatomic) IBOutlet UIButton *alreadyWashButton;
@property (weak, nonatomic) IBOutlet UIButton *notWashButton;
- (IBAction)alreadyWashButtonPressed:(UIButton *)sender;
- (IBAction)notWashButtonPressed:(UIButton *)sender;

@end

@implementation OrderConfirmView


-(instancetype)initWithFrame:(CGRect)frame controller:(UIViewController *)controller data:(NSDictionary *)dic{

    self = [[NSBundle mainBundle] loadNibNamed:@"OrderConfirmView" owner:self options:nil][0];
    self.frame = frame;
    self.viewController = controller;
    dataDic = [dic mutableCopy];
    
    //背景
    UIView *backgroundView = (UIView *)[self viewWithTag:210];
    backgroundView.alpha = 0.5;
    
    UIView *view = (UIView *)[self viewWithTag:200];
    [self bringSubviewToFront:view];
    
    self.alreadyWashButton.clipsToBounds = YES;
    self.notWashButton.clipsToBounds = YES;
    self.alreadyWashButton.layer.cornerRadius = 5;
    self.notWashButton.layer.cornerRadius = 5;
    

    return self;
}

#pragma mark  - 已经洗车

- (IBAction)alreadyWashButtonPressed:(UIButton *)sender {
    NSDictionary *dict = @{@"uid":dataDic[@"uid"],
                           @"key":dataDic[@"key"],
                           @"uno":dataDic[@"uno"],
                           };
    [self.delegate alreadyWash:dict];
//    [MBProgressHUD showMessag:@"正在加载..." toView:self];
//    NSDictionary *dict = @{@"uid":dataDic[@"uid"],
//                          @"key":dataDic[@"key"],
//                          @"uno":dataDic[@"uno"],
//                          };
//    [ModelTool httpAppGainConfirmOrderWithParameter:dict success:^(id object) {
//        NSDictionary* dic = object;
//        MyLog(@"%@",dic);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if ([object[@"operationState"] isEqualToString:@"SUCCESS"] && [object[@"data"][@"msg"] isEqualToString:@"确认成功！"]) {
////                [self.delegate alreadyWash:YES];
//                NSDictionary *info = @{@"tag":@"yes"};
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil userInfo:info];
//                [self removeFromSuperview];
//            
//            }
//            else {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                [alert show];
//            }
//        });
//        [MBProgressHUD hideAllHUDsForView:self animated:YES];
//    } faile:^(NSError *err) {
//        [MBProgressHUD hideAllHUDsForView:self animated:YES];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:err.localizedDescription delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alert show];
//    }];
    
    
}

#pragma mark -  未洗车
- (IBAction)notWashButtonPressed:(UIButton *)sender {
    CWSSituationInstructionsController *vc = [[CWSSituationInstructionsController alloc] init];
    vc.dataDic = dataDic;
    [self.viewController.navigationController pushViewController:vc animated:YES];
    
}





@end
