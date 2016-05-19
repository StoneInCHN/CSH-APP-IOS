//
//  CWSWeatherCell.h
//  weather
//
//  Created by 周子涵 on 15/7/7.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSWeatherCell : UITableViewCell
@property (strong, nonatomic) NSDictionary* dataDic;


@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UILabel *carNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;
@property (weak, nonatomic) IBOutlet UILabel *markLabel;
@end
