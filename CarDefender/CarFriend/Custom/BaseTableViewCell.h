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
  * 通讯录好友、群组cell自定义  自定义cell  定义了image textlabel 右移动10 下部添加线
  */

#import <UIKit/UIKit.h>

@protocol BaseTableCellDelegate;
@interface BaseTableViewCell : UITableViewCell
{
    UILongPressGestureRecognizer *_headerLongPress;//长按事件
}

@property (weak, nonatomic) id<BaseTableCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) UIView *bottomLineView;//cell顶部的分割线

@end

@protocol BaseTableCellDelegate <NSObject>

- (void)cellImageViewLongPressAtIndexPath:(NSIndexPath *)indexPath;

@end