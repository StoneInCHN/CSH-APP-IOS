//
//  ReportTopView.h
//  报告动画
//
//  Created by 李散 on 15/5/27.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportTopView : UIView
{
    UILabel*_noDataLabel;//没有数据label
    NSDictionary*_reportDic;
    BOOL whichType;//0 默认全部或者全部被点击，1 选择时间段
    BOOL _allBool;
    NSDictionary*_currentChooseDic;
 }
@property(nonatomic,strong)NSMutableArray*pointArray;
@property(nonatomic,strong)NSDictionary *topDicMsg;
-(void)allBtnTouchDownWithPointArray:(NSArray*)array;
-(void)timeCellSelect:(NSDictionary*)dic withPointArray:(NSArray*)array;
-(void)timeCellAfterLoginMsg:(NSDictionary*)chooseDic;
@end
