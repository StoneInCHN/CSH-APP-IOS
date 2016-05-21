//
//  CWSCWSIllegalCheckDetailViewController.h
//  CarDefender
//
//  Created by 万茜 on 15/12/9.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSCWSIllegalCheckDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *headCarImageView;
@property (weak, nonatomic) IBOutlet UILabel *headCarBrandLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *illegalLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *footView;
@property (nonatomic,strong)NSDictionary *dic;
@end
