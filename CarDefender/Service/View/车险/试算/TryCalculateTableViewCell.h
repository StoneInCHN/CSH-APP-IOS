//
//  TryCalculateTableViewCell.h
//  CarDefender
//
//  Created by 万茜 on 15/12/9.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TryCalculateTableViewCell : UITableViewCell
@property (nonatomic,strong)UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *dropDownButton;
@property (weak, nonatomic) IBOutlet UILabel *dropDownMoneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *footImageView;

@end
