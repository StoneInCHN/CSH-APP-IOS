//
//  CWSMessageCell.h
//  列表多选操作
//
//  Created by 李散 on 15/6/1.
//  Copyright (c) 2015年 Mr Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *warningTitle;
@property (weak, nonatomic) IBOutlet UILabel *warningtime;
@property (weak, nonatomic) IBOutlet UILabel *warningMsg;
@property (weak, nonatomic) IBOutlet UIView *leftUnreadView;
@property (strong, nonatomic) NSDictionary*cellDic;
@end
