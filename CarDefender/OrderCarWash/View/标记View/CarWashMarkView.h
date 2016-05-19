//
//  CarWashMarkView.h
//  CarDefender
//
//  Created by 周子涵 on 15/8/20.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Park.h"

@protocol ParkMarkCellClickDelegate <NSObject>
@optional
-(void)parkCellClick:(Park*)park;
-(void)parkCellNavClick:(Park*)park;
@end

@interface CarWashMarkView : UIView
{
    Park* _park;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (assign, nonatomic) id<ParkMarkCellClickDelegate>delegate;

- (id)initWithFrame:(CGRect)frame Park:(Park*)park;
-(void)reloadCell:(Park*)park;
- (IBAction)btnClick:(UIButton *)sender;
@end
