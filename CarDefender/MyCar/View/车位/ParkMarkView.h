//
//  ParkMarkView.h
//  CarDefender
//
//  Created by 周子涵 on 15/7/29.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Park.h"

@protocol ParkMarkCellClickDelegate <NSObject>
@optional
-(void)parkCellClick:(Park*)park;
-(void)parkCellNavClick:(Park*)park;
@end

@interface ParkMarkView : UIView
{
    Park* _park;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *surplusParkLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (assign, nonatomic) id<ParkMarkCellClickDelegate>delegate;

- (id)initWithFrame:(CGRect)frame Park:(Park*)park;
-(void)reloadCell:(Park*)park;
- (IBAction)btnClick:(UIButton *)sender;
@end
