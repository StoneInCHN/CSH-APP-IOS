//
//  MaintainReviewTableViewCell.h
//  CarDefender
//
//  Created by 王泰莅 on 15/12/9.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CWSCarMaintainInfoModel;
@interface MaintainReviewTableViewCell : UITableViewCell


/**用户头像*/
@property (strong, nonatomic) IBOutlet UIImageView *userHeaderImageView;

/**用户昵称*/
@property (strong, nonatomic) IBOutlet UILabel *userNickNameLabel;


/**评论日期*/
@property (strong, nonatomic) IBOutlet UILabel *userReviewDateLabel;


/**用户评论*/
@property (strong, nonatomic) IBOutlet UILabel *userReviewLabel;


@property (nonatomic,strong) CWSCarMaintainInfoModel* reviewModel;

@end
