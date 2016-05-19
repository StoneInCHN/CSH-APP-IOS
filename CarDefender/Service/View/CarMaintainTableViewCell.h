//
//  CarMaintainTableViewCell.h
//  CarDefender
//
//  Created by 王泰莅 on 15/12/6.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CWSTableViewButtonCellDelegate.h"

@interface CarMaintainTableViewCell : UITableViewCell


/**保养套餐标题*/
@property (strong, nonatomic) IBOutlet UILabel *maintainTitleLabel;


/**保养套餐内容*/
@property (strong, nonatomic) IBOutlet UILabel *maintainContentLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

/**预约按钮*/
@property (strong, nonatomic) IBOutlet UIButton *subscribeButton;


@property(nonatomic,copy) NSString* testString;

@property (nonatomic,strong)NSDictionary *dataDic;

@property (nonatomic,assign)id <CWSTableViewButtonCellDelegate>delegate;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Data:(NSDictionary *)dic;
@end
