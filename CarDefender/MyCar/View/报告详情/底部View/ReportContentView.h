//
//  ReportContentView.h
//  报告动画
//
//  Created by 周子涵 on 15/5/19.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportContentView : UIView
{
    NSDictionary* _dataDic;
    UILabel* _titleLabel;
    UILabel* _valueLabel;
    UILabel* _contentLabel;
    UILabel* _markLabel;
    
    
    UIScrollView*_scrollView;
    CGFloat _namalFont;
//    NSDictionary*_dicMsg;
    CGFloat _currentDistance;
}
- (id)initWithFrame:(CGRect)frame Dictionary:(NSDictionary*)dic;
-(void)reloadData:(NSDictionary*)dic;
@end
