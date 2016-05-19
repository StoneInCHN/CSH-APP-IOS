//
//  WQAler.m
//  chlidfios
//
//  Created by 万茜 on 15/8/6.
//  Copyright (c) 2015年 万茜. All rights reserved.
//

#import "WQAler.h"
#import "MBProgressHUD.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@implementation WQAler
+(void)Show:(NSString *)messageStr{
    WQAler *aler=[[WQAler alloc]init];
    aler.alerView=[[UIAlertView alloc]initWithTitle:nil message:messageStr delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [aler.alerView show];
    //0.7秒后执行 （一次性）
    double delayInSeconds = 0.7;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"timer date 2== %@",[NSDate date]);
        [aler.alerView dismissWithClickedButtonIndex:0 animated:NO];  //退出对话框

    });
}
//view为nil时  默认为window
+(void)Show:(NSString *)messageStr WithView:(UIView *)view{
    
    if(view==nil){
        view=((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController.view;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = messageStr;
    hud.margin = 5.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:3];
}
@end
