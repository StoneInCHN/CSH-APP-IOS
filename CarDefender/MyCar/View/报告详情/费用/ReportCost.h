//
//  ReportCost.h
//  报告动画
//
//  Created by 周子涵 on 15/5/13.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ReportCostDelegate <NSObject>

-(void)reportCostAddCarCostWithDic:(NSDictionary*)dic;
-(void)reportCostEdit:(NSDictionary*)array;
-(void)costShareMsg:(NSDictionary*)dic;

@end
@interface ReportCost : UIView<UIScrollViewDelegate>
{
    UIScrollView*_scrollView;
    NSMutableArray*_costTotalArray;
    UIPageControl*_pageController;
    UILabel*_totalCostLabel;
    CGFloat kCostBtnHeight;
    CGFloat _namalFont;//设置字体大小 常用字
    CGFloat _costDistance;//设置间隙
    
    NSDictionary*_costDic;
    NSArray*_gudingArray;
    UILabel*_characterLabel;
    UILabel*_descriptionLable;
    NSString*_shareString;
    
}

@property(nonatomic,assign)id<ReportCostDelegate>delegate;
-(void)animateStart;
-(void)reloadData:(NSDictionary*)dic;
@property(nonatomic,strong)NSArray*costDetailArray;
@end
