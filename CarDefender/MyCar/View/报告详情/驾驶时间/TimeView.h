//
//  TimeView.h
//  报告动画
//
//  Created by 李散 on 15/5/20.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TimeViewDelegate <NSObject>

-(void)timeViewFirstBtnFrame:(CGRect)timeFrame;

@end
@interface TimeView : UIView
{
    UIView*_biankuangView;//边框
    UIButton*oldTouchBtn;//上一次点击按钮
    UIButton*currentBtn;//当前按钮
    NSMutableArray*_rectArray;//保存frame
    NSMutableArray*_colorArray;//保存颜色
    BOOL _btnTouch;//加载直角坐标系完成
    BOOL _bisoshiBool;
    BOOL _currentNoData;
    NSDictionary*_currentDic;
}
@property(assign,nonatomic)BOOL timeFirstIn;
@property(nonatomic,strong)NSDictionary*timeDic;
@property(nonatomic,assign)BOOL noData;
@property(assign,nonatomic)id<TimeViewDelegate>delegate;
@end
