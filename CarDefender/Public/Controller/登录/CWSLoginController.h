//
//  CWSLoginController.h
//  CarDefender
//
//  Created by 李散 on 15/4/8.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSLoginController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *registSuccessView;
- (IBAction)bangDingClick:(UIButton *)sender;
- (IBAction)walkClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *bangdingBtn;
@property (weak, nonatomic) IBOutlet UIButton *walkBtn;

@property (strong, nonatomic)NSString*registSuccessOK;


@property (weak, nonatomic) IBOutlet UITextField *telephoneTextField;//手机号
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;//密码
@property (weak, nonatomic) IBOutlet UIButton *remenberPasswordBtn;//记住密码
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;//登录按钮
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;//背景图片

//textfield输入变化触发事件
//- (IBAction)textFieldDidEnd:(UITextField *)sender;
- (IBAction)thirdLogin:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)loginClick;//登录方法
- (IBAction)registerClick;//注册方法
- (IBAction)passworedClick:(UIButton *)sender;//忘记密码方法
- (IBAction)cancelClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *forgetPassBtn;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelPhoneBtn;//删除输入手机号码
@property (weak, nonatomic) IBOutlet UIImageView *cancelPhoneImgView;
- (IBAction)cancelPhoneClick:(UIButton *)sender;
- (IBAction)phoneNubChange:(UITextField *)sender;
@property (strong, nonatomic) IBOutlet UIView *baseView;
- (IBAction)paswordChange:(UITextField *)sender;
@property(nonatomic,strong)NSString*loginOutType;





@end
