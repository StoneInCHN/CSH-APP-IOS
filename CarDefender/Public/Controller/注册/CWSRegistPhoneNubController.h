//
//  CWSRegistPhoneNubController.h
//  CarDefender
//
//  Created by 李散 on 15/4/10.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSRegistPhoneNubController : UIViewController
- (IBAction)nextTypeClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextTypeBtn;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) NSMutableDictionary*dic;

- (IBAction)getVerifyNumber:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *verifyNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *getCodeLabel;

@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
- (IBAction)teleChange:(UITextField *)sender;

//语音验证码模块数据
@property (weak, nonatomic) IBOutlet UILabel *noGetMsgLabel;
@property (weak, nonatomic) IBOutlet UILabel *tryLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UILabel *baLabel;
- (IBAction)voiceBtn:(UIButton*)sender;

- (IBAction)agreeBtnClick;
- (IBAction)tiaoKuanBtnClick;
@end
