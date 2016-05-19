//
//  CustomButton.h
//  按钮封装
//
//  Created by 周子涵 on 15/8/11.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, CustomButtonStyle){
    NormalStyle,               //普通风格
    CircleStyle,               //圆形风格
    RadianStyle,               //弧度风格
    BorderStyle,               //边框风格
    RadianAndBorderStyle,      //弧度加边框风格
};

@interface CustomButton : UIControl
@property (strong, nonatomic) UIView* normalView;        //默认View
@property (strong, nonatomic) UIView* highlightedView;   //高亮View
@property (strong, nonatomic) UIView* otherView;   //其他View
//初始化控件
-(instancetype)initWithFrame:(CGRect)frame NormalView:(UIView* (^)(CGRect frame))normalView AndHighlightedView:(UIView* (^)(CGRect frame))highlightedView;
+(instancetype)customButtonWithFrame:(CGRect)frame NormalView:(UIView* (^)(CGRect frame))normalView AndHighlightedView:(UIView* (^)(CGRect frame))highlightedView;
////初始化确认取消类型
//-(instancetype)initWithFrame:(CGRect)frame NormalView:(UIView* (^)(CGRect frame))normalView AndOtherView:(UIView* (^)(CGRect frame))highlightedView;
@end