//
//  ReportSpeed.h
//  报告动画
//
//  Created by 周子涵 on 15/5/13.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportContentView.h"
#import "SpeedCoordView.h"


#define kNormalHight self.frame.size.height*0.38
#define kNormalWight 15
#define kRatio 0.62
#define kTopRatio 0.7
@interface ReportSpeed : UIView
{
    NSMutableArray* _topArray;
    int     _temp;
    ReportContentView* _reportBottomView;
    SpeedCoordView*    _speedCoordView;
    UIScrollView*      _scrollerView;
    UILabel*           _markLabel;
}
@property (strong, nonatomic) NSDictionary* data;

-(void)animateStart;
- (id)initWithFrame:(CGRect)frame Dictionary:(NSDictionary*)dic;
-(void)creatTop;
-(void)creatBottom;
-(void)reloadData:(NSDictionary*)dic;
@end
