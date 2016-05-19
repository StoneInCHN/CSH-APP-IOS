//
//  ChildView.h
//  报告动画
//
//  Created by 周子涵 on 15/5/6.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"
#define kInterval 50
@interface ChildView : UIView
{
    UIImageView* _imageView;
}

@property (assign, nonatomic) CGFloat   currentRadian; //当前角度
@property (assign, nonatomic) CGPoint   currentCenter; //当前中心点
@property (assign, nonatomic) int       temp;          //标记
@property (strong, nonatomic) UILabel*  nameLabel;     //名字
@property (strong, nonatomic) UILabel*  dataLabel;     //值

- (id)initWithFrame:(CGRect)frame Dictionary:(NSDictionary*)dic;
- (id)initWithFrame:(CGRect)frame cost:(NSString*)cost;
-(void)reloadData:(NSDictionary*)dic;
@end
