//
//  ZLTransparencyBackgroundView.h
//  宗隆
//
//  Created by 李散 on 15/3/13.
//  Copyright (c) 2015年 sky. All rights reserved.
//
@protocol ZLTransparencyBackgroundViewDelegate <NSObject>

-(void)ZLTransparencyBackgroundViewTouchBegin;

@end
#import <UIKit/UIKit.h>

@interface ZLTransparencyBackgroundView : UIView
@property(nonatomic,assign)id<ZLTransparencyBackgroundViewDelegate>delegate;
@end
