//
//  CWSNavController.h
//  CarDefender
//
//  Created by 周子涵 on 15/3/30.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMNavController.h"

@interface CWSNavController : BMNavController
{
    NSString*                _city;
    BOOL                     _traffic;
}

@property (strong, nonatomic) IBOutlet UIView *footBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *footMarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *footAddressLabel;
- (IBAction)qiehuanBtnClick:(UIButton *)sender;
- (IBAction)daohangBtnClick;


- (IBAction)addBtnClick:(UIButton *)sender;
@end
