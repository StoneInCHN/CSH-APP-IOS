//
//  CWSOilCell.h
//  CarDefender
//
//  Created by 周子涵 on 15/5/8.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSOilCell : UITableViewCell
@property (strong, nonatomic) NSString* style;
@property (strong, nonatomic) NSString* lat;
@property (strong, nonatomic) NSString* lon;
@property (strong, nonatomic) NSString* tel;

@property (weak, nonatomic) IBOutlet UILabel *parkNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *telBtn;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

- (IBAction)btnClick:(UIButton *)sender;
@end
