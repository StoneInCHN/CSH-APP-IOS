//
//  CWSRegistPassWordController.h
//  CarDefender
//
//  Created by 李散 on 15/4/10.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSRegistPassWordController : UIViewController
- (IBAction)nextTypeClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextTypeBtn;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UITextField *againPasswdField;
@property (weak, nonatomic) IBOutlet UIImageView *yanImg;
@property (weak, nonatomic) IBOutlet UIImageView *errorImageView;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cancelPhoneImg;
@property (weak, nonatomic) IBOutlet UIButton *cancelPhoneBtn;

- (IBAction)pswChange:(UITextField *)sender;
- (IBAction)deletePhoneBtnClick:(UIButton *)sender;

@property (strong,nonatomic)NSMutableDictionary*dic;
@property (nonatomic,copy) void (^registerSuccess)();
@end
