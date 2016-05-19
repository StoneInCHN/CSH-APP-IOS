//
//  ReportTime.h
//  报告动画
//
//  Created by 周子涵 on 15/5/13.
//  Copyright (c) 2015年 SKY. All rights reserved.
//
@protocol ReportTimeDelegate <NSObject>

-(void)reportTimeShareDic:(NSDictionary*)dic;

@end
#import <UIKit/UIKit.h>
#import "TimeView.h"


@interface ReportTime : UIView<TimeViewDelegate>
{
    UIScrollView*_scrollView;
    CGFloat _namalFont;
    NSDictionary*_dicMsg;
    CGFloat _currentDistance;
    
    BOOL noData;//没有数据为1，有数据为0
    BOOL _timeViewFirstIn;
    NSString*_shareString;
    NSDictionary*_timeDic;
}
@property(assign,nonatomic)id<ReportTimeDelegate>delegate;
-(void)animateStart;
-(void)reloadData:(NSDictionary*)dic;
@end
