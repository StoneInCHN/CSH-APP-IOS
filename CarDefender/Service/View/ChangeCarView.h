//
//  changeCarView.h
//  CarDefender
//
//  Created by sicnu_ifox on 16/5/21.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeCarView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *myTableView;
@end
