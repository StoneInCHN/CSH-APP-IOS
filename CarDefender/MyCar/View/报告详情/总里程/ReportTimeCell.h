//
//  ReportTimeCell.h
//  报告动画
//
//  Created by 李散 on 15/5/27.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportTimeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhi;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property(nonatomic,strong)NSDictionary*dicMsg;
@end
