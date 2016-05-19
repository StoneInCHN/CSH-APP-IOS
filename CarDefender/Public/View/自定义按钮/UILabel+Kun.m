//
//  UILabel+Kun.m
//  UIlabelTextPG
//
//  Created by 周子涵 on 15/8/4.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "UILabel+Kun.h"

@implementation UILabel (Kun)
#pragma mark - 创建ttf图标
-(instancetype)initWithEmojiFrame:(CGRect)frame Text:(NSString*)text Color:(UIColor*)color FontSize:(int)fontSize{
    self = [self initWithFrame:frame];
    if (self) {
        [self setLabelFrame:frame Text:text Font:[UIFont fontWithName:@"icomoon" size:fontSize] Color:color TextAlignment:NSTextAlignmentLeft];
    }
    return self;
}
#pragma mark - 快速创建Label
-(instancetype)initWithFrame:(CGRect)frame Text:(NSString*)text Font:(UIFont *)font Color:(UIColor*)color TextAlignment:(NSTextAlignment)textAlignment{
    self = [self initWithFrame:frame];
    if (self) {
        [self setLabelFrame:frame Text:text Font:font Color:color TextAlignment:textAlignment];
    }
    return self;
}
#pragma mark - 设置Label
-(void)setLabelFrame:(CGRect)frame Text:(NSString*)text Font:(UIFont *)font Color:(UIColor*)color TextAlignment:(NSTextAlignment)textAlignment{
    self.font = font;
    self.text = text;
    self.textColor = color;
    self.textAlignment = textAlignment;
}
@end
