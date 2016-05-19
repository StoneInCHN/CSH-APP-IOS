//
//  UILabel+Kun.h
//  UIlabelTextPG
//
//  Created by 周子涵 on 15/8/4.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Kun)
#pragma mark - 创建ttf图标
-(instancetype)initWithEmojiFrame:(CGRect)frame Text:(NSString*)text Color:(UIColor*)color FontSize:(int)fontSize;
#pragma mark - 快速创建Label
-(instancetype)initWithFrame:(CGRect)frame Text:(NSString*)text Font:(UIFont *)font Color:(UIColor*)color TextAlignment:(NSTextAlignment)textAlignment;
@end
