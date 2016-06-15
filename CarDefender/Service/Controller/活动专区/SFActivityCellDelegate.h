//
//  SFActivityCellDelegate.h
//  CarDefender
//
//  Created by sicnu_ifox on 16/6/15.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SFActivityCellDelegate <NSObject>

- (void)onDetailInfo:(id)sender;
- (void)getDiscountCoupon:(id)sender;

@end
