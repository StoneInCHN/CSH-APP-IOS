//
//  TableViewCell.h
//  BATableView
//
//  Created by TY on 14-7-23.
//  Copyright (c) 2014年 abel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (strong, nonatomic) NSDictionary*dicMsg;
@property (weak, nonatomic) IBOutlet UILabel *textlabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UIImageView *imgSecond;

@end
