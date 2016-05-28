//
//  LHPModelCarViewCell.m
//  云车宝选车Demo
//
//  Created by pan on 14/12/19.
//  Copyright (c) 2014年 pan. All rights reserved.
//

#import "LHPModelCarViewCell.h"
#import "UIImageView+WebCache.h"
@implementation LHPModelCarViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
-(void)setModelDicMsg:(NSDictionary *)modelDicMsg{
    
#if USENEWVERSION
    self.carNameLabel.text = modelDicMsg[@"name"];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString*url=[NSString stringWithFormat:@"http://120.27.92.247:10001/csh-interface%@",modelDicMsg[@"icon"]];
    NSURL*logoImgUrl=[NSURL URLWithString:url];
    [self.carImage setImageWithURL:logoImgUrl placeholderImage:[UIImage imageNamed:@"normal_car_type"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
#else
    self.carNameLabel.text=modelDicMsg[@"type"];
    NSString*url=[NSString stringWithFormat:@"http://120.27.92.247:10001/csh-interface%@",modelDicMsg[@"icon"]];
    NSURL*logoImgUrl=[NSURL URLWithString:url];
    [self.carImage setImageWithURL:logoImgUrl placeholderImage:[UIImage imageNamed:@"normal_car_type"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
    int parent = [modelDicMsg[@"parent"] intValue];
    if(parent>0){
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
#endif
}
@end
