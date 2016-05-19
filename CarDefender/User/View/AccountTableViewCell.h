//
//  AccountTableViewCell.h
//  MyAccountViewController
//
//  Created by 万茜 on 15/12/2.
//  Copyright © 2015年 万茜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView         *headImage;//图标
@property (nonatomic,strong)UILabel             *titleLabel;//标题
@property (nonatomic,strong)UILabel             *messageLabel;//信息

- (void)loadData:(NSDictionary *)dic;
@end
