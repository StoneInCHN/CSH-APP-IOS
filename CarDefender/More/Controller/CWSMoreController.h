//
//  CWSMoreController.h
//  CarDefender
//
//  Created by 周子涵 on 15/3/28.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSMoreController : UIViewController
{
}
@property (weak, nonatomic) IBOutlet UIScrollView *backgroundScrollerView;
@property (strong, nonatomic) IBOutlet UIView *groundView;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UIButton *privacyBtn;
@property (weak, nonatomic) IBOutlet UIButton *aboutUsBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginOrOutBtn;
- (IBAction)btnClick:(UIButton *)sender;
@end
