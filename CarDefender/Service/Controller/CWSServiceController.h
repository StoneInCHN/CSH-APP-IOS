//
//  CWSServiceController.h
//  CarDefender
//
//  Created by 周子涵 on 15/3/28.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWSDetectionController.h"
#import "CWSPhoneController.h"
@interface CWSServiceController : UIViewController
{
    UIControl*     _homeBackgroundControl;
}
@property (weak, nonatomic) IBOutlet UIButton *adventureView;
@property (weak, nonatomic) IBOutlet UIScrollView *backgroundScrollerView;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollerView;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIImageView *upOrDownImageView;
@property (strong, nonatomic) IBOutlet UIView *groundView;

- (IBAction)btnClick:(UIButton *)sender;
@end
