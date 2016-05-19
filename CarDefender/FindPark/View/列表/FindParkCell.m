//
//  FindParkCell.m
//  CarDefender
//
//  Created by 周子涵 on 15/8/6.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "FindParkCell.h"
#import "UIImageView+WebCache.h"

@implementation FindParkCell
-(void)reloadCell:(Park *)park{
    self.park = park;
    [self setBtnView:self.orderView];
    [self setBtnView:self.navView];
    [self.parkImageView setImageWithURL:[NSURL URLWithString:park.picUrl] placeholderImage:[UIImage imageNamed:@"zhaochewei_img.png"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
    self.nameLabel.text = park.name;
    //    self.distanceLabel.text = park.distance;
    int distance = [park.distance intValue];
    if (distance >= 1000) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%.1f千米",(float)distance/1000];
    }else{
        self.distanceLabel.text = [NSString stringWithFormat:@"%i米",distance];
    }
    self.addressLabel.text = park.addr;
    if ([park.leftNum intValue] == -1) {
        self.leftNumberLabel.text = @"--";
    }else{
        self.leftNumberLabel.text = park.leftNum;
    }
    self.priceLabel.text = park.price;
}
#pragma mark - 设置按钮边框和弧度
-(void)setBtnView:(UIView*)view{
    [Utils setViewRiders:view riders:4];
    [Utils setBianKuang:kCOLOR(200, 200, 200) Wide:1 view:view];
}
#pragma mark - 按钮点击事件
- (IBAction)navBtnClick {
    [self.delegate cellNavBtnClick:self.park];
}
@end
