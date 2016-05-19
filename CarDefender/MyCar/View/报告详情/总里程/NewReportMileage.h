//
//  NewReportMileage.h
//  报告动画
//
//  Created by 李散 on 15/5/27.
//  Copyright (c) 2015年 SKY. All rights reserved.
//
@protocol NewReportMileageDelegate <NSObject>

-(void)newReportMileageShareMsgDic:(NSDictionary*)dicMsg;

@end
#import <UIKit/UIKit.h>
#import "ReportTopView.h"
@interface NewReportMileage : UIView<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    BOOL _noData;//判断是否有数据
    BOOL _firstGetIn;//判断是不是第一次进入
    UIView*_topBaseView;
    UILabel*_noDataLabel;//没有数据label
    UIScrollView*_scrollView;
    UITableView*_tableView;
    NSArray*_tableArray;

    ReportTopView*_topView;//柱状图View
    UIButton*_allTimeBtn;//全部  按钮
    NSIndexPath*_selectPath;
    
    NSMutableArray*_pointArray;
    UIScrollView*_timeScrollView;
    BOOL hisAppearOrDisapp;//yes 显示， no为不显示
    NSDictionary*_dicMsg;
    
    
    //创建柱状图底部部件
    UILabel*_currentMilLabel;//您当日驾驶里程为
    UILabel*_milLabel;//里程数据
    UILabel*_contentLabel;//内容
    UILabel*_descriptionLabel;//描述司机内容
    UIButton*_shareBtn;//分享按钮
    
    NSString*_shareString;
}
@property(nonatomic,assign)id<NewReportMileageDelegate>delegate;
-(void)loadView;
-(void)reloadDataWithDic:(NSDictionary*)dic;
@end
