//
//  LHPSideViewController.m
//  LHPSideDemo
//
//  Created by 李散 on 15/6/16.
//  Copyright (c) 2015年 Mr Li. All rights reserved.
//

#import "LHPSideViewController.h"
#import "CWSLeftController.h"
#import "CWSRightController.h"
#import "CWSMainViewController.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface LHPSideViewController ()<UIGestureRecognizerDelegate>
{
    UIView *_baseView;//目前是_baseVew
    UIView *_currentView;//其实就是rootViewController.view
    
    UIPanGestureRecognizer *_panGestureRecognizer;
    
    CGPoint _startPanPoint;//开始的坐标点
    CGPoint _lastPanPoint;//最后一个坐标点
    BOOL _panMovingRightOrLeft;//true是向右，fale是向左
    
    UIButton *_coverButton;//覆盖按钮
    
    CWSLeftController*_leftVC;//左视图
    CWSRightController*_rightVC;//右视图
    BOOL _showORHiddenOnce;//手势只触发一次
}

@end

@implementation LHPSideViewController
-(void)showRootViewMoveBlock:(RootViewMoveBlock)rootViewMoveBlock
{
    
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //Custom initialization
        _leftViewShowWidth = 240;//左视图滑动宽度
        _rightViewShowWidth = 0;//定义右视图滑动宽度
        
        _animationDuration = 0.35;//动画时间
        _showBoundsShadow = false;//是否显示阴影
        
        //手势
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(gestrueEvent:)];
        [_panGestureRecognizer setDelegate:self];
        
        _panMovingRightOrLeft = false;
        _lastPanPoint = CGPointZero;
        self.sideSwitch=YES;
        _coverButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height)];
        [_coverButton addTarget:self action:@selector(hideSideViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(id)init
{
    return  [self initWithNibName:nil bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _showORHiddenOnce = YES;
    _baseView = self.view;
//    [_baseView setBackgroundColor:[UIColor colorWithRed:0.5 green:0.6 blue:0.8 alpha:1]];
    [_baseView setBackgroundColor:[UIColor whiteColor]];
    self.needSwipeShowMenu = true;
    [self setNeedSwipeShowMenu:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.rootViewController) {
        NSAssert(false, @"you must set rootViewController!!");
    }
    if (_currentView!=_rootViewController.view) {
        [_currentView removeFromSuperview];
        _currentView=_rootViewController.view;
        [_baseView addSubview:_currentView];
        _currentView.frame=_baseView.bounds;
    }
}
- (void)setRootViewController:(UIViewController *)rootViewController{
    if (_rootViewController!=rootViewController) {
        if (_rootViewController) {
            [_rootViewController removeFromParentViewController];
        }
        _rootViewController=rootViewController;
        if (_rootViewController) {
            [self addChildViewController:_rootViewController];
        }
    }
}
-(void)setLeftViewController:(UIViewController *)leftViewController{
    if (_leftViewController!=leftViewController) {
        if (_leftViewController) {
            [_leftViewController removeFromParentViewController];
        }
        _leftViewController=leftViewController;
        _leftVC=(CWSLeftController*)leftViewController;
        if (_leftViewController) {
            [self addChildViewController:_leftViewController];
        }
    }
}
-(void)setRightViewController:(UIViewController *)rightViewController{
    if (_rightViewController!=rightViewController) {
        if (_rightViewController) {
            [_rightViewController removeFromParentViewController];
        }
        _rightViewController=rightViewController;
        _rightVC=(CWSRightController*)rightViewController;
        if (_rightViewController) {
            [self addChildViewController:_rightViewController];
        }
    }
}
- (void)setNeedSwipeShowMenu:(BOOL)needSwipeShowMenu{
    _needSwipeShowMenu = needSwipeShowMenu;
    if (needSwipeShowMenu) {
        [_baseView addGestureRecognizer:_panGestureRecognizer];
    }else{
        [_baseView removeGestureRecognizer:_panGestureRecognizer];
    }
}
- (void)showShadow:(BOOL)show{
    _currentView.layer.shadowOpacity    = show ? 0.8f : 0.0f;
    if (show) {
        _currentView.layer.cornerRadius = 4.0f;
        _currentView.layer.shadowOffset = CGSizeZero;
        _currentView.layer.shadowRadius = 4.0f;
        _currentView.layer.shadowPath   = [UIBezierPath bezierPathWithRect:_currentView.bounds].CGPath;
    }
}
#pragma mark  ShowOrHideTheView
- (void)willShowLeftViewController{
    if (!_leftViewController || _leftViewController.view.superview) {
        return;
    }
    //左视图将要展示
    [_leftVC leftViewWillAppear];
    
    _leftViewController.view.frame=_baseView.bounds;
    [_baseView insertSubview:_leftViewController.view belowSubview:_currentView];
    if (_rightViewController && _rightViewController.view.superview) {
        [_rightViewController.view removeFromSuperview];
    }
}
- (void)willShowRightViewController{
    if (!_rightViewController || _rightViewController.view.superview) {
        return;
    }
    //右侧试图将要显示
//    [_rightVC rightViewWillAppear];
    _rightViewController.view.frame=_baseView.bounds;
    [_baseView insertSubview:_rightViewController.view belowSubview:_currentView];
    if (_leftViewController && _leftViewController.view.superview) {
        [_leftViewController.view removeFromSuperview];
    }
}
- (void)showLeftViewController:(BOOL)animated{
    if (!_leftViewController) {
        return;
    }
    [self willShowLeftViewController];
    NSTimeInterval animatedTime=0;
    if (animated) {
        animatedTime = ABS(_leftViewShowWidth - _currentView.frame.origin.x) / _leftViewShowWidth * _animationDuration;
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:animatedTime animations:^{
        //左视图展示完毕
        [_leftVC leftViewDidAppear];
        
        [self layoutCurrentViewWithOffset:_leftViewShowWidth];
        [_currentView addSubview:_coverButton];
        [self showShadow:_showBoundsShadow];
    }];
}
- (void)showRightViewController:(BOOL)animated{
    if (!_rightViewController) {
        return;
    }
    [self willShowRightViewController];
    NSTimeInterval animatedTime = 0;
    if (animated) {
        animatedTime = ABS(_rightViewShowWidth + _currentView.frame.origin.x) / _rightViewShowWidth * _animationDuration;
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:animatedTime animations:^{
        //左侧试图显示完成
//        [_rightVC rightViewDidAppear];
        [self layoutCurrentViewWithOffset:-_rightViewShowWidth];
        [_currentView addSubview:_coverButton];
        [self showShadow:_showBoundsShadow];
    }];
}
- (void)hideSideViewController:(BOOL)animated{
    [self showShadow:false];
    NSTimeInterval animatedTime = 0;
    int leftOrRight=0;//1为左  2为右
    if (animated) {
        animatedTime = ABS(_currentView.frame.origin.x / (_currentView.frame.origin.x>0?_leftViewShowWidth:_rightViewShowWidth)) * _animationDuration;
        leftOrRight=_currentView.frame.origin.x>0?1:2;
    }
    if (leftOrRight==1) {//左侧将要隐藏
        [_leftVC leftViewWillDisappear];
    }else if (leftOrRight==2){//右侧将要隐藏
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:animatedTime animations:^{
        [self layoutCurrentViewWithOffset:0];
        if (leftOrRight==1) {//左滑了隐藏
            [_leftVC leftViewDidDisappear];
        }else if (leftOrRight==2){//右滑了隐藏
//            [_rightVC rightViewDidDisappear];
        }
    } completion:^(BOOL finished) {
        [_coverButton removeFromSuperview];
        [_leftViewController.view removeFromSuperview];
        [_rightViewController.view removeFromSuperview];
    }];
}
- (void)hideSideViewController{
    [self hideSideViewController:true];
}
#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // Check for horizontal pan gesture
    if (gestureRecognizer == _panGestureRecognizer) {
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint translation = [panGesture translationInView:_baseView];
        if ([panGesture velocityInView:_baseView].x < 600 && ABS(translation.x)/ABS(translation.y)>1) {
            return YES;
        }
        return NO;
    }
    return YES;
}
- (void)gestrueEvent:(UIPanGestureRecognizer*)pan{
    if (!self.sideSwitch) {
        return;
    }
    if (_panGestureRecognizer.state==UIGestureRecognizerStateBegan) {
        _startPanPoint=_currentView.frame.origin;
        if (_currentView.frame.origin.x==0) {
            [self showShadow:_showBoundsShadow];
        }
        CGPoint velocity=[pan velocityInView:_baseView];
        if(velocity.x>0){
            if (_currentView.frame.origin.x>=0 && _leftViewController && !_leftViewController.view.superview) {
                [self willShowLeftViewController];
            }
        }else if (velocity.x<0) {
            if (_currentView.frame.origin.x<=0 && _rightViewController && !_rightViewController.view.superview) {
                [self willShowRightViewController];
            }
        }
        return;
    }
    CGPoint currentPostion = [pan translationInView:_baseView];
    CGFloat xoffset = _startPanPoint.x + currentPostion.x;
    if (xoffset>0) {//向右滑
        if (_leftViewController && _leftViewController.view.superview) {
            xoffset = xoffset>_leftViewShowWidth?_leftViewShowWidth:xoffset;
        }else{
            xoffset = 0;
        }
    }else if(xoffset<0){//向左滑
        if (_rightViewController && _rightViewController.view.superview) {
            xoffset = xoffset<-_rightViewShowWidth?-_rightViewShowWidth:xoffset;
        }else{
            xoffset = 0;
        }
    }
    if (xoffset!=_currentView.frame.origin.x) {
        [self layoutCurrentViewWithOffset:xoffset];
    }
    if (_panGestureRecognizer.state==UIGestureRecognizerStateEnded) {
        if (_currentView.frame.origin.x!=0 && _currentView.frame.origin.x!=_leftViewShowWidth && _currentView.frame.origin.x!=-_rightViewShowWidth) {
            if (_panMovingRightOrLeft && _currentView.frame.origin.x>20) {
                [self showLeftViewController:true];
            }else if(!_panMovingRightOrLeft && _currentView.frame.origin.x<-20){
                [self showRightViewController:true];
            }else{
                [self hideSideViewController];
            }
        }else if (_currentView.frame.origin.x==0) {
            [self showShadow:false];
        }
        MyLog(@"------->>>>>%f",_currentView.frame.origin.x);
        if (_currentView.frame.origin.x == 240) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"SIDER_SHOW_OR_HIDDEN" object:@YES];
        }else if(_currentView.frame.origin.x == 0){
            [[NSNotificationCenter defaultCenter]postNotificationName:@"SIDER_SHOW_OR_HIDDEN" object:@NO];
        }
        _lastPanPoint = CGPointZero;
        _showORHiddenOnce = YES;
    }else{
        CGPoint velocity = [pan velocityInView:_baseView];
        if (velocity.x>0) {
            _panMovingRightOrLeft = true;
            if (_showORHiddenOnce) {
                _showORHiddenOnce = NO;
                [_currentView addSubview:_coverButton];
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"SIDER_SHOW_OR_HIDDEN" object:@YES];
            }
        }else if(velocity.x<0){
            if (_showORHiddenOnce) {
                _showORHiddenOnce = NO;
                [_coverButton removeFromSuperview];
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"SIDER_SHOW_OR_HIDDEN" object:@NO];
            }
            _panMovingRightOrLeft = false;
        }
    }
}
//重写此方法可以改变动画效果,PS._currentView就是RootViewController.view
- (void)layoutCurrentViewWithOffset:(CGFloat)xoffset{
    if (_showBoundsShadow) {
        _currentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_currentView.bounds].CGPath;
    }
    if (self.rootViewMoveBlock) {//如果有自定义动画，使用自定义的效果
        self.rootViewMoveBlock(_currentView,_baseView.bounds,xoffset);
        return;
    }
    /*平移的动画
     [_currentView setFrame:CGRectMake(xoffset, _baseView.bounds.origin.y, _baseView.frame.size.width, _baseView.frame.size.height)];
     return;
     //*/
    
    //    /*平移带缩放效果的动画
    //    static CGFloat h2w = 0;
    //    if (h2w==0) {
    //        h2w = _baseView.frame.size.height/_baseView.frame.size.width;
    //    }
    CGFloat scale = 1;
    //    scale = MAX(0.8, scale);
    //    _currentView.transform = CGAffineTransformMakeScale(scale, scale);
    
    CGFloat totalWidth=_baseView.frame.size.width;
    CGFloat totalHeight=_baseView.frame.size.height;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        totalHeight=_baseView.frame.size.width;
        totalWidth=_baseView.frame.size.height;
    }
    
    if (xoffset>0) {//向右滑的
        [_currentView setFrame:CGRectMake(xoffset, _baseView.bounds.origin.y + (totalHeight * (1 - scale) / 2), totalWidth * scale, totalHeight * scale)];
    }else{//向左滑的
        [_currentView setFrame:CGRectMake(_baseView.frame.size.width * (1 - scale) + xoffset, _baseView.bounds.origin.y + (totalHeight*(1 - scale) / 2), totalWidth * scale, totalHeight * scale)];
    }
    //*/
}

@end
