//
//  CWSMyMonyController.h
//  CarDefender
//
//  Created by 李散 on 15/8/29.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSMyMonyController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *protectLabel;
@property (weak, nonatomic) IBOutlet UIButton *yeButton;
@property (weak, nonatomic) IBOutlet UILabel *yjLabel;
@property (weak, nonatomic) IBOutlet UILabel *zjeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hfLabel;
- (IBAction)btnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *notiView;
@property (weak, nonatomic) IBOutlet UIButton *czBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;

@property (weak, nonatomic) IBOutlet UIView *view100;
@property (weak, nonatomic) IBOutlet UIView *view200;
@property (weak, nonatomic) IBOutlet UIView *view300;
@property (weak, nonatomic) IBOutlet UIView *view400;


@property (strong, nonatomic) NSString *backString;
- (IBAction)btnEvent:(UIButton *)sender;
-(void)loadData;
@end
