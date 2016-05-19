//
//  MaintainReviewTableViewCell.h
//  CarDefender
//
//  Created by 王泰莅 on 15/12/9.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CWSCarWashDetailReviewModel;
@interface NewCarWashDetailReviewCell : UITableViewCell


/**用户头像*/
@property (strong, nonatomic) IBOutlet UIImageView *userHeaderImageView;

/**用户昵称*/
@property (strong, nonatomic) IBOutlet UILabel *userNickNameLabel;


/**评论日期*/
@property (strong, nonatomic) IBOutlet UILabel *userReviewDateLabel;


/**用户评论*/
@property (strong, nonatomic) IBOutlet UILabel *userReviewLabel;


/**用户评论图片*/
@property (strong, nonatomic) IBOutlet UIView *userReviewImagesView;


/**用户评价指数视图*/
@property (strong, nonatomic) IBOutlet UIView *userReviewStarView;


@property (nonatomic,strong) CWSCarWashDetailReviewModel* thyReviewModel;

@end
