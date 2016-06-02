//
//  PublicUtils.h
//  CarDefender
//
//  Created by 周子涵 on 15/7/2.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
/***************************************************************************
 *
 * 工具类
 *
 ***************************************************************************/

@class AppDelegate;


@interface PublicUtils : NSObject
#pragma mark - 控件快速创建 ------------------------------------------------ 控件快速创建

/**
 *  快速创建imageview
 *
 *  @param frame frame值
 *  @param image 传入图片
 *
 *  @return 返回imageView
 */
+ (UIImageView *)imageViewWithFrame:(CGRect)frame withImage:(UIImage *)image;
/**
 *  快速创建uilabel
 *
 *  @param frame         frame值
 *  @param title         标题
 *  @param font          字体
 *  @param color         颜色
 *  @param bgColor       背景颜色
 *  @param textAlignment 位置（靠左、靠右、居中）
 *
 *  @return 返回uilabel
 */
+ (UILabel *)labelWithFrame:(CGRect)frame withTitle:(NSString *)title titleFontSize:(UIFont *)font textColor:(UIColor *)color backgroundColor:(UIColor *)bgColor alignment:(NSTextAlignment)textAlignment hidden:(BOOL)yOrN;

/**
 *  快速创建按钮
 *
 *  @param btnType  按钮样式
 *  @param btnFrame frame值
 *  @param bgColor  背景颜色
 *
 *  @return 返回uibutton
 */
+(UIButton *)buttonWithFrame:(CGRect)btnFrame title:(NSString*)title titleColor:(UIColor*)titleColor font:(UIFont*)font;

/**
 *  将View转换成UIImage
 */
+(UIImage*)imageFromView:(UIView *)view;

#pragma mark - 设置控件 ----------------------------------------------------- 设置控件
/**
 *  设置控件边框
 */
+(void)setBianKuang:(UIColor *)coler Wide:(CGFloat)wide view:(UIView *)view;

/**
 *  设置控件圆角
 */
+(void)setViewRiders:(UIView *)view riders:(CGFloat)riders;
/**
 *  当前试图中得按钮只可以点击一次
 */
+(void)viewsBtnTouchOnceWithView:(UIView*)view;

#pragma mark - 获取数据 ----------------------------------------------------- 获取数据

/**
 *  计算字符串长度
 *
 *  @param string 传入字符串
 *  @param font   字体
 *
 *  @return 返回尺寸
 */
+(CGSize)takeTheSizeOfString:(NSString*)string withFont:(UIFont*)font;
+(CGSize)takeTheSizeOfString:(NSString*)string withFont:(UIFont*)font withWeight:(CGFloat)weight;

#pragma mark - 判断数据 ----------------------------------------------------- 判断数据
#pragma mark - 数据转换  -------------------------------------------------------- 数据转换
/**
 *  把null转换成@“”
 */
+(NSString *)checkNSNullWithgetString:(NSObject*)lStr;
#pragma mark - 转换时间戳  ----------------------------------------------------- 其他
+(NSString *)conversionTimeStamp:(NSString*)lStr;
#pragma mark - 其他  ------------------------------------------------------------ 其他
/*
 AppDelegate
 */
+(AppDelegate *)applicationDelegate;
/**
 *  判断手机号码是否含有空格、+86、17951、横线、等情况
 */
+(NSString*)checkPhoneNubAndRemoveIllegalCharacters:(NSString *)phoneNub;
/**
 *  设置导航栏返回键
 */
+(void)changeBackBarButtonStyle:(UIViewController*)sender;

/**
 *  设置导航栏返回键与方法
 */
+(void)changeBackBarButtonStyle:(UIViewController *)sender andClickedMethod:(SEL)callBack;

/**
 *  去掉服务器返回码
 */
+(NSString*)showServiceReturnMessage:(NSString*)message;

/**
 *  判断多关键字符合与否
 */
+(BOOL)isMatchOneOfStringWithObject:(NSDictionary*)object andKey:(NSString*)key andRangeOfString:(NSString*)rangeOfString;
@end
