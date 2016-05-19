//
//  CWSForgetSetPswController.h
//  CarDefender
//
//  Created by 李散 on 15/4/22.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSForgetSetPswController : UIViewController
@property(nonatomic,strong)NSString*phoneNubString;
- (IBAction)saveClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UITextField *firstTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondTextField;

@end
