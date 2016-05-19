//
//  CWSUserMessageInfoCell.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/10.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSUserMessageInfoCell.h"

#import "CWSUserMessageCenterModel.h"
@implementation CWSUserMessageInfoCell



-(void)setUserMessageModel:(CWSUserMessageCenterModel *)userMessageModel{
    
    _userMessageModel = userMessageModel;
    self.messageImageView.layer.masksToBounds = YES;
    self.messageImageView.layer.cornerRadius = 5.0f;
//    switch(userMessageModel.messageType){
//        case @"PERSONALMSG":{
//            
//        };break;
//        case 1:{
//            self.messageImageView.image = [UIImage imageNamed:@"message_baojing"];
//           
//        };break;
//        case 2:{
//             self.messageImageView.image = [UIImage imageNamed:@"message_huodong"];
//            
//        };break;
//        case 3:{
//             self.messageImageView.image = [UIImage imageNamed:@"message_banben"];
//            
//        };break;
//        case 4:{
//            self.messageImageView.image = [UIImage imageNamed:@"message_jiaoyi"];
//            
//        };break;
//        case 5:{
//            self.messageImageView.image = [UIImage imageNamed:@"message_dongtai"];
//        };break;
//        
//        default:break;
//    }
    self.messageImageView.image = [UIImage imageNamed:@"message_dongtai"];
    self.messageDateLabel.text = userMessageModel.messageDate;
    self.messageTitleLabel.text = userMessageModel.messageTitle;
    self.messageContentLabel.text = userMessageModel.messageContent;
    NSLog(@"is selected :%d",self.isSelected);
    if (userMessageModel.isSelected) {
        self.readFlagView.backgroundColor = [UIColor whiteColor];
    } else {
        self.readFlagView.backgroundColor = [UIColor redColor];
    }
}

- (IBAction)buttonClicked:(UIButton *)sender {
    NSLog(@"查看消息");
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
