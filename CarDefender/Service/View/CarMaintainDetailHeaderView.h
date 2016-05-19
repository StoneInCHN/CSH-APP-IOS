//
//  CarMaintainDetailHeaderView.h
//  CarDefender
//
//  Created by 王泰莅 on 15/12/6.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarMaintainDetailHeaderView : UIView

/**头部图片*/
@property (strong, nonatomic) IBOutlet UIImageView *titleImageView;


/**保养名称*/
@property (strong, nonatomic) IBOutlet UILabel *maintainTitleLabel;


/**保养广告*/
@property (strong, nonatomic) IBOutlet UILabel *maintainAdWordLabel;


/**商店图片*/
@property (strong, nonatomic) IBOutlet UIImageView *storeImageView;


/**商店名称*/
@property (strong, nonatomic) IBOutlet UILabel *storeNameLabel;


/**商店评价*/
@property (strong, nonatomic) IBOutlet UIView *storeReviewView;


/**商店地址*/
@property (strong, nonatomic) IBOutlet UILabel *storeAddressLabel;




@end
