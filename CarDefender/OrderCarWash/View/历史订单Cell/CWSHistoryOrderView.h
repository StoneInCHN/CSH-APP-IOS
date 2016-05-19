//
//  CWSHistoryOrderView.h
//  CarDefender
//
//  Created by 周子涵 on 15/10/12.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderConfirmView.h"
@class CWSHistoryOrder;

@interface CWSHistoryOrderView : UIView
{
    UIImageView* _imageView;
    UIImageView* _stateImageView;
    UILabel*     _nameLabel;
    UILabel*     _orderLabel;
    UILabel*     _carNumberLabel;
    UILabel*     _starTimeLabel;
    UILabel*     _endTimeLabel;
    
    
    
}

@property (nonatomic,strong)UIButton*    confimButton;//订单确认;
@property (nonatomic,strong)UILabel*     argueLabel;//争议订单
@property (nonatomic,strong)OrderConfirmView*       orderConfirmView;//订单确认视图
-(void)reloadData:(CWSHistoryOrder*)historyOrder;

@end
