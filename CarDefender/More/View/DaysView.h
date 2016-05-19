//
//  DaysView.h
//  test
//
//  Created by sky on 14-8-21.
//  Copyright (c) 2014年 HCYunAPP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaysView : UIView
@property (strong, nonatomic) UILabel *numberLabel;
@property (strong, nonatomic) UIButton *imageBtn;
@property (assign, nonatomic) BOOL isQianDao;
- (id)initWithFrame:(CGRect)frame number:(int)number;
@end
