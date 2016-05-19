//
//  LHPSideViewController.h
//  LHPSideDemo
//
//  Created by 李散 on 15/6/16.
//  Copyright (c) 2015年 Mr Li. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RootViewMoveBlock)(UIView *rootView,CGRect originFrame,CGFloat xoffset);
typedef void(^GestureMoveVCShowORHidden)(BOOL showORHiddenBool);//1为show 0 为hidden

@interface LHPSideViewController : UIViewController
@property (assign, nonatomic) BOOL needSwipeShowMenu;//是否开启手势滑动出菜单

@property (retain, nonatomic) UIViewController *rootViewController;//根视图
@property (retain, nonatomic) UIViewController *leftViewController;//左视图
@property (retain, nonatomic) UIViewController *rightViewController;//右视图

@property (assign, nonatomic) CGFloat leftViewShowWidth;// 左侧栏的展示大小
@property (assign, nonatomic) CGFloat rightViewShowWidth;//右侧栏的展示大小

@property (assign, nonatomic) NSTimeInterval animationDuration;// 动画时长
@property (assign, nonatomic) BOOL showBoundsShadow;//是否显示边框阴影


@property (assign, nonatomic) BOOL sideSwitch;//滑动开关
@property (copy, nonatomic) RootViewMoveBlock rootViewMoveBlock;//可再此block中重做动画效果
@property (copy, nonatomic) GestureMoveVCShowORHidden gestureMoveVCShowORHidden;//可再此block中重做动画效果

- (void)showRootViewMoveBlock:(RootViewMoveBlock)rootViewMoveBlock;
- (void)showGestureMoveVCShowORHidden:(GestureMoveVCShowORHidden)rootViewMoveBlock;

- (void)showLeftViewController:(BOOL)animated;//展示左边栏
- (void)showRightViewController:(BOOL)animated;//展示右边栏
- (void)hideSideViewController:(BOOL)animated;//恢复正常位置

@end
