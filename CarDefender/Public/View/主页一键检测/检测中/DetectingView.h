//
//  DetectingView.h
//  yijianjiance
//
//  Created by 周子涵 on 15/6/24.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DetectingDelegate <NSObject>
@optional
-(void)detectionEnd:(NSDictionary*)dataDic;
@end

@interface DetectingView : UIView
{
    UIView*       _coverView;      //覆盖View
    UIImageView*  _carImageView;   //汽车图片
    UILabel*      _percentLabel;   //百分比Lable
    UILabel*      _detectNameLabel;//检测项Label
    UILabel*      _detectMarkLabel;//数字Label
    UIImageView*  _markImageView;  //三角图片
    int           _number;         //检测项数
    CGFloat       _interval;       //间隔距离
    NSTimer*      _timer;          //时间类
    NSTimer*      _animatTimer;    //时间类
    CGFloat       _percent;        //百分比
    CGFloat       _intervalTime;   //间隔时间
    NSArray*      _dataArray;      //数值数据
    NSDictionary* _dataDic;        //数据
    BOOL          _animationStart; //检测电话标志
}
//重新设置背景图片
-(void)setGroundView;
//动画开始方法
-(void)animationStarDictionary:(NSDictionary*)dataDic;
@property (assign, nonatomic) id<DetectingDelegate> delegate;
@end
