//
//  CWSAlarmCell.h
//  CarDefender
//
//  Created by 李散 on 15/7/31.
//  Copyright (c) 2015年 SKY. All rights reserved.
//
@protocol CWSAlarmCellDelegate <NSObject>

-(void)swithValueChange:(BOOL)swithOn with:(NSIndexPath*)currentPath;

@end
#import <UIKit/UIKit.h>

@interface CWSAlarmCell : UITableViewCell
@property (nonatomic, strong) NSIndexPath*currentPath;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UISwitch *swithBtn;
- (IBAction)swithValueChange:(UISwitch *)sender;
@property (assign, nonatomic) id<CWSAlarmCellDelegate>delegate;
@end
