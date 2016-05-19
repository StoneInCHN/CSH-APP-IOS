//
//  SpeedCoordView.h
//  报告动画
//
//  Created by 周子涵 on 15/5/19.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpeedCoordView : UIView<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    int     _temp;
    UIView*      _markView;
    UILabel*     _markMaxSpeedLabel;
    UILabel*     _markAvgSpeedLabel;
    UIImageView* _markImageView;
    
    
    
    NSMutableArray*   _topArray;
    NSArray*          _dataArray;
    UITableView*      _tableView;
    UIView*           _groundView;
    UIScrollView*     _scrollerView;
    UIScrollView*     _timeScrollView;
    CGFloat           _width;
    BOOL              _firstIn;
    int               _selectRow;
}
@property (strong, nonatomic) NSString* topName;
@property (strong, nonatomic) NSString* bottomName;
@property (assign, nonatomic) CGFloat max;
@property (strong, nonatomic) NSDictionary* data;
@property (strong, nonatomic) NSDictionary* markData;
//-(void)reloadData:(NSDictionary*)dic markData:(NSDictionary*)markData;
- (id)initWithFrame:(CGRect)frame Dictionary:(NSDictionary*)dic markData:(NSDictionary*)markData;
@end
