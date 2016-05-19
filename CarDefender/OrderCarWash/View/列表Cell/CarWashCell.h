//
//  CarWashCell.h
//  CarDefender
//
//  Created by 周子涵 on 15/8/20.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Park.h"

@protocol FindParkCellDelegate <NSObject>
@optional
-(void)cellNavBtnClick:(Park*)park;
-(void)cellOrderBtnClick:(Park*)park;
@end

@interface CarWashCell : UITableViewCell
@property (strong, nonatomic) Park* park;
@property (assign, nonatomic) id<FindParkCellDelegate>    delegate;
@property (weak, nonatomic) IBOutlet UIImageView *parkImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *orderView;
@property (weak, nonatomic) IBOutlet UIView *navView;
- (IBAction)navBtnClick;
- (IBAction)OrderBtn;
-(void)reloadCell:(Park *)park;
@end
