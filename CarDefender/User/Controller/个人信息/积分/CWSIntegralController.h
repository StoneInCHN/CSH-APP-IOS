//
//  CWSIntegralController.h
//  CarDefender
//
//  Created by 周子涵 on 15/6/2.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSIntegralController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *integralHeadView;
@property (weak, nonatomic) IBOutlet UIButton *backTopBtn;
@property (weak, nonatomic) IBOutlet UIImageView *queryImageView;
@property (weak, nonatomic) IBOutlet UIButton *queryBtn;


- (IBAction)btnClick:(UIButton *)sender;
@end
