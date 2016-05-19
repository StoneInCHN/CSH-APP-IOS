//
//  CWSForgetPswController.h
//  CarDefender
//
//  Created by 李散 on 15/4/22.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSForgetPswController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;//验证码倒计时label
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;//获取验证码按钮
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;//验证码输入框
@property (weak, nonatomic) IBOutlet UITextField *phoneNubTextField;//手机号码输入框
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;//下一步按钮
- (IBAction)nextStepClick:(UIButton *)sender;//下一步按钮事件
- (IBAction)getCodeBtn:(UIButton *)sender;//获取验证码事件
@property (weak, nonatomic) IBOutlet UIView *leftLine;//顶部线
@property (weak, nonatomic) IBOutlet UIView *rightLine;//顶部线


@property (weak, nonatomic) IBOutlet UIImageView *cancelPhoneImg;//
- (IBAction)cancelPhoneClick:(id)sender;
- (IBAction)phoneTextChange:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancelPhoneBtn;


//语音验证码模块数据
@property (weak, nonatomic) IBOutlet UILabel *noGetMsgLabel;
@property (weak, nonatomic) IBOutlet UILabel *tryLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UILabel *baLabel;
- (IBAction)voiceBtn:(UIButton*)sender;
@end
