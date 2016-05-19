//
//  ShopFootView.h
//  CarDefender
//
//  Created by 万茜 on 15/12/8.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopFootView : UIView
@property (weak, nonatomic) IBOutlet UILabel *carLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *secondCodeImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageViewTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *secondCodeView;

- (instancetype)initWithFrame:(CGRect)frame Data:(NSDictionary *)dic;
@end
