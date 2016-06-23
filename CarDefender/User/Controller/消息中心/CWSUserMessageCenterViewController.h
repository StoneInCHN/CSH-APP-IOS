//
//  CWSUserMessageCenterViewController.h
//  CarDefender
//
//  Created by 王泰莅 on 15/12/9.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSBasicViewController.h"

@protocol BadgeValueChangeDelegate <NSObject>
- (void)badgeValueChanged;
- (void)badgeDidEmpty;
@end

@interface CWSUserMessageCenterViewController : CWSBasicViewController

@property (strong, nonatomic) id<BadgeValueChangeDelegate> delegate;

@end
