//
//  CWSParkCell.h
//  CarDefender
//
//  Created by 周子涵 on 15/4/3.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSParkCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *parkNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;
@property (strong, nonatomic) NSString* style;
@property (strong, nonatomic) NSString* lat;
@property (strong, nonatomic) NSString* lon;
@property (weak, nonatomic) IBOutlet UIButton *distanceBtn;

- (IBAction)btnClick:(UIButton *)sender;
@end
