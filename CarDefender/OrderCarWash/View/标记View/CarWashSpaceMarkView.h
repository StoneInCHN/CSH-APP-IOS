//
//  CarWashSpaceMarkView.h
//  CarDefender
//
//  Created by 周子涵 on 15/8/20.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "FindParkingSpaceMarkView.h"
#import "CarWashMarkView.h"

//@protocol CarWashMarkCellClickDelegate <NSObject>
//@optional
//-(void)cellClick:(NSString*)type;
//-(void)cellNavClick:(NSString*)type;
//-(void)cellScrollEnd:(NSString*)type;
//@end
@interface CarWashSpaceMarkView : UIView<UIScrollViewDelegate,MarkCellClickDelegate>
{
    NSMutableArray*   _dataArray;
    UIScrollView *    _scrollView;
    UIScrollView *    _userScrollView;
    int               _currentNumber;
    CarWashMarkView*  _leftPark;
    CarWashMarkView*  _middlePark;
    CarWashMarkView*  _rightPark;
}
@property (assign, nonatomic) id<MarkCellClickDelegate>delegate;
-(void)reloadMark:(int)temp;
- (id)initWithFrame:(CGRect)frame Dictionary:(NSDictionary*)dic;
-(void)reloadData:(NSDictionary*)dic;

@end
