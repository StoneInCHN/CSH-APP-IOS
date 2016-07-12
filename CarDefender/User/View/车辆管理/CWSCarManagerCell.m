//
//  CWSCarManagerCell.m
//  CarDefender
//
//  Created by 李散 on 15/4/6.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSCarManagerCell.h"
#import "UIImageView+WebCache.h"
@implementation CWSCarManagerCell
-(void)setDicMsg:(NSDictionary *)dicMsg
{

    NSString*url=[NSString stringWithFormat:@"%@%@",kBaseUrl,dicMsg[@"brandIcon"]];
    NSURL*logoImgUrl=[NSURL URLWithString:url];
    self.carBrandImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.carBrandImage setImageWithURL:logoImgUrl placeholderImage:[UIImage imageNamed:@"logo"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
//    self.clickImagView.hidden = YES;
//    if ([dicMsg[@"carId"] isEqualToString:KUserManager.car.carId]) {
//        self.clickImagView.hidden = NO;
//    }
//    self.carNubLabel.text=dicMsg[@"plate"];
//    if (![[NSString stringWithFormat:@"%@",dicMsg[@"device"]] length]) {
//        self.noIDLabel.text=@"(未绑定设备)";
//    }else{
//        if (KUserManager.type) {//隐藏
//            self.noIDLabel.text=@"";
//        }else{
////            if ([dicMsg[@"feed"] intValue]) {
////                self.noIDLabel.text=@"点击选择回馈";
////            }else
//                self.noIDLabel.text=@"";
//        }
//    }
    NSMutableAttributedString* carNumberAttributeString = nil;
    
    if([[NSString stringWithFormat:@"%@",dicMsg[@"deviceNo"]] isEqualToString:@"<null>"]){
         carNumberAttributeString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",dicMsg[@"plate"],@"(未绑定设备)"]];
        NSString* currentPlate = [NSString stringWithFormat:@"%@",dicMsg[@"plate"]];
        [carNumberAttributeString addAttributes:@{NSForegroundColorAttributeName : KBlueColor} range:NSMakeRange(currentPlate.length,carNumberAttributeString.length-currentPlate.length)];
    }else{
        carNumberAttributeString = [[NSMutableAttributedString alloc]initWithString:dicMsg[@"plate"]];
    }
    
    self.carNumberLabel.attributedText = carNumberAttributeString;
    //self.carTypeLabel.text = [NSString stringWithFormat:@"%@%@",dicMsg[@"brand"][@"brandName"],dicMsg[@"brand"][@"moduleName"]];
    self.carTypeLabel.text = [NSString stringWithFormat:@"%@",dicMsg[@"vehicleFullBrand"]];
    
//    self.defaultLabel.hidden = [dicMsg[@"isDefault"] integerValue] ? NO : YES;
 
        if([dicMsg[@"isDefault"]integerValue] ==1){
            self.defaultLabel.hidden = NO;
            self.defaultLabel.text = @"[默认]";
            self.selectButton.selected = YES;
        }
        else {
            self.defaultLabel.hidden = YES;
            self.selectButton.selected = NO;
        }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
