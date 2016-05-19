//
//  CustomButton.m
//  按钮封装
//
//  Created by 周子涵 on 15/8/11.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

-(instancetype)initWithFrame:(CGRect)frame NormalView:(UIView* (^)(CGRect frame))normalView AndHighlightedView:(UIView* (^)(CGRect frame))highlightedView{
    self = [super initWithFrame:frame];
    if (self) {
        self.normalView = normalView(frame);
        if (highlightedView == nil) {
            self.highlightedView = normalView(frame);
        }else{
            self.highlightedView = highlightedView(frame);
        }
        [self addSubview:self.highlightedView];
        self.highlightedView.hidden = YES;
        [self addSubview:self.normalView];
    }
    return self;
}
+(instancetype)customButtonWithFrame:(CGRect)frame NormalView:(UIView* (^)(CGRect frame))normalView AndHighlightedView:(UIView* (^)(CGRect frame))highlightedView{
    CustomButton* customButton = [[CustomButton alloc] initWithFrame:frame NormalView:normalView AndHighlightedView:highlightedView];
    return customButton;
}
//-(instancetype)initWithFrame:(CGRect)frame NormalView:(UIView* (^)(CGRect frame))normalView AndOtherView:(UIView* (^)(CGRect frame))highlightedView{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.normalView = normalView(frame);
//        if (highlightedView == nil) {
//            self.highlightedView = normalView(frame);
//        }else{
//            self.highlightedView = highlightedView(frame);
//        }
//        [self addSubview:self.highlightedView];
//        self.highlightedView.hidden = YES;
//        [self addSubview:self.normalView];
//    }
//    return self;
//}
#pragma mark - 控件触摸开始
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    self.normalView.hidden = YES;
    self.highlightedView.hidden = NO;
    return YES;
}
#pragma mark - 控件触摸结束
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    self.highlightedView.hidden = YES;
    self.normalView.hidden = NO;
}
@end
