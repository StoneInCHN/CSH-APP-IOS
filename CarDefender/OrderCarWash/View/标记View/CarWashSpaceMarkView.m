//
//  CarWashSpaceMarkView.m
//  CarDefender
//
//  Created by 周子涵 on 15/8/20.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CarWashSpaceMarkView.h"
#import "Define.h"
#import "Park.h"

#define kUSER_SCROLLVIEW_WIDTH (kSizeOfScreen.width-40)
#define SPACE 20

@implementation CarWashSpaceMarkView

- (id)initWithFrame:(CGRect)frame Dictionary:(NSDictionary*)dic
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = [NSMutableArray arrayWithArray:dic[@"list"]];
        _currentNumber = 0;
        [self creatMarkView];
    }
    return self;
}
#pragma mark - 刷新数据
-(void)reloadData:(NSDictionary*)dic{
    _dataArray = [NSMutableArray arrayWithArray:dic[@"list"]];
    _currentNumber = 0;
    [_leftPark reloadCell:_dataArray.lastObject];
    [_middlePark reloadCell:_dataArray[_currentNumber]];
    [_rightPark reloadCell:_dataArray[_currentNumber+1]];
}
#pragma mark -  scrollView
-(void)creatMarkView{
    //1、创建scollView
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, self.frame.size.height)];
    _scrollView.delegate = self;
    _scrollView.userInteractionEnabled = NO;
    [self addSubview:_scrollView];
    //1、创建用户操作的ScrollView
    _userScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 0, kUSER_SCROLLVIEW_WIDTH, self.frame.size.height)];
    _userScrollView.showsHorizontalScrollIndicator = NO;
    _userScrollView.showsVerticalScrollIndicator = NO;
    _userScrollView.delegate = self;
    _userScrollView.bounces = NO;
    _userScrollView.pagingEnabled = YES;
    UIButton* leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(kUSER_SCROLLVIEW_WIDTH, 0, kUSER_SCROLLVIEW_WIDTH*0.8, self.frame.size.height)];
    [leftBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [_userScrollView addSubview:leftBtn];
    UIButton* rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftBtn.frame.origin.x + leftBtn.frame.size.width, 0, kUSER_SCROLLVIEW_WIDTH*0.2, self.frame.size.height)];
    [rightBtn addTarget:self action:@selector(NavbtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_userScrollView addSubview:rightBtn];
    [self addSubview:_userScrollView];
    
    CGFloat width = kSizeOfScreen.width;
    CGFloat hight = _scrollView.frame.size.height;
    
    _leftPark = [[CarWashMarkView alloc] initWithFrame:CGRectMake(SPACE*2 + SPACE/2, 0, kUSER_SCROLLVIEW_WIDTH, hight) Park:_dataArray.lastObject];
    [Utils setViewRiders:_leftPark riders:4];
    [Utils setBianKuang:KGroundColor Wide:1 view:_leftPark];
    [_scrollView addSubview:_leftPark];
    
    _middlePark = [[CarWashMarkView alloc] initWithFrame:CGRectMake(width + SPACE, 0, kUSER_SCROLLVIEW_WIDTH, hight) Park:_dataArray[_currentNumber]];
    [Utils setViewRiders:_middlePark riders:4];
    [Utils setBianKuang:KGroundColor Wide:1 view:_middlePark];
    [_scrollView addSubview:_middlePark];
    
    _rightPark = [[CarWashMarkView alloc] initWithFrame:CGRectMake(2*width - (SPACE/2), 0, kUSER_SCROLLVIEW_WIDTH, hight) Park:_dataArray[_currentNumber+1]];
    [Utils setViewRiders:_rightPark riders:4];
    [Utils setBianKuang:KGroundColor Wide:1 view:_rightPark];
    [_scrollView addSubview:_rightPark];
    
    _userScrollView.contentSize = CGSizeMake(3*kUSER_SCROLLVIEW_WIDTH, 0);
    _userScrollView.contentOffset = CGPointMake(kUSER_SCROLLVIEW_WIDTH, 0);
    _scrollView.contentSize = CGSizeMake(3*kSizeOfScreen.width, 0);
    _scrollView.contentOffset = CGPointMake(kSizeOfScreen.width, 0);
}
#pragma mark - ScrollView代理协议
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat changeX = _userScrollView.contentOffset.x - kUSER_SCROLLVIEW_WIDTH;
    _scrollView.contentOffset = CGPointMake(kSizeOfScreen.width + changeX + (10*changeX/(kSizeOfScreen.width - 2*SPACE)), 0);
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x == 0) {
        _currentNumber --;
        if (_currentNumber < 0) {
            _currentNumber = (int)_dataArray.count - 1;
        }
    }else if (scrollView.contentOffset.x != kUSER_SCROLLVIEW_WIDTH){
        _currentNumber ++;
        if (_currentNumber == _dataArray.count) {
            _currentNumber = 0;
        }
    }
    [self reloadMark:_currentNumber];
    _scrollView.contentOffset = CGPointMake(kSizeOfScreen.width, 0);
    _userScrollView.contentOffset = CGPointMake(kUSER_SCROLLVIEW_WIDTH, 0);
    [self.delegate cellScrollEnd:[NSString stringWithFormat:@"%i",_currentNumber]];
}
-(void)reloadMark:(int)temp{
    _currentNumber = temp;
    int leftNumber;
    int rightNumber;
    if (temp == 0) {
        leftNumber = (int)_dataArray.count - 1;
    }else{
        leftNumber = temp - 1;
    }
    if (temp == (int)_dataArray.count - 1) {
        rightNumber = 0;
    }else{
        rightNumber = temp + 1;
    }
    [_leftPark reloadCell:_dataArray[leftNumber]];
    [_middlePark reloadCell:_dataArray[temp]];
    [_rightPark reloadCell:_dataArray[rightNumber]];
}
-(void)btnClick{
    [self.delegate cellClick:[NSString stringWithFormat:@"%i",_currentNumber]];
}
-(void)NavbtnClick{
    [self.delegate cellNavClick:[NSString stringWithFormat:@"%i",_currentNumber]];
}
@end
