/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>
@class MBProgressHUD;
@interface UIViewController (HUD)
@property (strong, nonatomic) MBProgressHUD*mbProgress;
- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)hideHud;

- (void)showHint:(NSString *)hint;

// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)showHint:(NSString *)hint yOffset:(float)yOffset;
-(void)dateLate;
//推送公共方法
-(void)setRemoteNotiEvent;
-(void)turnToLoginVC;
//分享方法
-(void)shareMsgWithImage:(NSString*)imageName
             withContent:(NSString*)content
      withDefaultContent:(NSString*)defaultContent
               withTitle:(NSString*)title
                 withUrl:(NSString*)url
         withDescription:(NSString*)description;
@end
