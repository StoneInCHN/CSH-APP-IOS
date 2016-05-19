/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  *  自定义textview  定义placeholder的参数和颜色
  */
#import <UIKit/UIKit.h>

@interface EMTextView : UITextView
{
    UIColor *_contentColor;//内容颜色
    BOOL _editing; //是否编辑
}

@property(strong, nonatomic) NSString *placeholder;//展位字字符
@property(strong, nonatomic) UIColor *placeholderColor;//展位字字符颜色

@end
