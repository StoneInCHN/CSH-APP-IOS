//
//  SpeedCoordView.m
//  报告动画
//
//  Created by 周子涵 on 15/5/19.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "SpeedCoordView.h"
#import "SpeedTopCell.h"
#import "Define.h"
#define kNormalHight self.frame.size.height - 20
#define kNormalWight 40
@implementation SpeedCoordView
- (id)initWithFrame:(CGRect)frame Dictionary:(NSDictionary*)dic markData:(NSDictionary*)markData 
{
    self = [super initWithFrame:frame];
    if (self) {
        _firstIn = YES;
        _selectRow = 0;
        self.data = dic;
        self.markData = markData;
        MyLog(@"%@",dic);
//        MyLog(@"%@",markData);
        _temp = 0;
        NSMutableArray* mutArray = [NSMutableArray arrayWithObject:@"全部"];
//        [mutArray addObjectsFromArray:dic[@"data"]];
        NSArray* array = dic[@"data"];
        for (int i = 0; i < array.count; i++) {
            NSDictionary* lDic = array[array.count - i -1];
            [mutArray addObject:lDic];
        }
        _dataArray = [NSArray arrayWithArray:mutArray];
        self.backgroundColor = [UIColor whiteColor];
        [self creatUI];
        
    }
    return self;
}
-(void)creatUI{
    
    [self creatScrollerView];
    [self creatTableView];
    [self creatTimeLabel:@[@"0时",@"6时",@"12时",@"18时",@"24时"]];
    [self creatForm];
    [self reloadScrollerView:YES type:0];
    
}
-(void)creatScrollerView{
    _groundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 10)];
    [Utils setViewRiders:_groundView riders:4];
    [self addSubview:_groundView];
    
    _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 70, _groundView.frame.size.height)];
    _scrollerView.showsHorizontalScrollIndicator = NO;
    _scrollerView.bounces = NO;
    _scrollerView.delegate = self;
    _scrollerView.backgroundColor = kCOLOR(245, 245, 245);
    [_groundView addSubview:_scrollerView];
    
    _timeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 10, self.frame.size.width - 70, 10)];
    _timeScrollView.showsHorizontalScrollIndicator = NO;
    _timeScrollView.userInteractionEnabled = NO;
    _timeScrollView.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:_timeScrollView];
}
-(void)creatTimeLabel:(NSArray*)array{
    UIView* timeGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _timeScrollView.frame.size.width*2, 10)];
    timeGroundView.backgroundColor = [UIColor whiteColor];
    [_timeScrollView addSubview:timeGroundView];
    for (int i = 0; i < 5; i++) {
        UILabel* lLabel = [Utils labelWithFrame:CGRectMake(0, 0, 20, 10) withTitle:array[i] titleFontSize:kFontOfSize(9) textColor:[UIColor darkGrayColor] alignment:NSTextAlignmentCenter];
        lLabel.tag = i + 10;
        [_timeScrollView addSubview:lLabel];
    }
}
-(void)creatTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.size.width - 70, 0, 70, self.frame.size.height - 10) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kCOLOR(196, 196, 196);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_groundView addSubview:_tableView];
}
-(void)creatForm{
    for (int i = 1; i < _dataArray.count; i++) {
        UIView* lView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        lView.backgroundColor = kCOLOR(169, 211, 254);
//        lView.backgroundColor = kMainColor;
        lView.tag = 100 + i;
        [_scrollerView insertSubview:lView atIndex:0];
    }
}
-(void)reloadScrollerView:(BOOL)allStyle type:(int)type{
    CGFloat interval;
    if (allStyle) {
        _width = (_scrollerView.frame.size.width-20);
    }else{
        _width = (_scrollerView.frame.size.width*2-20);
    }
    interval = _width/4;
    for (int i = 0; i < 5; i ++) {
        UIView* timeLabel = [_timeScrollView viewWithTag:i+10];
        [timeLabel setFrame:CGRectMake(i * interval, 0, 20, 10)];
    }
    if (type == 0) {
        for (int i = 1; i < _dataArray.count; i++) {
            NSDictionary* lDic = _dataArray[i];
            CGFloat startX = [lDic[@"start"] floatValue]*_width/86400 ;
            CGFloat endX = [lDic[@"end"] floatValue]*_width/86400 ;
            CGFloat hight = _scrollerView.frame.size.height;
            CGFloat h = [lDic[@"bottom"] floatValue]*hight/[self.markData[@"max"] floatValue];
            UIView* lView = [_scrollerView viewWithTag:i+100];
            lView.backgroundColor = kCOLOR(169, 211, 254);
            [lView setFrame:CGRectMake(startX, hight - h, endX - startX, h )];
        }
        return;
    }
    for (int i = 1; i < _dataArray.count; i++) {
        NSDictionary* lDic = _dataArray[i];
        CGFloat startX = [lDic[@"start"] floatValue]*_width/86400 ;
        CGFloat endX = [lDic[@"end"] floatValue]*_width/86400 ;
        CGFloat hight = _scrollerView.frame.size.height;
        CGFloat h = [lDic[@"bottom"] floatValue]*hight/[self.markData[@"max"] floatValue];
        UIView* lView = [_scrollerView viewWithTag:i+100];
        lView.backgroundColor = kCOLOR(169, 211, 254);
        if (i == type) {
            lView.backgroundColor = kMainColor;
        }
        [lView setFrame:CGRectMake(startX, hight - h, endX - startX, h)];
    }
}
-(void)setContentOffset:(CGFloat)startX endX:(CGFloat)endX allStyle:(BOOL)allStyle{
    [UIView animateWithDuration:0.4 animations:^{
        if (allStyle) {
            [_scrollerView setContentOffset:CGPointMake(0, 0)];
        }else{
            if ((endX + startX)/2 < _scrollerView.frame.size.width/2) {
                [_scrollerView setContentOffset:CGPointMake(0, 0)];
            }else if ((endX + startX)/2  > _scrollerView.frame.size.width*1.5){
                [_scrollerView setContentOffset:CGPointMake(_scrollerView.frame.size.width, 0)];
            }else{
                [_scrollerView setContentOffset:CGPointMake((endX + startX)/2 - _scrollerView.frame.size.width/2, 0)];
            }
        }
        _timeScrollView.contentOffset = _scrollerView.contentOffset;
    } completion:^(BOOL finished) {
        if (_selectRow > 0) {
            _markView.hidden = NO;
        }
    }];
}
#pragma mark - tableView数据源协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *speedTopCell=@"speedTopCell";
    SpeedTopCell* cell = [tableView dequeueReusableCellWithIdentifier:speedTopCell];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SpeedTopCell" owner:self options:nil][0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if (indexPath.row == 0) {
//        if (_firstIn) {
//            cell.nameLable.backgroundColor = kCOLOR(153, 153, 153);
//            _firstIn = NO;
//        }
//        cell.nameLable.backgroundColor = kCOLOR(153, 153, 153);
        cell.nameLable.text = @"全部";
        cell.zhiLabel.hidden = YES;
    }else{
        NSDictionary* dic = _dataArray[indexPath.row];
//        cell.nameLable.text = [NSString stringWithFormat:@"%@~%@",dic[@"startTime"],dic[@"endTime"]];
        cell.starTimeLable.text = dic[@"startTime"];
        cell.endTimelLabel.text = dic[@"endTime"];
        
    }
    if (indexPath.row == _selectRow) {
        cell.nameLable.backgroundColor = kCOLOR(153, 153, 153);
    }else{
        cell.nameLable.backgroundColor = kCOLOR(196, 196, 196);
    }
    return cell;
}
#pragma mark - tableView代理协议
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 34;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectRow = (int)indexPath.row;
    SpeedTopCell* cellOld = (SpeedTopCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    cellOld.nameLable.backgroundColor = kCOLOR(196, 196, 196);
    SpeedTopCell* cell = (SpeedTopCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.nameLable.backgroundColor = kCOLOR(153, 153, 153);
    if (indexPath.row == 0) {
        if (_markView != nil) {
            _markView.hidden = YES;
        }
        [self reloadScrollerView:YES type:(int)indexPath.row];
        _scrollerView.contentSize = CGSizeMake(_scrollerView.frame.size.width, 0);
        [self setContentOffset:0 endX:0 allStyle:YES];
    }else{
        _temp = (int)indexPath.row;
        _scrollerView.contentSize = CGSizeMake(_scrollerView.frame.size.width*2, 0);
        [self reloadScrollerView:NO type:(int)indexPath.row];
        NSDictionary* lDic = _dataArray[indexPath.row];
        CGFloat startX = [lDic[@"start"] floatValue]*_width/86400 ;
        CGFloat endX = [lDic[@"end"] floatValue]*_width/86400 ;
        CGFloat hight = _scrollerView.frame.size.height - 10;
        CGFloat h = [lDic[@"bottom"] floatValue]*hight/[self.markData[@"max"] floatValue];
        [self setContentOffset:startX endX:endX allStyle:NO];
        [self reloadMark:(startX+endX)/2 hight:h];
    }
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpeedTopCell* cell = (SpeedTopCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.nameLable.backgroundColor = kCOLOR(196, 196, 196);
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
}

-(void)reloadMark:(CGFloat)x hight:(CGFloat)hight{
    _markView.hidden = YES;
    if (x <= _scrollerView.frame.size.width) {
        if (hight > _scrollerView.frame.size.height/2) {
            CGRect viewFrame = CGRectMake(x, _scrollerView.frame.size.height - hight - 6, 84, 33);
            CGRect imagFrame = CGRectMake(-1, -2, 70, 21);
            CGRect maxLabelFrame = CGRectMake(14, 3, 67, 14);
            CGRect avgLabelFrame = CGRectMake(14, 18, 67, 14);
            [self setMarkView:viewFrame imagFrame:imagFrame maxLabelFrame:maxLabelFrame avgLabelFrame:avgLabelFrame imageName:@"down_right" left:YES];
        }else{
            CGRect viewFrame = CGRectMake(x, _scrollerView.frame.size.height - hight - 33 - 6, 84, 33);
            CGRect imagFrame = CGRectMake(-1, 13, 70, 21);
            CGRect maxLabelFrame = CGRectMake(14, 0, 70, 14);
            CGRect avgLabelFrame = CGRectMake(14, 14, 70, 14);
            [self setMarkView:viewFrame imagFrame:imagFrame maxLabelFrame:maxLabelFrame avgLabelFrame:avgLabelFrame imageName:@"up_right" left:YES];
        }
    }else{
//        CGRect frame = CGRectMake(maxX - 84, kNormalHight - maxHight - 33, 84, 33);
        if (hight > _scrollerView.frame.size.height/2) {
            CGRect viewFrame = CGRectMake(x - 84, _scrollerView.frame.size.height - hight - 6, 84, 33);
            CGRect imagFrame = CGRectMake(15, -2, 70, 21);
            CGRect maxLabelFrame = CGRectMake(0, 3, 67, 14);
            CGRect avgLabelFrame = CGRectMake(0, 18, 67, 14);
            [self setMarkView:viewFrame imagFrame:imagFrame maxLabelFrame:maxLabelFrame avgLabelFrame:avgLabelFrame imageName:@"down_left" left:NO];
        }else{
            CGRect viewFrame = CGRectMake(x - 84, _scrollerView.frame.size.height - hight - 33 - 6, 84, 33);
            CGRect imagFrame = CGRectMake(17, 14, 70, 21);
            CGRect maxLabelFrame = CGRectMake(0, 0, 70, 14);
            CGRect avgLabelFrame = CGRectMake(0, 14, 70, 14);
            [self setMarkView:viewFrame imagFrame:imagFrame maxLabelFrame:maxLabelFrame avgLabelFrame:avgLabelFrame imageName:@"up_left" left:NO];
        }
    }
    if (_temp == 0) {
        return;
    }
    _markMaxSpeedLabel.text = [NSString stringWithFormat:@"%@ %@",self.markData[@"topName"],_dataArray[_temp][@"top"]];
    _markAvgSpeedLabel.text = [NSString stringWithFormat:@"%@ %@",self.markData[@"bottomName"],_dataArray[_temp][@"bottom"]];
}

-(void)setMarkView:(CGRect)viewFrame imagFrame:(CGRect)imagFrame maxLabelFrame:(CGRect)maxLabelFrame avgLabelFrame:(CGRect)avgLabelFrame imageName:(NSString*)imageName left:(BOOL)left{
    if (_markView == nil) {
        _markView = [[UIView alloc] initWithFrame:viewFrame];
        _markImageView = [[UIImageView alloc] initWithFrame:imagFrame];
        _markImageView.image = [UIImage imageNamed:imageName];
        [_markView addSubview:_markImageView];
        _markMaxSpeedLabel = [Utils labelWithFrame:maxLabelFrame withTitle:@"" titleFontSize:kFontOfSize(9) textColor:kMainColor alignment:NSTextAlignmentLeft];
        _markAvgSpeedLabel = [Utils labelWithFrame:avgLabelFrame withTitle:@"" titleFontSize:kFontOfSize(9) textColor:kMainColor alignment:NSTextAlignmentLeft];
        [_markView addSubview:_markMaxSpeedLabel];
        [_markView addSubview:_markAvgSpeedLabel];
        [_scrollerView addSubview:_markView];
    }else{
        [_markView setFrame:viewFrame];
        [_markImageView setFrame:imagFrame];
        _markImageView.image = [UIImage imageNamed:imageName];
        [_markMaxSpeedLabel setFrame:maxLabelFrame];
        [_markAvgSpeedLabel setFrame:avgLabelFrame];
    }
    if (left) {
        _markMaxSpeedLabel.textAlignment = NSTextAlignmentLeft;
        _markAvgSpeedLabel.textAlignment = NSTextAlignmentLeft;
    }else{
        _markMaxSpeedLabel.textAlignment = NSTextAlignmentRight;
        _markAvgSpeedLabel.textAlignment = NSTextAlignmentRight;
    }
}
#pragma mark - scrollView代理协议
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _timeScrollView.contentOffset = _scrollerView.contentOffset;
}
@end
