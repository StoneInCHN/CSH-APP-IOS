//
//  CWSRemainMoneyViewController.h
//  CarDefender
//
//  Created by 万茜 on 15/12/3.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSRemainMoneyViewController : UIViewController

@property (nonatomic,strong)UILabel *moneyLabel;//余额
@property (weak, nonatomic) IBOutlet UIButton *moneyButton;//充值按钮

@property (weak, nonatomic) IBOutlet UIButton *buyButton;//购买按钮
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)NSString *moneyString;
@property (nonatomic,copy)NSString *walletId;
@property (nonatomic,assign)NSInteger identifier; //支付成功返回界面提示支付成功

@end
