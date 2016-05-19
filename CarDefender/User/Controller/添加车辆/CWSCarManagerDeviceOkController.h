//
//  CWSCarManagerDeviceOkController.h
//  CarDefender
//
//  Created by 李散 on 15/6/6.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSCarManagerDeviceOkController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btn1;//300元
@property (weak, nonatomic) IBOutlet UIButton *btn2;//398元
@property (weak, nonatomic) IBOutlet UIButton *btn3;//关于话费
@property (weak, nonatomic) IBOutlet UIButton *btn4;//关于返费
@property (weak, nonatomic) IBOutlet UIButton *btn5;//确定
@property (weak, nonatomic) IBOutlet UIButton *btn6;//取消
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;

@property (strong, nonatomic) IBOutlet UIView *notiview;

- (IBAction)btnClick:(UIButton *)sender;


@property (nonatomic, strong) NSString*carCid;//车辆ID；
@end
