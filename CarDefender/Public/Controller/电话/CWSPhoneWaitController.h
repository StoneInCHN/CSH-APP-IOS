//
//  CWSPhoneWaitController.h
//  CarDefender
//
//  Created by 李散 on 15/5/7.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSPhoneWaitController : UIViewController
- (IBAction)goBackClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *goOutPhoneNub;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneNub;
@property (weak, nonatomic) IBOutlet UIImageView *animateImg;
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (nonatomic, strong) NSDictionary*phoneDic;
@end
