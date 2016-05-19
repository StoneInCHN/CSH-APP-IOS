//
//  ShopNameView.h
//  CarDefender
//
//  Created by 万茜 on 15/12/8.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMNavController.h"

@interface ShopNameView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneButtton;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIView *storeReviewView;
- (instancetype)initWithFrame:(CGRect)frame Data:(NSDictionary *)dic controller:(BMNavController *)controller;
@end
