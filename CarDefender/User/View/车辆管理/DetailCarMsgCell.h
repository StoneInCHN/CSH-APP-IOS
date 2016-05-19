//
//  DetailCarMsgCell.h
//  云车宝项目
//
//  Created by renhua on 14-8-5.
//  Copyright (c) 2014年 HCYunAPP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCarMsgCell : UITableViewCell
@property (strong, nonatomic) NSDictionary*styleDic;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *detaillabel;

@end
