//
//  CWSUserMessageInfoCell.h
//  CarDefender
//
//  Created by 王泰莅 on 15/12/10.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CWSUserMessageCenterModel;
@interface CWSUserMessageInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *readFlagView;

@property (strong, nonatomic) IBOutlet UIImageView *messageImageView;

@property (strong, nonatomic) IBOutlet UILabel *messageTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *messageContentLabel;

@property (strong, nonatomic) IBOutlet UILabel *messageDateLabel;

@property (nonatomic,strong)  CWSUserMessageCenterModel* userMessageModel;




@end
