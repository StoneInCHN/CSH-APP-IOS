//
//  DetailCarMsgCell.m
//  云车宝项目
//
//  Created by renhua on 14-8-5.
//  Copyright (c) 2014年 HCYunAPP. All rights reserved.
//

#import "DetailCarMsgCell.h"

@implementation DetailCarMsgCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setStyleDic:(NSDictionary *)styleDic
{
    self.titlelabel.text=styleDic[@"name"];
 //   self.imageview.image=[UIImage imageNamed:@"car_sure"];
 //   self.detaillabel.text=styleDic[@"gearbox"];
}
@end
