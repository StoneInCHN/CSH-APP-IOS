//
//  DetectionDefaultView.h
//  yijianjiance
//
//  Created by 周子涵 on 15/6/23.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetectionDefaultDelegate <NSObject>
@optional
-(void)noStart:(int)type;
-(void)detectionStart;
@end

@interface DetectionDefaultView : UIView
{
    UIImageView* _animateImageView;   //动画的ImageView
    UIImageView* _circleImageView;
    CGFloat          _rate;           //旋转的弧度
}
@property (strong, nonatomic) NSTimer* timer;
@property (assign, nonatomic) id<DetectionDefaultDelegate> delegate;
@end
