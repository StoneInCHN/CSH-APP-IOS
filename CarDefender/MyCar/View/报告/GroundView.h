//
//  GroundView.h
//  报告动画
//
//  Created by 周子涵 on 15/5/6.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildView.h"

@protocol GroundViewDelegate <NSObject>
@optional
-(void)animateFinish:(BOOL)isLeft;
-(void)iconClick:(NSString*)type;
@end

@interface GroundView : UIView
{
    CGFloat         _currentAngle;      //当前角度
    CGPoint         _beginPoint;        //触摸开始时的坐标
    CGPoint         _endPoint;          //结束位置坐标
    ChildView*      _childView;         //当前点击的子视图
    ChildView*      _costView1;         //主花费视图
    ChildView*      _costView2;         //副花费视图
    BOOL            _move;              //是否移动
    BOOL            _rotate;            //是否旋转
    BOOL            _left;              //是否向左滑
    UIImageView*    _groundImageView;   //主背景图片
    UIImageView*    _groundImageView2;  //副背景图片
}

@property (strong, nonatomic) NSMutableArray*           subViewList;   //主视图数组
@property (strong, nonatomic) NSMutableArray*           subViewList2;  //副视图数组
@property (assign, nonatomic) id<GroundViewDelegate>    delegate;      //代理协议

- (id)initWithFrame:(CGRect)frame dataArray:(NSArray*)dataArray cost:(NSString*)cost;
#pragma mark - 刷新数据
-(void)reloadData:(NSArray*)array cost:(NSString*)cost;
@end


