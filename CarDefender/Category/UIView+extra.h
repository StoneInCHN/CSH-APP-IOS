//
//  UIView+extra.h
//  ChildrenFoodSafety
//
//  Created by ZG-YUH on 15/6/4.
//  Copyright (c) 2015年 于欢. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (extra)

/**
 * 获得当前视图的结束点坐标 值为 frame 的 y + height
 */
- (CGFloat)endY;

/**
 * 获得当前视图的结束点坐标 值为 frame 的 x + width
 */
- (CGFloat)endX;

/**
 * 获得当前视图的X坐标体系
 */
- (CGFloat)X;
- (CGFloat)x;

/**
 * 获得当前视图的Y坐标体系
 */
- (CGFloat)Y;
- (CGFloat)y;

/**
 * 获得当前视图的高度
 */
- (CGFloat)H;
- (CGFloat)h;

/**
 * 获得当前视图的宽度
 */
- (CGFloat)W;
- (CGFloat)w;

/**
 * 获得View的大小
 */
- (CGSize)size;

#pragma mark 大小操作

/**
 *   设置View的大小
 *   @param size 大小参数
 *   @param width 宽度
 *   @param heith 高度
 */
- (void)setW:(float)width;
- (void)setH:(float)height;
- (void)setW:(float)width andH:(float)height;
- (void)setWH:(CGSize)size;

- (void)addW:(float)width;
- (void)addH:(float)height;
- (void)addW:(float)width andH:(float)height;

#pragma mark 叠加操作

/**
 *    设置View的位置
 *    @param position 设置view的位置
 *    @param x X坐标
 *    @param y Y坐标
 */
- (void)setX:(float)x;
- (void)setY:(float)y;
- (void)setX:(float)x andY:(float)y;
- (void)setXY:(CGPoint)point;
- (void)setPositionCenteredOnPoint:(CGPoint)position;

- (void)addX:(float)x;
- (void)addY:(float)y;
- (void)addX:(float)x andY:(float)y;

/**
 *  删除当前视图的所有子视图
 */
- (void)removeSubviews;


- (void)addTapTarget:(id)target action:(SEL)sel;

/**
 * 获得文本框
 * @param tag Tag值
 */
- (UITextField *)textfiled4Tag:(int)tag;
- (UIButton *)button4Tag:(int)tag;
- (UILabel *)label4Tag:(int)tag;
- (UIImageView *)imageView4Tag:(int)tag;



@end

