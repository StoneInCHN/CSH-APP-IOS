//
//  ReportOil.h
//  报告动画
//
//  Created by 周子涵 on 15/5/13.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportContentView.h"

@interface ReportOil : UIView
{
    UIView* _selectedView;
    CGFloat _surplusH;
    CGFloat _todayH;
    __weak IBOutlet UIView *_markView;
    __weak IBOutlet UILabel *_markLabel;
    
    ReportContentView* _reportBottomView;
    UIView*            _noDataView;
}
@property (strong, nonatomic) NSDictionary* data;
@property (strong, nonatomic) NSDictionary* testDate;
-(void)animateStart;
-(void)reloadData:(NSDictionary*)dic;
- (id)initWithFrame:(CGRect)frame Dictionary:(NSDictionary*)dic;
@end
