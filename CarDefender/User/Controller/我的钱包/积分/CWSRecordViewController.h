//
//  CWSRecordViewController.h
//  CarDefender
//
//  Created by 万茜 on 15/12/3.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSRecordViewController : UIViewController

@property (nonatomic,strong)UILabel *recordLabel;
@property (nonatomic,strong)UIButton *recordShopButton;//积分商城
@property (nonatomic,strong)UIButton *changeRecordButton;//兑换记录
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)NSString *walletId;

@end
