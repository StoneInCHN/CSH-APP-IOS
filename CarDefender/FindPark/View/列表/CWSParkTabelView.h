//
//  CWSParkTabelView.h
//  CarDefender
//
//  Created by 周子涵 on 15/8/6.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindParkCell.h"
#import "Park.h"

@protocol ParkTabelViewDelegate <NSObject>
@optional
-(void)parkTabelViewNavClick:(Park*)park;
-(void)parkTabelViewCellClick:(Park*)park;
-(void)parkTabelViewOrderClick:(Park*)park;
@end
@interface CWSParkTabelView : UIView<UITableViewDataSource,UITableViewDelegate,FindParkCellDelegate>
{
    NSArray*             _dataArray;
    UITableView*         _tableView;
}
@property (assign, nonatomic) id<ParkTabelViewDelegate>    delegate;
- (id)initWithFrame:(CGRect)frame DataArray:(NSArray*)dataArray;
- (void)reloadData:(NSArray*)dataArray;
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
