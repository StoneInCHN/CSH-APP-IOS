//
//  CWSPhoneWaitController.m
//  CarDefender
//
//  Created by 李散 on 15/5/7.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSPhoneWaitController.h"
#import "UIImageView+WebCache.h"
#define BACK_IMAGE_SAVE_NAME @"phoneWaitImg"
@interface CWSPhoneWaitController ()<UIAlertViewDelegate>

@end

@implementation CWSPhoneWaitController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    self.goOutPhoneNub.text=self.phoneDic[@"called"];
    self.userPhoneNub.text=self.phoneDic[@"user"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hidenSelfView:) name:@"phoneCallConnect" object:nil];
}
-(void)hidenSelfView:(NSNotification*)animated
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([LHPShaheObject checkPathIsOk:BACK_IMAGE_SAVE_NAME]) {
        NSMutableDictionary*dic=[NSMutableDictionary dictionaryWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:@"phoneWaitImg"]];
        [self.backImg setImageWithURL:[NSURL URLWithString:dic[@"name"]] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    NSArray*imgArray=@[[UIImage imageNamed:@"phone1@2x"],[UIImage imageNamed:@"phone2@2x"],[UIImage imageNamed:@"phone3@2x"],[UIImage imageNamed:@"phone4@2x"]];
    self.animateImg.animationImages=imgArray;
    self.animateImg.animationDuration=1;
    self.animateImg.animationRepeatCount=0;
    [self.animateImg startAnimating];
    
    KManager.currentController = @"CWSPhoneWaitController";
    [ModelTool httpGetCallParameter:@{@"uid":KUserManager.uid,@"called":self.phoneDic[@"called"]} success:^(id object) {
        MyLog(@"%@",object);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                NSString*imgUrl=object[@"data"][@"url"];
                [self.backImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://115.28.161.11:8080/ZL/%@",imgUrl]] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
                [LHPShaheObject saveAccountMsgWithName:BACK_IMAGE_SAVE_NAME andWithMsg:[NSMutableDictionary dictionaryWithDictionary:@{@"name":[NSString stringWithFormat:@"http://115.28.161.11:8080/ZL/%@",imgUrl]}]];
            }else{
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        });
    } faile:^(NSError *err) {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"呼叫失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}
#pragma mark 可以自由拉伸的图片
-(UIImage *)resizedImage:(UIImage *)image
{
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}
-(void)viewDidDisappear:(BOOL)animated
{
    KManager.currentController = @"";
}
- (IBAction)goBackClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
