//
//  CWSIllegalQueryController.h
//  CarDefender
//
//  Created by 李散 on 15/6/30.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSIllegalQueryController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITextField *carNubText;//车牌号
@property (weak, nonatomic) IBOutlet UITextField *cjhText;//车架号
@property (weak, nonatomic) IBOutlet UILabel *fdjhText;//发动机号
@property (weak, nonatomic) IBOutlet UIButton *queryBtn;//开始查询按钮
@property (weak, nonatomic) IBOutlet UIImageView *upDownImg;//车牌简称按钮图片
@property (weak, nonatomic) IBOutlet UILabel *shortText;//车牌简称
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


- (IBAction)chooseShortPro:(id)sender;
- (IBAction)startQueryClick:(UIButton *)sender;
- (IBAction)unknowClick:(UIButton *)sender;

@end
