//
//  CWSDetectionCell.m
//  CarDefender
//
//  Created by 李散 on 15/6/29.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSDetectionCell.h"

//#define kFont_red [UIColor colorWithRed:83.0/255.0 green:187.0/255.0 blue:31.0/255.0 alpha:1]
//#define kFont_Green [UIColor colorWithRed:83.0/255.0 green:187.0/255.0 blue:31.0/255.0 alpha:1]
//#define kFont_Orange [UIColor colorWithRed:83.0/255.0 green:187.0/255.0 blue:31.0/255.0 alpha:1]

@implementation CWSDetectionCell

-(void)reloadData:(NSDictionary*)dicMsg{
    self.dicMsg = dicMsg;
    NSString*detailString;
    if ([dicMsg[@"type"] isEqualToString:@"1"]) {
        detailString = dicMsg[@"value"];
    }else if ([dicMsg[@"type"] isEqualToString:@"2"]) {
        BOOL lState = [dicMsg[@"fault"] boolValue];
        if (lState) {
            self.markView.hidden = NO;
            self.markLabel.text = dicMsg[@"value"];
        }else{
            detailString = dicMsg[@"value"];
        }
    }else if([dicMsg[@"type"] isEqualToString:@"3"]) {
//        NSArray* lArray = dicMsg[@"value"];
//        if (lArray.count) {
//            self.findFaultBtn.hidden = NO;
//        }else{
//            detailString = @"-";
//        }
        
        if ([dicMsg[@"name"] rangeOfString:@"-"].location != NSNotFound) {
            detailString = @"-";
        }else{
            detailString = dicMsg[@"name"];
        }
        self.nameLabel.text = @"故障码";
        self.detailMsgLabel.text = detailString;
        return;
    }
    self.detailMsgLabel.text = detailString;
    BOOL state = [dicMsg[@"fault"] boolValue];
    if (state) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@%@!",dicMsg[@"name"],dicMsg[@"unit"]];
        self.nameLabel.textColor = [UIColor redColor];
        self.detailMsgLabel.textColor = [UIColor redColor];
    }else{
        self.nameLabel.text = [NSString stringWithFormat:@"%@%@",dicMsg[@"name"],dicMsg[@"unit"]];
    }
}

#pragma mark - 养护状态按钮点击事件
- (IBAction)markBtnClick {
    [self.delegate detectionCellClick:self.dicMsg];
}

#pragma mark - 故障码按钮点击事件
- (IBAction)findFaultBtnClick {
    [self.delegate detectionCellClick:self.dicMsg];
}
@end
