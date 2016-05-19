//
//  CWSWithdrawDepositController.m
//  CarDefender
//
//  Created by 周子涵 on 15/6/2.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSWithdrawDepositController.h"

@interface CWSWithdrawDepositController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *moneyLable;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *markLable;
@property (weak, nonatomic) IBOutlet UILabel *canUseLable;

- (IBAction)touchDown:(UIControl *)sender;
@end

@implementation CWSWithdrawDepositController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    self.canUseLable.text = KUserManager.account.cash;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSLog(@"change");
//    if ([textField.text floatValue] > 10000) {
//        textField.text = @"10000";
//    }
    
    self.markLable.hidden = YES;
    return YES;
}
- (IBAction)touchDown:(UIControl *)sender {
//    if (![self.moneyTextField.text isEqualToString:@""]) {
    if ([self.moneyTextField.text floatValue] > [KUserManager.account.cash floatValue]) {
        self.markLable.hidden = NO;
    }
    [self.moneyTextField resignFirstResponder];
}
@end
