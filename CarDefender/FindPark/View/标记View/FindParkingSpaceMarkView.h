//
//  FindParkingSpaceMarkView.h
//  FindCarLocation
//
//  Created by 周子涵 on 15/7/14.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkMarkView.h"

@protocol MarkCellClickDelegate <NSObject>
@optional
-(void)cellClick:(NSString*)type;
-(void)cellNavClick:(NSString*)type;
-(void)cellScrollEnd:(NSString*)type;
@end
@interface FindParkingSpaceMarkView : UIView<UIScrollViewDelegate,MarkCellClickDelegate>
{
    NSMutableArray*  _dataArray;
    UIScrollView *   _scrollView;
    UIScrollView *   _userScrollView;
    int              _currentNumber;
    ParkMarkView*    _leftPark;
    ParkMarkView*    _middlePark;
    ParkMarkView*    _rightPark;
}
@property (assign, nonatomic) id<MarkCellClickDelegate>delegate;
-(void)reloadMark:(int)temp;
- (id)initWithFrame:(CGRect)frame Dictionary:(NSDictionary*)dic;
-(void)reloadData:(NSDictionary*)dic;
@end
