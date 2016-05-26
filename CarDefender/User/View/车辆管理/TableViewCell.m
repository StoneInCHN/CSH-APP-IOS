//
//  TableViewCell.m
//  BATableView
//
//  Created by TY on 14-7-23.
//  Copyright (c) 2014年 abel. All rights reserved.
//

#import "TableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation TableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDicMsg:(NSDictionary *)dicMsg
{
    MyLog(@"选择汽车品牌:%@",dicMsg);

#if USENEWVERSION
    self.textLabel.text = dicMsg[@"name"];
   
#else
    self.textlabel.text=dicMsg[@"name"];
    //NSString*url=[NSString stringWithFormat:@"http://115.28.161.11:8080/XAI/appDownLoad/downLoadPhoto?path=%@",dicMsg[@"logo"]];
    NSString*url=[NSString stringWithFormat:@"http://120.27.92.247:10001/csh-interface%@",dicMsg[@"icon"]];
    NSLog(@"%@",url);
    NSURL*logoImgUrl=[NSURL URLWithString:url];
    [self.imageview setImageWithURL:logoImgUrl placeholderImage:[UIImage imageNamed:@"normal_car_brand"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
#endif

}
@end
