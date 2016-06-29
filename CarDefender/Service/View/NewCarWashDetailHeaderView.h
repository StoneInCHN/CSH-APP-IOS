//
//  NewCarWashDetailHeaderView.h
//  CarDefender
//
//  Created by 王泰莅 on 15/12/10.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMNavController.h"

@interface NewCarWashDetailHeaderView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *storeImageView;
@property (strong, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *storeBusinessHoursLabel;
@property (strong, nonatomic) IBOutlet UILabel *storeAddressLabel;
@property (strong, nonatomic) NSArray *images;

- (instancetype)initWithFrame:(CGRect)frame Data:(NSDictionary *)dic images:(NSArray *)images controller:(BMNavController *)controller;
@end
