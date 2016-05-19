//
//  ZLPhoneContactCell.h
//  宗隆
//
//  Created by 李散 on 15/3/14.
//  Copyright (c) 2015年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLPhoneContactCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;//联系人姓名
@property (weak, nonatomic) IBOutlet UILabel *phoneNub;//联系人电话
@property (weak, nonatomic) IBOutlet UILabel *time;//拨打电话时间
@property (weak, nonatomic) IBOutlet UIImageView *phoneOutOrIn;//判断电话是输入或者是输出

@end
