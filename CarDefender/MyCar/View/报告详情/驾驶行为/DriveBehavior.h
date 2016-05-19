//
//  DriveBehavior.h
//  报告动画
//
//  Created by 周子涵 on 15/5/20.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CellClickDelegate <NSObject>
@optional
-(void)cellClick:(NSString*)type;

@end

@interface DriveBehavior : UIView
{
    NSDictionary* _dataDic;
    UIView*       _headView;
    UILabel*      _mileLabel;
    UILabel*      _timeLabel;
    UILabel*      _gradeLabel;
    UITableView*  _tableView;
    NSArray*      _dataArray;
}
@property (assign, nonatomic) id<CellClickDelegate>delegate;
-(void)animateStart;
-(void)reloadData:(NSDictionary*)dic;
- (id)initWithFrame:(CGRect)frame Dictionary:(NSDictionary*)dic;
@end
