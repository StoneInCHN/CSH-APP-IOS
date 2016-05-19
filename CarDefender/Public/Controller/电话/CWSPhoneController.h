//
//  CWSPhoneController.h
//  宗隆
//
//  Created by sky on 15/3/10.
//  Copyright (c) 2015年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSPhoneController : UIViewController


@property (weak, nonatomic) IBOutlet UIView *keyBoardView;//键盘试图
@property (weak, nonatomic) IBOutlet UIView *displayBoxView;//拨号显示框
@property (weak, nonatomic) IBOutlet UIButton *keybBtn;//键盘收房
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;//显示号码框


- (IBAction)callNubEvent:(UIButton *)sender;//数字按钮点击事件

- (IBAction)callAndDelAndContactEvent:(UIButton *)sender;//联系人、拨打电话、删除点击事件
@end
