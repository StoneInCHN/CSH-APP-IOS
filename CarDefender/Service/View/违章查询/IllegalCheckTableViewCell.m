//
//  IllegalCheckTableViewCell.m
//  CarDefender
//
//  Created by 万茜 on 15/12/9.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "IllegalCheckTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation IllegalCheckTableViewCell


-(void)setDicMsg:(NSDictionary *)dicMsg
{
    

    NSString*url=[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"baseUrl"],dicMsg[@"brand"][@"brandIcon"]];
    NSURL*logoImgUrl=[NSURL URLWithString:url];
    [self.headImageView setImageWithURL:logoImgUrl placeholderImage:[UIImage imageNamed:@"logo"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
    
    self.carBrandLabel.text = dicMsg[@"plate"];
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
